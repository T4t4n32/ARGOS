import time
import subprocess
import threading
import os
import cv2
from ultralytics import YOLO
from decision.motores import ControlMotores
from comms.lora import LoRaReceiver
from sensors.mq5 import SensorMQ5

# ── Configuración video ────────────────────────────────────
CAMARA_ID   = 0
CONFIANZA   = 0.4
ANCHO       = 640
ALTO        = 480
FPS         = 20
RTSP_URL    = "rtsp://localhost:8554/cam"
RUTA_MODELO = os.path.join(os.path.dirname(__file__), "vision", "Modelos", "Mon1.0.pt")
MEDIAMTX    = "/home/argos/mediamtx"
# ───────────────────────────────────────────────────────────

def iniciar_red_local():
    print("📡 Iniciando red local ARGOS...")
    subprocess.run(["sudo", "systemctl", "start", "hostapd"], check=False)
    subprocess.run(["sudo", "systemctl", "start", "dnsmasq"], check=False)
    time.sleep(3)
    print("✅ Red WiFi ARGOS activa")

def iniciar_mediamtx():
    print("📺 Iniciando servidor de video...")
    proc = subprocess.Popen(
        [MEDIAMTX],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    time.sleep(3)
    print("✅ Servidor de video listo")
    return proc

def iniciar_ffmpeg(ancho, alto, fps, rtsp_url):
    comando = [
        "ffmpeg", "-y",
        "-f", "rawvideo",
        "-vcodec", "rawvideo",
        "-pix_fmt", "bgr24",
        "-s", f"{ancho}x{alto}",
        "-r", str(fps),
        "-i", "pipe:0",
        "-c:v", "libx264",
        "-preset", "ultrafast",
        "-tune", "zerolatency",
        "-pix_fmt", "yuv420p",
        "-f", "rtsp",
        rtsp_url
    ]
    return subprocess.Popen(comando, stdin=subprocess.PIPE,
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL)

def hilo_camara_ia(modelo, camara, ffmpeg_proc, stop_event):
    print("🎥 Camara con IA iniciada")
    print("   Ver en celular: http://argos.local:8888/cam")

    contador = 0
    ultimo_frame_detectado = None

    while not stop_event.is_set():
        ret, frame = camara.read()
        if not ret:
            continue

        contador += 1

        if contador % 3 == 0:
            resultados = modelo(frame, conf=CONFIANZA, imgsz=320, verbose=False)
            ultimo_frame_detectado = resultados[0].plot()
            for det in resultados[0].boxes:
                clase_id = int(det.cls[0])
                nombre   = modelo.names[clase_id]
                conf     = float(det.conf[0])
                print(f"  🔍 {nombre} ({conf:.0%})")
        else:
            ultimo_frame_detectado = frame

        if ultimo_frame_detectado is not None:
            frame_salida = cv2.resize(ultimo_frame_detectado, (ANCHO, ALTO))
            try:
                ffmpeg_proc.stdin.write(frame_salida.tobytes())
            except BrokenPipeError:
                print("⚠️  Stream de video interrumpido")
                break

def main():
    print("=" * 40)
    print("   ARGOS - Robot Explorador")
    print("=" * 40)

    iniciar_red_local()
    mediamtx_proc = iniciar_mediamtx()

    print("🤖 Cargando modelo YOLOv8...")
    if not os.path.exists(RUTA_MODELO):
        print(f"❌ Modelo no encontrado en: {RUTA_MODELO}")
        return
    modelo = YOLO(RUTA_MODELO)
    modelo.to("cpu")
    print("✅ Modelo cargado")

    print("📷 Abriendo camara...")
    camara = cv2.VideoCapture(CAMARA_ID)
    if not camara.isOpened():
        print("❌ No se pudo abrir la camara")
        return
    camara.set(cv2.CAP_PROP_FRAME_WIDTH, ANCHO)
    camara.set(cv2.CAP_PROP_FRAME_HEIGHT, ALTO)
    camara.set(cv2.CAP_PROP_FPS, FPS)
    print("✅ Camara lista")

    ffmpeg_proc = iniciar_ffmpeg(ANCHO, ALTO, FPS, RTSP_URL)

    stop_event = threading.Event()
    hilo = threading.Thread(
        target=hilo_camara_ia,
        args=(modelo, camara, ffmpeg_proc, stop_event),
        daemon=True
    )
    hilo.start()

    print("\n🤖 Iniciando sistemas del robot...")
    motores    = ControlMotores()
    lora       = LoRaReceiver()
    sensor_gas = SensorMQ5(pin_gas=22)
    estado_movimiento = "stop"

    print("✅ Todo listo. Robot operando...\n")
    print("   Comandos: adelante | atras | izquierda | derecha | stop")

    try:
        while True:
            comando = lora.read_command()

            if sensor_gas.gas_detectado():
                print("⚠️  GAS DETECTADO - Deteniendo robot")
                estado_movimiento = "stop"

            if comando:
                print("📡 Recibido:", comando)
                comando = comando.strip().lower()
                if "adelante" in comando:
                    estado_movimiento = "adelante"
                elif "atras" in comando:
                    estado_movimiento = "atras"
                elif "izquierda" in comando:
                    estado_movimiento = "izquierda"
                elif "derecha" in comando:
                    estado_movimiento = "derecha"
                elif "stop" in comando:
                    estado_movimiento = "stop"

            if estado_movimiento == "adelante":
                motores.avanzar()
            elif estado_movimiento == "atras":
                motores.retroceder()
            elif estado_movimiento == "izquierda":
                motores.girar_izquierda()
            elif estado_movimiento == "derecha":
                motores.girar_derecha()
            elif estado_movimiento == "stop":
                motores.detener()

            time.sleep(0.05)

    except KeyboardInterrupt:
        print("\n🛑 Deteniendo ARGOS...")

    finally:
        stop_event.set()
        hilo.join(timeout=3)
        camara.release()
        ffmpeg_proc.stdin.close()
        ffmpeg_proc.wait()
        mediamtx_proc.terminate()
        motores.limpiar()
        print("✅ Recursos liberados. Hasta luego!")

if __name__ == "main":
    main()
