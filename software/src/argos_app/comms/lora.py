"""LoRa communications drivers for ARGOS.

``LoRaReceiver`` reads commands arriving from the base station.
``LoRaTransmitter`` sends compact telemetry packets to the base station.

Both classes use Python's :mod:`logging` module so that verbosity can
be controlled from the application's log configuration rather than
hard-coded ``print`` statements.
"""

import json
import logging

import serial

logger = logging.getLogger(__name__)


class LoRaReceiver:
    """Read command strings sent by the base station over a serial LoRa modem."""

    def __init__(self, port: str = "/dev/ttyUSB0", baud: int = 115200) -> None:
        self.port = port
        self.baud = baud
        self.ser: serial.Serial | None = None
        self.connect()

    def connect(self) -> None:
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            logger.info("[LoRa RX] Conectado en %s", self.port)
        except Exception as exc:
            logger.error("[LoRa RX] Error de conexión en %s: %s", self.port, exc)

    def disconnect(self) -> None:
        """Close the serial port gracefully."""
        if self.ser and self.ser.is_open:
            self.ser.close()
            logger.info("[LoRa RX] Puerto %s cerrado.", self.port)

    def __del__(self) -> None:
        self.disconnect()

    def read_command(self) -> str | None:
        if self.ser and self.ser.in_waiting > 0:
            try:
                line = self.ser.readline().decode("utf-8", errors="ignore").strip()
                if line:
                    return line
            except Exception as exc:
                logger.error("[LoRa RX] Error leyendo datos: %s", exc)
        return None


class LoRaTransmitter:
    """Send compact telemetry packets to the base station over a serial LoRa modem.

    Acts as a transparent bridge: the Raspberry Pi writes JSON payloads
    to the serial port where the Arduino/ESP32 firmware (Tx.ino) picks
    them up and re-transmits them over the LoRa radio link.  Payloads
    are intentionally small (short keys) to respect the LoRa bandwidth
    constraints.
    """

    def __init__(self, port: str = "/dev/ttyUSB0", baud: int = 115200) -> None:
        self.port = port
        self.baud = baud
        self.ser: serial.Serial | None = None
        self.connect()

    def connect(self) -> None:
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            logger.info("[LoRa TX] Módem conectado en %s", self.port)
        except Exception as exc:
            logger.warning(
                "[LoRa TX] Módem no encontrado en %s (%s). Continuando sin LoRa.",
                self.port,
                exc,
            )

    def disconnect(self) -> None:
        """Close the serial port gracefully."""
        if self.ser and self.ser.is_open:
            self.ser.close()
            logger.info("[LoRa TX] Puerto %s cerrado.", self.port)

    def __del__(self) -> None:
        self.disconnect()

    def send_readings(self, readings: dict) -> None:
        """Flatten sensor readings into a compact JSON payload and send it.

        Uses single-letter keys to minimise payload size for LoRa:
        ``t`` = temperature, ``g`` = gas, ``d`` = distance, ``h`` = humidity.
        """
        flat_data: dict = {
            "t": readings.get("temperature", {}).get("value", ""),
            "g": readings.get("gas", {}).get("value", ""),
            "d": readings.get("distance", {}).get("value", ""),
        }
        if "humidity" in readings:
            flat_data["h"] = readings["humidity"].get("value", "")

        payload = json.dumps(flat_data)

        if self.ser and self.ser.is_open:
            try:
                self.ser.write((payload + "\n").encode("utf-8"))
                self.ser.flush()
                logger.debug("[LoRa TX] Enviado: %s", payload)
            except Exception as exc:
                logger.error("[LoRa TX] Error de transmisión serial: %s", exc)
        else:
            logger.debug("[LoRa TX] (Sin módem) Payload generado: %s", payload)

    def send_detections(self, detections: dict) -> None:
        """Stub: vision detections are not transmitted over LoRa (bandwidth).

        Implement when a compact detection summary format is defined.
        """