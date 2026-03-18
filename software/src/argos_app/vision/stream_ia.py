from ultralytics import YOLO
import cv2
import os
import subprocess

CAMARA_ID   = 0
CONFIANZA   = 0.4
ANCHO       = 640
ALTO        = 480
FPS         = 20
RTSP_URL    = "rtsp://localhost:8554/cam"
RUTA_MODELO = os.path.join(os.path.dirname(__file__), "Modelos", "Mon1.0.pt")

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
    return subprocess.Popen(comando, stdin=subprocess.PIPE)

def main():
    if not os.path.exists(RUTA_MODELO):
        raise FileNotFoundError(f"Modelo no encontrado en: {RUTA_MODELO}")
    print("Cargando modelo YOLOv8...")
    modelo = YOLO(RUTA_MODELO)
    modelo.to("cpu")
    print("Abriendo camara...")
    camara = cv2.VideoCapture(CAMARA_ID)
    if not camara.isOpened():
        raise RuntimeError("No se pudo abrir la camara")
    camara.set(cv2.CAP_PROP_FRAME_WIDTH, ANCHO)
    camara.set(cv2.CAP_PROP_FRAME_HEIGHT, ALTO)
    camara.set(cv2.CAP_PROP_FPS, FPS)
    print("Iniciando stream...")
    ffmpeg_proc = iniciar_ffmpeg(ANCHO, ALTO, FPS, RTSP_URL)
    print("Transmitiendo en vivo...")
    print("Ver en celular: http://10.3.141.1:8888/cam")
    print("Presiona Ctrl+C para detener")
    try:
        while True:
            ret, frame = camara.read()
            if not ret:
                continue
            resultados = modelo(frame, conf=CONFIANZA, imgsz=320, verbose=False)
            frame_detectado = resultados[0].plot()
            frame_salida = cv2.resize(frame_detectado, (ANCHO, ALTO))
            for det in resultados[0].boxes:
                clase_id = int(det.cls[0])
                nombre = modelo.names[clase_id]
                conf = float(det.conf[0])
                print(f"  Detectado: {nombre} ({conf:.0%})")
            try:
                ffmpeg_proc.stdin.write(frame_salida.tobytes())
            except BrokenPipeError:
                print("ffmpeg se desconecto")
                break
    except KeyboardInterrupt:
        print("Detenido")
    finally:
        camara.release()
        ffmpeg_proc.stdin.close()
        ffmpeg_proc.wait()
        print("Recursos liberados")

if __name__ == "__main__":
    main()
