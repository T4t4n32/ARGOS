"""MQ-5 gas sensor driver for ARGOS.

The MQ-5 has a digital output pin that goes LOW when gas concentration
exceeds the on-board potentiometer threshold.  This driver reads that
digital signal via the Raspberry Pi GPIO.

``RPi.GPIO`` is imported at module load time (not inside methods) so that
import errors are surfaced immediately rather than at the first sensor
read.  The import is wrapped in a try/except so the rest of the package
can still be imported on non-Pi machines (e.g. during testing or in
simulated mode).
"""

import logging
import time

logger = logging.getLogger(__name__)

try:
    import RPi.GPIO as GPIO  # type: ignore[import-untyped]
except ImportError:  # pragma: no cover
    GPIO = None  # type: ignore[assignment]


class SensorMQ5:
    """Digital gas-presence sensor (MQ-5).

    Parameters
    ----------
    pin_gas:
        BCM-numbered GPIO pin connected to the DO (digital output) of the
        MQ-5 module.  The sensor pulls the pin LOW when gas is detected.
    warmup_s:
        Seconds to wait after GPIO setup before the first reading.
        The MQ-5 datasheet recommends at least 20 s preheat in fresh air
        for accurate readings.  The default (2 s) is a minimum for quick
        starts; increase in production for reliable calibration.
    """

    def __init__(self, pin_gas: int = 22, warmup_s: float = 2.0) -> None:
        if GPIO is None:
            raise ImportError(
                "RPi.GPIO no está disponible. "
                "Instala con: pip install RPi.GPIO\n"
                "Si estás en un entorno de desarrollo, usa --mode simulated."
            )
        self.pin_gas = pin_gas
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.pin_gas, GPIO.IN)
        logger.info("SensorMQ5 inicializado en pin %d. Calentando %.1fs…", pin_gas, warmup_s)
        time.sleep(warmup_s)

    # ── Public API ────────────────────────────────────────────────────────────

    def gas_detectado(self) -> bool:
        """Return ``True`` if gas concentration is above the module threshold."""
        return GPIO.input(self.pin_gas) == 0  # LOW → gas detected

    def leer_estado(self) -> str:
        """Return a human-readable state string."""
        return "GAS_DETECTADO" if self.gas_detectado() else "AIRE_LIMPIO"

    def limpiar(self) -> None:
        """Release the GPIO pin allocated by this sensor."""
        try:
            GPIO.cleanup(self.pin_gas)
            logger.info("SensorMQ5 pin %d liberado.", self.pin_gas)
        except Exception as exc:
            logger.warning("SensorMQ5 limpiar() falló: %s", exc)
