import serial
import json

class LoRaReceiver:
    def __init__(self, port="/dev/ttyUSB0", baud=115200):
        self.port = port
        self.baud = baud
        self.ser = None
        self.connect()

    def connect(self):
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            print("[LoRa RX] Conectado en", self.port)
        except Exception as e:
            print("[LoRa RX] Error de conexión:", e)

    def read_command(self):
        if self.ser and self.ser.in_waiting > 0:
            try:
                line = self.ser.readline().decode('utf-8', errors='ignore').strip()
                if line:
                    return line
            except Exception as e:
                print("[LoRa RX] Error leyendo datos:", e)
        return None

class LoRaTransmitter:
    """
    Actúa como puente transparente, enviando la telemetría generada
    por la Raspberry Pi hacia el módem Arduino/ESP32 (Tx.ino) por puerto serial.
    """
    def __init__(self, port="/dev/ttyUSB0", baud=115200):
        self.port = port
        self.baud = baud
        self.ser = None
        self.connect()

    def connect(self):
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            print(f"[LoRa TX] Módem conectado en {self.port}")
        except Exception as e:
            print(f"[LoRa TX] Advertencia: Módem desconectado o no encontrado en {self.port}. Simulación activa.")

    def send_readings(self, readings: dict):
        """
        Aplana el diccionario complejo de sensores a uno simple para ahorrar ancho de banda
        (LoRa requiere payloads muy ligeros) y lo envía por Serial al módem.
        """
        flat_data = {
            "t": readings.get("temperature", {}).get("value", ""),
            "g": readings.get("gas", {}).get("value", ""),
            "d": readings.get("distance", {}).get("value", "")
        }
        if "humidity" in readings:
            flat_data["h"] = readings["humidity"].get("value", "")
            
        payload = json.dumps(flat_data)
        
        if self.ser and self.ser.is_open:
            try:
                self.ser.write((payload + "\n").encode('utf-8'))
                self.ser.flush()
                # print(f"[LoRa TX] Enviado: {payload}")
            except Exception as e:
                print(f"[LoRa TX] Error de transmisión serial: {e}")
        else:
            print(f"[LoRa TX] (Sin módem) Payload generado: {payload}")

    def send_detections(self, detections: dict):
        """Envía detecciones de visión. Por ahora no se transmite por ancho de banda."""
        pass