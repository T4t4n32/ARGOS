from __future__ import annotations

"""ARGOS robot entry-point — full hardware mode.

Subsystems
----------
* Hotspot WiFi  — nmcli-managed AP (``ARGOS-KAIROS``)
* Video server  — mediamtx + ffmpeg RTSP pipeline
* Vision / AI   — YOLOv8 on CPU in a daemon thread
* Motors        — ControlMotores (lgpio or stub)
* LoRa receiver — command ingestion from remote operator
* Gas sensor    — MQ-5 digital (emergency stop)

Run
---
``argos-main`` (installed via pyproject.toml) or directly::

    python -m argos_app.main
"""

import logging
import os
import subprocess
import threading
import time
from pathlib import Path

import cv2
from ultralytics import YOLO

from .decision.motores import ControlMotores
from .comms.lora import LoRaReceiver
from .sensors.mq5 import SensorMQ5

logger = logging.getLogger(__name__)

# ── Video pipeline constants ───────────────────────────────────────────────────
CAMARA_ID   = 0
CONFIANZA   = 0.4
ANCHO       = 640
ALTO        = 480
FPS         = 20
RTSP_URL    = "rtsp://localhost:8554/cam"

_PKG_DIR    = Path(__file__).resolve().parent
RUTA_MODELO = _PKG_DIR / "vision" / "Modelos" / "Mon1.0.pt"
MEDIAMTX    = "/home/argos/mediamtx"

# ── Hotspot constants ──────────────────────────────────────────────────────────
HOTSPOT_SSID     = "ARGOS-KAIROS"
HOTSPOT_PASSWORD = "argos2026"
HOTSPOT_IP       = "192.168.4.1/24"
HOTSPOT_CON_NAME = "argos-hotspot"
HOTSPOT_IFACE    = "wlan0"


###############################################################################
# Network / video helpers
###############################################################################


def iniciar_red_local() -> None:
    """Create and activate an nmcli Wi-Fi AP connection.

    Uses NetworkManager (nmcli) — the default on Raspberry Pi OS Bookworm.
    The old hostapd + dnsmasq approach is *incompatible* with NetworkManager
    and must not be used.

    The connection is created only if it does not already exist, so repeated
    calls (e.g. systemd service restarts) are idempotent.
    """
    logger.info("Configurando hotspot WiFi '%s' via nmcli...", HOTSPOT_SSID)

    # Check whether the named connection already exists.
    result = subprocess.run(
        ["nmcli", "-t", "-f", "NAME", "con", "show"],
        capture_output=True,
        text=True,
    )
    existing = [line.strip() for line in result.stdout.splitlines()]

    if HOTSPOT_CON_NAME not in existing:
        logger.info("Creando conexión nmcli '%s'...", HOTSPOT_CON_NAME)
        subprocess.run(
            [
                "sudo", "nmcli", "con", "add",
                "type",       "wifi",
                "ifname",     HOTSPOT_IFACE,
                "con-name",   HOTSPOT_CON_NAME,
                "autoconnect","yes",
                "ssid",       HOTSPOT_SSID,
                "--",
                "wifi.mode",                "ap",
                "wifi-sec.key-mgmt",        "wpa-psk",
                "wifi-sec.psk",             HOTSPOT_PASSWORD,
                "ipv4.method",              "shared",
                "ipv4.addresses",           HOTSPOT_IP,
                "connection.autoconnect-priority", "10",
            ],
            check=True,
        )
    else:
        logger.info("Conexión '%s' ya existe — reutilizando.", HOTSPOT_CON_NAME)

    subprocess.run(["sudo", "nmcli", "con", "up", HOTSPOT_CON_NAME], check=True)
    time.sleep(3)
    logger.info("Red WiFi '%s' activa  (IP: %s)", HOTSPOT_SSID, HOTSPOT_IP.split("/")[0])
    print(f"✅ Red WiFi '{HOTSPOT_SSID}' activa — IP: {HOTSPOT_IP.split('/')[0]}")


def iniciar_mediamtx() -> subprocess.Popen:
    """Launch the mediamtx RTSP server as a background process."""
    logger.info("Iniciando servidor de video mediamtx...")
    proc = subprocess.Popen(
        [MEDIAMTX],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    time.sleep(3)
    logger.info("Servidor de video listo.")
    print("✅ Servidor de video listo")
    return proc


def iniciar_ffmpeg(ancho: int, alto: int, fps: int, rtsp_url: str) -> subprocess.Popen:
    """Spawn an ffmpeg process that reads raw BGR frames from stdin and pushes
    them to the RTSP server as H.264.
    """
    comando = [
        "ffmpeg", "-y",
        "-f",       "rawvideo",
        "-vcodec",  "rawvideo",
        "-pix_fmt", "bgr24",
        "-s",       f"{ancho}x{alto}",
        "-r",       str(fps),
        "-i",       "pipe:0",
        "-c:v",     "libx264",
        "-preset",  "ultrafast",
        "-tune",    "zerolatency",
        "-pix_fmt", "yuv420p",
        "-f",       "rtsp",
        rtsp_url,
    ]
    return subprocess.Popen(
        comando,
        stdin=subprocess.PIPE,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


###############################################################################
# Camera / AI thread
###############################################################################


def hilo_camara_ia(
    modelo: YOLO,
    camara: cv2.VideoCapture,
    ffmpeg_proc: subprocess.Popen,
    stop_event: threading.Event,
) -> None:
    """Capture frames, run YOLOv8 inference every 3rd frame, stream via ffmpeg.

    Inference is skipped on non-keyframes to keep CPU load manageable on
    Raspberry Pi 5.
    """
    logger.info("Hilo de cámara + IA iniciado.")
    print("🎥 Cámara con IA iniciada")
    print(f"   Ver en celular: http://argos.local:8888/cam")

    contador = 0
    ultimo_frame: cv2.typing.MatLike | None = None

    while not stop_event.is_set():
        ret, frame = camara.read()
        if not ret:
            continue

        contador += 1

        if contador % 3 == 0:
            resultados = modelo(frame, conf=CONFIANZA, imgsz=320, verbose=False)
            ultimo_frame = resultados[0].plot()
            for det in resultados[0].boxes:
                clase_id = int(det.cls[0])
                nombre   = modelo.names[clase_id]
                conf     = float(det.conf[0])
                logger.debug("Detección: %s (%.0f%%)", nombre, conf * 100)
                print(f"  🔍 {nombre} ({conf:.0%})")
        else:
            ultimo_frame = frame

        if ultimo_frame is not None:
            frame_salida = cv2.resize(ultimo_frame, (ANCHO, ALTO))
            try:
                ffmpeg_proc.stdin.write(frame_salida.tobytes())  # type: ignore[union-attr]
            except BrokenPipeError:
                logger.warning("Stream de video interrumpido (BrokenPipe).")
                print("⚠️  Stream de video interrumpido")
                break

    logger.info("Hilo de cámara + IA detenido.")


###############################################################################
# Entry point
###############################################################################


def main() -> None:
    """Bootstrap all ARGOS subsystems and enter the main command loop."""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%H:%M:%S",
    )

    print("=" * 42)
    print("   ARGOS - Robot Explorador")
    print("=" * 42)

    # ── 1. Hotspot ─────────────────────────────────────────────────────────
    try:
        iniciar_red_local()
    except subprocess.CalledProcessError as exc:
        logger.error("Error al configurar el hotspot: %s", exc)
        print(f"⚠️  Hotspot no disponible: {exc}")

    # ── 2. Video server ────────────────────────────────────────────────────
    mediamtx_proc = iniciar_mediamtx()

    # ── 3. YOLO model ──────────────────────────────────────────────────────
    print("🤖 Cargando modelo YOLOv8...")
    if not RUTA_MODELO.exists():
        logger.error("Modelo no encontrado en: %s", RUTA_MODELO)
        print(f"❌ Modelo no encontrado en: {RUTA_MODELO}")
        mediamtx_proc.terminate()
        return

    modelo = YOLO(str(RUTA_MODELO))
    modelo.to("cpu")
    logger.info("Modelo YOLOv8 cargado desde %s", RUTA_MODELO)
    print("✅ Modelo cargado")

    # ── 4. Camera ──────────────────────────────────────────────────────────
    print("📷 Abriendo cámara...")
    camara = cv2.VideoCapture(CAMARA_ID)
    if not camara.isOpened():
        logger.error("No se pudo abrir la cámara (id=%d).", CAMARA_ID)
        print("❌ No se pudo abrir la cámara")
        mediamtx_proc.terminate()
        return

    camara.set(cv2.CAP_PROP_FRAME_WIDTH,  ANCHO)
    camara.set(cv2.CAP_PROP_FRAME_HEIGHT, ALTO)
    camara.set(cv2.CAP_PROP_FPS,          FPS)
    print("✅ Cámara lista")

    ffmpeg_proc = iniciar_ffmpeg(ANCHO, ALTO, FPS, RTSP_URL)

    # ── 5. Camera thread ───────────────────────────────────────────────────
    stop_event = threading.Event()
    hilo = threading.Thread(
        target=hilo_camara_ia,
        args=(modelo, camara, ffmpeg_proc, stop_event),
        daemon=True,
        name="camara-ia",
    )
    hilo.start()

    # ── 6. Robot subsystems ────────────────────────────────────────────────
    print("\n🤖 Iniciando sistemas del robot...")
    motores    = ControlMotores()
    lora       = LoRaReceiver()
    sensor_gas = SensorMQ5(pin_gas=22)
    estado_movimiento = "stop"

    print("✅ Todo listo. Robot operando...\n")
    print("   Comandos: adelante | atras | izquierda | derecha | stop")
    logger.info("ARGOS robot iniciado en modo hardware.")

    # ── 7. Main command loop ───────────────────────────────────────────────
    try:
        while True:
            comando = lora.read_command()

            if sensor_gas.gas_detectado():
                logger.warning("Gas detectado — deteniendo robot.")
                print("⚠️  GAS DETECTADO - Deteniendo robot")
                estado_movimiento = "stop"

            if comando:
                logger.info("Comando LoRa recibido: %s", comando)
                print("📡 Recibido:", comando)
                cmd = comando.strip().lower()
                if "adelante"   in cmd:
                    estado_movimiento = "adelante"
                elif "atras"    in cmd:
                    estado_movimiento = "atras"
                elif "izquierda" in cmd:
                    estado_movimiento = "izquierda"
                elif "derecha"  in cmd:
                    estado_movimiento = "derecha"
                elif "stop"     in cmd:
                    estado_movimiento = "stop"

            if estado_movimiento == "adelante":
                motores.avanzar()
            elif estado_movimiento == "atras":
                motores.retroceder()
            elif estado_movimiento == "izquierda":
                motores.girar_izquierda()
            elif estado_movimiento == "derecha":
                motores.girar_derecha()
            else:
                motores.detener()

            time.sleep(0.05)

    except KeyboardInterrupt:
        logger.info("Apagado solicitado por el usuario (Ctrl-C).")
        print("\n🛑 Deteniendo ARGOS...")

    finally:
        stop_event.set()
        hilo.join(timeout=3)
        camara.release()
        if ffmpeg_proc.stdin:
            ffmpeg_proc.stdin.close()
        ffmpeg_proc.wait()
        mediamtx_proc.terminate()
        motores.limpiar()
        logger.info("Recursos liberados. ARGOS detenido.")
        print("✅ Recursos liberados. ¡Hasta luego!")


if __name__ == "__main__":
    main()
