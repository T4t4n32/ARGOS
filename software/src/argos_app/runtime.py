from __future__ import annotations

"""Runtime entry point and central orchestrator for the ARGOS application.

This module goes beyond loading configuration and printing a banner: it
provides a simple *hub* that wires together the different subsystems of
ARGOS.  It demonstrates how to load configuration, initialise
components based on the selected run mode (``simulated`` or ``hardware``)
and run them concurrently.  The concrete sensor drivers, LoRa
communication handlers and vision modules are left as stubs.  You
should replace the stub implementations with real classes in
``sensors/``, ``comms/``, ``decision/`` and ``vision/``.

The hub uses :mod:`asyncio` to run tasks concurrently.  Each sensor
reports readings at regular intervals, the vision subsystem produces
detections, and the communications subsystem sends data to a base
station.  A simple decision engine analyses sensor readings and
determines a risk state (verde, amarillo, rojo).
"""

import asyncio
import os
import random
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Optional

import yaml
from rich.console import Console
from rich.table import Table

console = Console()


def load_config(config_path: Optional[str]) -> dict:
    """Load the YAML configuration for ARGOS.

    The search order for the configuration is:

    1. The explicit ``config_path`` argument passed to ``run``.
    2. The environment variable ``ARGOS_CONFIG``, if set.
    3. A default file at ``config/argos.yaml`` relative to the project root.

    ``runtime.py`` resides in ``software/src/argos_app``. The project root
    is therefore four levels up from this file. By resolving the absolute
    path of ``__file__`` we can derive the project root dynamically.

    Parameters
    ----------
    config_path: str | None
        Explicit path to the YAML file or ``None`` to fall back to env/default.

    Returns
    -------
    dict
        Parsed configuration dictionary.
    """
    if config_path:
        path = Path(config_path)
    else:
        env = os.getenv("ARGOS_CONFIG")
        if env:
            path = Path(env)
        else:
            # ascend to the project root (software/src/argos_app -> software/src -> software -> project)
            root = Path(__file__).resolve().parents[4]
            path = root / "config" / "argos.yaml"
    if not path.exists():
        raise FileNotFoundError(f"Config not found: {path}")
    return yaml.safe_load(path.read_text(encoding="utf-8"))


###############################################################################
# Stub implementations
###############################################################################

class BaseSensor:
    """Abstract sensor base class.

    Concrete sensor drivers should inherit from this class and
    implement :meth:`read` to return a dictionary with at least a
    ``value`` field.  Additional fields (e.g. units, timestamp)
    may be included.
    """

    name: str

    def __init__(self, name: str) -> None:
        self.name = name

    def read(self) -> Dict[str, Any]:
        raise NotImplementedError


class SimulatedSensor(BaseSensor):
    """A simple simulated sensor that generates pseudo‑random readings."""

    def __init__(self, name: str, min_val: float, max_val: float) -> None:
        super().__init__(name)
        self._min = min_val
        self._max = max_val
        self._current = (min_val + max_val) / 2

    def read(self) -> Dict[str, Any]:
        # Random walk around the current value
        delta = random.uniform(-1, 1) * (self._max - self._min) * 0.05
        self._current = max(self._min, min(self._max, self._current + delta))
        return {"value": round(self._current, 2)}


class StubComms:
    """Placeholder communications subsystem.

    Replace this with a class that actually sends data via LoRa or
    another transport.  The stub simply prints payloads to the console.
    """

    def send_readings(self, readings: Dict[str, Dict[str, Any]]) -> None:
        console.print(f"[comms] Sending readings → {readings}")

    def send_detections(self, detections: Dict[str, Any]) -> None:
        console.print(f"[comms] Sending detections → {detections}")


class StubVision:
    """Placeholder vision subsystem.

    Replace this with a proper camera capture and object detection
    pipeline using OpenCV/YOLO or similar.  The stub returns a list of
    fake detections.
    """

    def __init__(self, interval_s: float = 2.0) -> None:
        self.interval_s = interval_s

    async def capture(self) -> Dict[str, Any]:
        await asyncio.sleep(self.interval_s)
        # Fake detection: random object with confidence
        objects = [
            {"label": "helmet", "confidence": random.uniform(0.7, 1.0)},
            {"label": "rope", "confidence": random.uniform(0.5, 0.9)},
        ]
        return {"objects": objects}


class StubDecision:
    """Simple decision engine.

    Given sensor readings, compute a risk state based on simple
    thresholds.  In a real implementation, this would be replaced
    with a more sophisticated engine (e.g. fuzzy logic, ML model).
    """

    def __init__(self, thresholds: Optional[Dict[str, Dict[str, float]]] = None) -> None:
        self.thresholds = thresholds or {
            "temperature": {"yellow": 28.0, "red": 32.0},
            "gas": {"yellow": 400.0, "red": 800.0},
            "distance": {"yellow": 1.0, "red": 0.5},
        }

    def evaluate(self, readings: Dict[str, Dict[str, Any]]) -> str:
        # Evaluate each sensor against thresholds; pick the highest risk
        level = "green"
        for name, data in readings.items():
            value = data.get("value", 0)
            th = self.thresholds.get(name, {})
            if value >= th.get("red", float("inf")):
                return "red"
            if value >= th.get("yellow", float("inf")):
                level = "yellow"
        return level


###############################################################################
# Hub loops
###############################################################################

async def sensor_loop(sensors: Dict[str, BaseSensor], update_interval: float, queue: asyncio.Queue) -> None:
    """Asynchronous loop that reads all sensors periodically and pushes
    readings into an asyncio queue.

    Parameters
    ----------
    sensors : dict
        Mapping from sensor name to sensor instance.
    update_interval : float
        Delay between readings in seconds.
    queue : asyncio.Queue
        Queue where sensor readings will be put as a tuple
        ``("sensor", readings_dict)``.
    """
    while True:
        readings = {name: sensor.read() for name, sensor in sensors.items()}
        await queue.put(("sensor", readings))
        await asyncio.sleep(update_interval)


async def vision_loop(vision: StubVision, queue: asyncio.Queue) -> None:
    """Asynchronous loop that captures images and detections.

    The vision subsystem decides its own pacing (via its internal
    interval).  Each set of detections is pushed into the queue as
    ``("vision", detections_dict)``.
    """
    while True:
        detections = await vision.capture()
        await queue.put(("vision", detections))


async def comms_loop(comms: StubComms, queue: asyncio.Queue) -> None:
    """Consume items from the queue and dispatch them via the communications subsystem."""
    while True:
        item_type, data = await queue.get()
        if item_type == "sensor":
            comms.send_readings(data)
        elif item_type == "vision":
            comms.send_detections(data)
        queue.task_done()


async def decision_loop(decision: StubDecision, queue: asyncio.Queue) -> None:
    """Consume sensor readings, compute risk level and display to console."""
    while True:
        item_type, data = await queue.get()
        if item_type == "sensor":
            level = decision.evaluate(data)
            table = Table(title="ARGOS Risk Level", title_style="bold blue")
            table.add_column("Sensor", style="cyan", no_wrap=True)
            table.add_column("Value", style="magenta")
            for name, reading in data.items():
                table.add_row(name, str(reading.get("value")))
            console.print(table)
            console.print(f"[decision] Risk state: {level}\n")
        queue.task_done()


async def main_hub(cfg: dict, mode: str) -> None:
    """Entry point for the async hub.

    Parameters
    ----------
    cfg : dict
        Configuration dictionary loaded from YAML.
    mode : str
        Either ``simulated`` or ``hardware``.  In hardware mode you
        should instantiate real drivers instead of stubs.
    """
    console.rule(f"ARGOS Hub — mode={mode}")
    project = cfg.get("project", {})
    console.print(f"Project: {project.get('name', 'ARGOS')} v{project.get('version', '0.0')}\n")

    # Instantiate sensors based on mode.  Replace these with real drivers.
    sensors: Dict[str, BaseSensor] = {}
    if mode == "simulated":
        sensors = {
            "temperature": SimulatedSensor("temperature", min_val=20.0, max_val=35.0),
            "gas": SimulatedSensor("gas", min_val=200.0, max_val=900.0),
            "distance": SimulatedSensor("distance", min_val=0.2, max_val=5.0),
        }
    else:
        # Attempt to import real sensor drivers.  Fallback to simulated sensors
        # if the drivers or required hardware libraries are not available.
        sensors = {}
        try:
            from .sensors.pt100 import PT100Sensor  # type: ignore
            # Instantiate a PT100 sensor connected via MAX31865.  The CS pin
            # number and other parameters can be overridden via YAML config.
            temp_cfg = cfg.get("sensors", {}).get("temperature", {})
            cs_pin = temp_cfg.get("cs_pin", 17)
            rref = temp_cfg.get("rref", 430.0)
            wires = temp_cfg.get("wires", 3)
            sensors["temperature"] = PT100Sensor(cs_pin=cs_pin, rref=rref, wires=wires)
        except Exception as e:
            console.print(f"[yellow]Warning: PT100Sensor could not be initialised ({e}); using simulated temperature sensor")
            sensors["temperature"] = SimulatedSensor("temperature", min_val=20.0, max_val=35.0)
        # TODO: import MQ135 driver when available
        sensors["gas"] = SimulatedSensor("gas", min_val=200.0, max_val=900.0)
        sensors["distance"] = SimulatedSensor("distance", min_val=0.2, max_val=5.0)

    # Instantiate communications subsystem
    comms = StubComms()
    # Instantiate vision subsystem
    vision = StubVision(interval_s=cfg.get("vision", {}).get("interval_s", 2.0))
    # Instantiate decision engine
    decision = StubDecision(thresholds=cfg.get("thresholds"))

    # Create a shared queue
    queue: asyncio.Queue = asyncio.Queue()

    # Start all loops concurrently
    await asyncio.gather(
        sensor_loop(sensors, update_interval=cfg.get("sensors", {}).get("interval_s", 5.0), queue=queue),
        vision_loop(vision, queue),
        comms_loop(comms, queue),
        decision_loop(decision, queue),
    )


def run(config_path: Optional[str], mode: str) -> None:
    """Run the ARGOS application.

    This function orchestrates the asynchronous hub.  It loads
    configuration, initialises the asyncio event loop and runs until
    cancelled.  Keyboard interrupts are handled gracefully.
    """
    cfg = load_config(config_path)
    try:
        asyncio.run(main_hub(cfg, mode))
    except KeyboardInterrupt:
        console.print("\n[bold yellow]Shutdown requested. Exiting ARGOS hub.")

