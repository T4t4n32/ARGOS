import serial
import time

class LoRaReceiver:
    def __init__(self, port="/dev/ttyUSB0", baud=115200):
        self.port = port
        self.baud = baud
        self.ser = None
        self.connect()

    def connect(self):
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            print("[LoRa] Conectado en", self.port)
        except Exception as e:
            print("[LoRa] Error de conexión:", e)

    def read_command(self):
        if self.ser and self.ser.in_waiting > 0:
            try:
                line = self.ser.readline().decode('utf-8', errors='ignore').strip()
                if line:
                    return line
            except Exception as e:
                print("[LoRa] Error leyendo datos:", e)
        return None