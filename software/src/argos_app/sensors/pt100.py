"""Driver for PT100 temperature sensors using a MAX31865 amplifier.

This module provides a :class:`PT100Sensor` class which reads a PT100
resistive temperature detector (RTD) using the MAX31865 resistance-to-digital
converter.  The implementation here closely follows the logic from the
provided ESP32 Arduino sketch (``Temperature_3_Wire_ESP32_V1.2.0.ino``)
but is written in Python for the Raspberry Pi.  It can operate using the
``spidev`` library for raw SPI access or, if available, the higher-level
``adafruit_max31865`` library.  Using the Adafruit library is recommended
because it handles configuration and conversion internally.  If the
Adafruit library is not installed, the driver falls back to manual SPI
transactions and performs the Callendar–Van Dusen calculation to convert
raw resistance values to temperature.

The PT100 sensor can be wired in 2‑, 3‑ or 4‑wire configurations.  In
most ARGOS prototypes the PT100 is connected as a 3‑wire device with a
reference resistor of 430 Ω (Rref).  Adjust ``rref`` and ``wires`` when
instantiating :class:`PT100Sensor` to match your hardware.

Example usage in ``hardware`` mode::

    from argos_app.sensors.pt100 import PT100Sensor

    sensor = PT100Sensor(cs_pin=17, rref=430.0, wires=3)
    reading = sensor.read()
    print(f"Temperature: {reading['value']}°C")

When running on a system without GPIO access (e.g. during development
on a PC), the driver will raise an ``ImportError`` because it cannot
import ``RPi.GPIO``.  In such cases you should run the application in
``simulated`` mode.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Any, Optional
import time
import math

from ..runtime import BaseSensor

try:
    import spidev  # type: ignore
    import RPi.GPIO as GPIO  # type: ignore
except ImportError:
    spidev = None  # type: ignore
    GPIO = None  # type: ignore

try:
    # The Adafruit library provides a simple API for the MAX31865.
    import board  # type: ignore
    import digitalio  # type: ignore
    import adafruit_max31865  # type: ignore
except ImportError:
    adafruit_max31865 = None  # type: ignore
    board = None  # type: ignore
    digitalio = None  # type: ignore


@dataclass
class PT100Sensor(BaseSensor):
    """Read temperatures from a PT100 sensor via MAX31865.

    Parameters
    ----------
    name : str
        Logical name of the sensor.
    cs_pin : int or object, optional
        GPIO pin number for the chip select (CE/CS) pin.  When using
        ``spidev`` this should be a BCM GPIO number (e.g. 17).  When
        using the Adafruit library this may also be a ``digitalio.DigitalInOut``
        instance.  Defaults to 17.
    rref : float, optional
        Reference resistor value in ohms.  The MAX31865 breakout for
        PT100 uses a 430 Ω resistor; if you have a PT1000 breakout this
        should be 4300 Ω.  Defaults to 430.0.
    wires : int, optional
        Number of wires in the RTD probe (2, 3, or 4).  Defaults to 3.
    """

    name: str = "temperature"
    cs_pin: Any = 17
    rref: float = 430.0
    wires: int = 3

    def __post_init__(self) -> None:
        # Prefer the Adafruit library if available.
        self._using_adafruit = adafruit_max31865 is not None and board is not None and digitalio is not None
        if self._using_adafruit:
            # Initialise SPI and CS using Adafruit API.
            spi = board.SPI()
            # Allow cs_pin to be passed as either a DigitalInOut or a simple pin number.
            if isinstance(self.cs_pin, digitalio.DigitalInOut):
                cs = self.cs_pin
            else:
                cs = digitalio.DigitalInOut(getattr(board, f"D{self.cs_pin}") if isinstance(self.cs_pin, int) else self.cs_pin)
            self._sensor = adafruit_max31865.MAX31865(spi, cs, wires=self.wires, rtd_nominal=100.0, ref_resistor=self.rref)
        else:
            # Fallback: manual SPI access using spidev and RPi.GPIO.
            if spidev is None or GPIO is None:
                raise ImportError(
                    "spidev/RPi.GPIO libraries are required for raw SPI access;"
                    " run in simulated mode or install the libraries on a Raspberry Pi."
                )
            self.spi = spidev.SpiDev()
            # Use bus 0, device 0 but we'll manually control CS via GPIO.
            self.spi.open(0, 0)
            self.spi.max_speed_hz = 500_000
            # Configure GPIO for CS
            GPIO.setmode(GPIO.BCM)
            GPIO.setup(self.cs_pin, GPIO.OUT)
            GPIO.output(self.cs_pin, GPIO.HIGH)

    def _read_raw(self) -> int:
        """Read the raw 15‑bit RTD value from the MAX31865.

        Returns
        -------
        int
            Raw RTD value (0–32767).
        """
        # Write configuration: bias ON, automatic conversion off,
        # 1‑shot conversion, 3‑wire if needed.
        # Config bits: 0b10110000 corresponds to Bias=1, Conversion Mode=1 (one‑shot),
        # 1‑shot start, 3‑wire.
        config_byte = 0x80  # address 0 with write bit
        config_value = 0xB0 if self.wires == 3 else 0xA0  # set wiring mode
        # Begin SPI transaction (manual CS)
        GPIO.output(self.cs_pin, GPIO.LOW)
        self.spi.xfer2([config_byte, config_value])
        GPIO.output(self.cs_pin, GPIO.HIGH)
        # Wait for bias to settle
        time.sleep(0.01)
        # Read MSB and LSB of RTD value
        GPIO.output(self.cs_pin, GPIO.LOW)
        # Address 1: read sequence
        raw = self.spi.xfer2([0x01, 0x00, 0x00])
        GPIO.output(self.cs_pin, GPIO.HIGH)
        # Combine bytes; discard fault bit (LSB bit 0)
        msb, lsb = raw[1], raw[2]
        fullreg = ((msb << 8) | lsb) >> 1
        return fullreg

    def _cvd_temperature(self, resistance: float) -> float:
        """Convert RTD resistance to temperature using the Callendar–Van Dusen equation.

        Parameters
        ----------
        resistance : float
            Resistance of the RTD in ohms.

        Returns
        -------
        float
            Temperature in degrees Celsius.
        """
        # Callendar–Van Dusen coefficients for PT100
        RTDa = 3.9083e-3
        RTDb = -5.775e-7
        # Calculate intermediate values for the quadratic formula
        # for temperatures >= 0 °C.
        Z1 = -RTDa
        Z2 = (RTDa ** 2) - (4 * RTDb)
        Z3 = (4 * RTDb) / 100.0
        Z4 = 2 * RTDb
        # Solve quadratic: Rt = resistance (converted to R100)
        Rt = resistance
        temperature = Z2 + (Z3 * Rt)
        temperature = (math.sqrt(temperature) + Z1) / Z4
        if temperature < 0:
            # Apply polynomial approximation for T < 0 °C
            rpoly = Rt / 100.0
            temperature = -242.02
            temperature += 2.2228 * rpoly
            rpoly *= Rt
            temperature += 2.5859e-3 * rpoly
            rpoly *= Rt
            temperature -= 4.8260e-6 * rpoly
            rpoly *= Rt
            temperature -= 2.8183e-8 * rpoly
            rpoly *= Rt
            temperature += 1.5243e-10 * rpoly
        return temperature

    def read(self) -> Dict[str, Any]:
        """Return the current temperature reading.

        Returns
        -------
        dict
            A dictionary with keys ``value`` (float) for the temperature in °C
            and ``unit`` (str) indicating the unit.
        """
        if self._using_adafruit:
            temp_c = self._sensor.temperature
        else:
            # Manual read: convert raw value to resistance and then to temperature
            raw = self._read_raw()
            # Convert raw value to resistance (ratio * reference resistor)
            resistance = (raw / 32768.0) * self.rref
            temp_c = self._cvd_temperature(resistance)
        return {"value": round(temp_c, 2), "unit": "°C"}