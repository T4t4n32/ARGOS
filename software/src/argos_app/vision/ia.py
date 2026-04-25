"""Vision subsystem: YOLO-based object detection for ARGOS.

Loads a custom-trained YOLOv8 model (``Mon1.0.pt``) and captures frames
from a USB/CSI camera.  All output uses :mod:`logging` so that verbosity
is controlled by the application's log configuration.
"""

import logging
import os

import cv2
from ultralytics import YOLO

logger = logging.getLogger(__name__)


class DetectorObjetos:
    """Real-time object detector backed by a custom YOLOv8 model.

    Parameters
    ----------
    confianza:
        Detection confidence threshold (0–1).  Detections below this
        value are discarded.
    camara_id:
        OpenCV camera index (0 = first USB/CSI camera).
    """

    def __init__(self, confianza: float = 0.4, camara_id: int = 0) -> None:
        ruta_base = os.path.dirname(__file__)
        ruta_modelo = os.path.join(ruta_base, "Modelos", "Mon1.0.pt")

        logger.info("Cargando modelo desde: %s", ruta_modelo)
        if not os.path.exists(ruta_modelo):
            raise FileNotFoundError(f"Modelo no encontrado en {ruta_modelo}")

        self.confianza = confianza

        # Load model and force CPU execution (no GPU on Pi 5)
        self.modelo = YOLO(ruta_modelo)
        self.modelo.to("cpu")

        # Initialize camera — release model resources if camera unavailable
        self.camara = cv2.VideoCapture(camara_id)
        if not self.camara.isOpened():
            # Free YOLO resources before raising so we don't leak memory
            del self.modelo
            raise RuntimeError(
                f"No se pudo abrir la cámara con id={camara_id}. "
                "Verifica que la cámara esté conectada y habilitada en raspi-config."
            )

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