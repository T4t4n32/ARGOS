from ultralytics import YOLO
import cv2
import os

class DetectorObjetos:
    def __init__(self, confianza=0.4, camara_id=0):
        ruta_base = os.path.dirname(__file__)
        ruta_modelo = os.path.join(ruta_base, "Modelos", "Mon1.0.pt")

        print("Cargando modelo desde:", ruta_modelo)
        if not os.path.exists(ruta_modelo):
            raise FileNotFoundError(f"Modelo no encontrado en {ruta_modelo}")

        self.confianza = confianza

        # Carga el modelo y fuerza CPU
        self.modelo = YOLO(ruta_modelo)
        self.modelo.to("cpu")

        # Inicializa la cámara
        self.camara = cv2.VideoCapture(camara_id)
        if not self.camara.isOpened():
            raise RuntimeError("No se pudo abrir la cámara")

        # 🔥 Limitar resolución de cámara
        self.camara.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
        self.camara.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

    def leer_frame(self):
        ret, frame = self.camara.read()
        if not ret:
            return None
        return frame

    def detectar(self, frame):
        frame = cv2.resize(frame, (320, 240))  # 🔥 Optimización fuerte
        return self.modelo(
            frame,
            conf=self.confianza,
            imgsz=320,
            verbose=False
        )

    def dibujar_resultados(self, resultados):
        return resultados[0].plot()

    def mostrar(self, frame, nombre_ventana="Detección YOLO"):
        cv2.imshow(nombre_ventana, frame)

    def cerrar(self):
        self.camara.release()
        cv2.destroyAllWindows()