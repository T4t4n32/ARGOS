from __future__ import annotations

"""Runtime entry point and central orchestrator for the ARGOS application.

Architecture
------------
The hub wires together four concurrent asyncio loops:

* **sensor_loop** — reads all sensors at a fixed interval and fans out
  readings to both ``comms_queue`` and ``decision_queue``.
* **vision_loop** — captures camera frames / detections and fans out to
  the same two queues.
* **comms_loop** — drains ``comms_queue`` and forwards data to the
  communications subsystem (LoRa in hardware mode).
* **decision_loop** — drains ``decision_queue``, evaluates risk level,
  logs a Rich table to the console and exports telemetry to CSV.

Separate queues per consumer guarantee that a slow consumer never
starves a faster one (no message stealing).

Run modes
---------
* ``simulated`` (default) — all subsystems use stubs; no hardware needed.
* ``hardware`` — real sensor drivers and LoRa transmitter are loaded;
  falls back to stubs if a driver cannot be initialised.
"""

import asyncio
import logging
import os
import random
from pathlib import Path
from typing import Any, Dict, List, Optional

import yaml
from rich.console import Console
from rich.table import Table

from .sensors.base import BaseSensor
from .utils.exporter import DatasetExporter

console = Console()
logger = logging.getLogger(__name__)


def setup_logging(level: str = "INFO", log_file: Optional[str] = None) -> None:
    """Configure root logger for the ARGOS application.

    Parameters
    ----------
    level:
        Log level string (``DEBUG``, ``INFO``, ``WARNING``, ``ERROR``).
    log_file:
        Optional path to a log file.  Records are written to both
        stderr and the file when provided.
    """
    handlers: List[logging.Handler] = [logging.StreamHandler()]
    if log_file:
        os.makedirs(os.path.dirname(log_file), exist_ok=True)
        handlers.append(logging.FileHandler(log_file, encoding="utf-8"))

    logging.basicConfig(
        level=getattr(logging, level.upper(), logging.INFO),
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%H:%M:%S",
        handlers=handlers,
        force=True,
    )


def load_config(config_path: Optional[str]) -> dict:
    """Load the YAML configuration for ARGOS.

    Search order:
    1. Explicit ``config_path`` argument.
    2. Environment variable ``ARGOS_CONFIG``.
    3. Default ``software/config/argos.yaml`` (parents[2] = software/).

    ``runtime.py`` lives at ``software/src/argos_app/runtime.py``::

        parents[0] → software/src/argos_app/
        parents[1] → software/src/
        parents[2] → software/          ← config/ lives here
        parents[3] → ARGOS/             ← project root
    """
    if config_path:
        path = Path(config_path)
    else:
        env = os.getenv("ARGOS_CONFIG")
        if env:
            path = Path(env)
        else:
            root = Path(__file__).resolve().parents[2]   # → software/
            path = root / "config" / "argos.yaml"

    if not path.exists():
        raise FileNotFoundError(
            f"Config no encontrado: {path}\n"
            "Tip: copia software/config/argos.example.yaml → software/config/argos.yaml\n"
            "     o usa --config <ruta>  o  export ARGOS_CONFIG=<ruta>"
        )
    return yaml.safe_load(path.read_text(encoding="utf-8"))


###############################################################################
# Stub / simulated implementations
###############################################################################


class SimulatedSensor(BaseSensor):
    """Sensor that generates pseudo-random readings via a random walk."""

    def __init__(self, name: str, min_val: float, max_val: float) -> None:
        super().__init__(name)
        self._min = min_val
        self._max = max_val
        self._current = (min_val + max_val) / 2

    def read(self) -> Dict[str, Any]:
        delta = random.uniform(-1, 1) * (self._max - self._min) * 0.05
        self._current = max(self._min, min(self._max, self._current + delta))
        return {"value": round(self._current, 2)}


class StubComms:
    """Placeholder comms — logs payloads instead of transmitting over LoRa."""

    def send_readings(self, readings: Dict[str, Dict[str, Any]]) -> None:
        logger.debug("[comms] Lecturas → %s", readings)

    def send_detections(self, detections: Dict[str, Any]) -> None:
        logger.debug("[comms] Detecciones → %s", detections)


class StubVision:
    """Placeholder vision — returns synthetic detections after a sleep."""

    def __init__(self, interval_s: float = 2.0) -> None:
        self.interval_s = interval_s

    async def capture(self) -> Dict[str, Any]:
        await asyncio.sleep(self.interval_s)
        return {
            "objects": [
                {"label": "helmet", "confidence": round(random.uniform(0.7, 1.0), 2)},
                {"label": "rope",   "confidence": round(random.uniform(0.5, 0.9), 2)},
            ]
        }


class StubDecision:
    """Threshold-based risk evaluator (green / yellow / red).

    Thresholds are loaded from ``argos.yaml``; these defaults apply when
    the config key is absent.
    """

    _DEFAULTS: Dict[str, Dict[str, float]] = {
        "temperature": {"yellow": 28.0, "red": 32.0},
        "gas":         {"yellow": 400.0, "red": 800.0},
        "distance":    {"yellow": 1.0,   "red": 0.5},
    }

    def __init__(self, thresholds: Optional[Dict[str, Dict[str, float]]] = None) -> None:
        self.thresholds = thresholds or self._DEFAULTS

    def evaluate(self, readings: Dict[str, Dict[str, Any]]) -> str:
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


async def sensor_loop(
    sensors: Dict[str, BaseSensor],
    update_interval: float,
    queues: List[asyncio.Queue],
) -> None:
    """Read all sensors at a fixed interval and fan-out to every queue."""
    try:
        while True:
            readings = {name: sensor.read() for name, sensor in sensors.items()}
            for q in queues:
                await q.put(("sensor", readings))
            await asyncio.sleep(update_interval)
    except asyncio.CancelledError:
        logger.info("sensor_loop detenido.")
        raise


async def vision_loop(vision: StubVision, queues: List[asyncio.Queue]) -> None:
    """Capture detections at the vision subsystem's own pace and fan-out."""
    try:
        while True:
            detections = await vision.capture()
            for q in queues:
                await q.put(("vision", detections))
    except asyncio.CancelledError:
        logger.info("vision_loop detenido.")
        raise


async def comms_loop(comms: StubComms, queue: asyncio.Queue) -> None:
    """Drain comms_queue and forward each item to the communications subsystem."""
    try:
        while True:
            item_type, data = await queue.get()
            try:
                if item_type == "sensor":
                    comms.send_readings(data)
                elif item_type == "vision":
                    comms.send_detections(data)
            finally:
                queue.task_done()
    except asyncio.CancelledError:
        logger.info("comms_loop detenido.")
        raise


async def decision_loop(
    decision: StubDecision,
    queue: asyncio.Queue,
    exporter: Optional[DatasetExporter] = None,
) -> None:
    """Drain decision_queue, evaluate risk level, log Rich table, export CSV."""
    _COLOURS = {"green": "bold green", "yellow": "bold yellow", "red": "bold red"}

    try:
        while True:
            item_type, data = await queue.get()
            try:
                if item_type != "sensor":
                    continue  # vision items skipped here

                level = decision.evaluate(data)

                # ── CSV export ──────────────────────────────────────────────
                if exporter:
                    flat: Dict[str, Any] = {
                        "temp":     data.get("temperature", {}).get("value", ""),
                        "gas":      data.get("gas",         {}).get("value", ""),
                        "distance": data.get("distance",    {}).get("value", ""),
                    }
                    for opt in ("humidity", "pressure"):
                        if opt in data:
                            flat[opt] = data[opt].get("value", "")
                    exporter.log_telemetry(flat, level.upper())

                # ── Console table ───────────────────────────────────────────
                table = Table(title="ARGOS · Estado de Sensores", title_style="bold blue")
                table.add_column("Sensor", style="cyan",    no_wrap=True)
                table.add_column("Valor",  style="magenta")
                for name, reading in data.items():
                    table.add_row(name, str(reading.get("value", "–")))
                console.print(table)
                console.rule(
                    f"Nivel de riesgo: {level.upper()}",
                    style=_COLOURS.get(level, "white"),
                )
                logger.info("Risk state: %s", level)

            finally:
                queue.task_done()

    except asyncio.CancelledError:
        logger.info("decision_loop detenido.")
        raise


###############################################################################
# Hub orchestrator
###############################################################################


async def main_hub(cfg: dict, mode: str) -> None:
    """Wire up all subsystems and run them concurrently.

    Parameters
    ----------
    cfg:
        Configuration dictionary loaded from ``argos.yaml``.
    mode:
        ``"simulated"`` or ``"hardware"``.
    """
    # ── Logging from YAML ──────────────────────────────────────────────────
    log_cfg = cfg.get("logging", {})
    setup_logging(
        level=log_cfg.get("level", "INFO"),
        log_file=log_cfg.get("file"),
    )

    console.rule(f"ARGOS Hub — mode={mode}")
    project = cfg.get("project", {})
    console.print(
        f"[bold]Proyecto:[/bold] {project.get('name', 'ARGOS')} "
        f"v{project.get('version', '1.0.0')}\n"
    )

    sensors_cfg = cfg.get("sensors", {})

    # ── Sensors ────────────────────────────────────────────────────────────
    sensors: Dict[str, BaseSensor] = {}

    if mode == "simulated":
        sensors = {
            "temperature": SimulatedSensor("temperature", 20.0, 35.0),
            "gas":         SimulatedSensor("gas",         200.0, 900.0),
            "distance":    SimulatedSensor("distance",    0.2,   5.0),
        }
    else:
        # Temperature — PT100 via MAX31865
        try:
            from .sensors.pt100 import PT100Sensor  # type: ignore
            temp_cfg = sensors_cfg.get("temperature", {})
            sensors["temperature"] = PT100Sensor(
                cs_pin=temp_cfg.get("cs_pin", 17),
                rref=temp_cfg.get("rref", 430.0),
                wires=temp_cfg.get("wires", 3),
            )
            logger.info("PT100Sensor inicializado.")
        except Exception as exc:
            logger.warning("PT100Sensor no disponible (%s); usando simulación.", exc)
            sensors["temperature"] = SimulatedSensor("temperature", 20.0, 35.0)

        # Gas — MQ-5 digital
        try:
            from .sensors.mq5 import SensorMQ5  # type: ignore
            gas_cfg = sensors_cfg.get("gas", {})
            sensors["gas"] = SensorMQ5(
                pin_gas=gas_cfg.get("pin", 22),
                warmup_s=gas_cfg.get("warmup_s", 2.0),
            )
            logger.info("SensorMQ5 inicializado.")
        except Exception as exc:
            logger.warning("SensorMQ5 no disponible (%s); usando simulación.", exc)
            sensors["gas"] = SimulatedSensor("gas", 200.0, 900.0)

        # Distance — VL53L0X (driver pendiente → simulación)
        logger.warning("Driver VL53L0X pendiente; usando simulación para distancia.")
        sensors["distance"] = SimulatedSensor("distance", 0.2, 5.0)

    # ── Communications ────────────────────────────────────────────────────
    if mode == "hardware":
        from .comms.lora import LoRaTransmitter  # type: ignore
        lora_cfg = cfg.get("comms", {}).get("lora", {})
        comms = LoRaTransmitter(
            port=lora_cfg.get("port", "/dev/ttyUSB0"),
            baud=lora_cfg.get("baud", 115200),
        )
    else:
        comms = StubComms()

    # ── Vision ────────────────────────────────────────────────────────────
    vision_cfg = cfg.get("vision", {})
    vision = StubVision(interval_s=vision_cfg.get("interval_s", 2.0))

    # ── Decision engine ───────────────────────────────────────────────────
    decision = StubDecision(thresholds=cfg.get("thresholds"))

    # ── Dataset exporter ──────────────────────────────────────────────────
    # parents[3] → ARGOS/ project root
    project_root = Path(__file__).resolve().parents[3]
    dataset_cfg  = cfg.get("dataset", {})
    export_dir   = project_root / dataset_cfg.get("export_dir", "datasets/exports")
    exporter: Optional[DatasetExporter] = None
    if dataset_cfg.get("enabled", True):
        exporter = DatasetExporter(export_dir=str(export_dir))
        logger.info("DatasetExporter activo → %s", export_dir)

    # ── Queues (one per consumer — no message stealing) ───────────────────
    comms_queue:    asyncio.Queue = asyncio.Queue()
    decision_queue: asyncio.Queue = asyncio.Queue()

    # ── Tasks ─────────────────────────────────────────────────────────────
    tasks = [
        asyncio.create_task(
            sensor_loop(sensors, sensors_cfg.get("interval_s", 5.0), [comms_queue, decision_queue]),
            name="sensor_loop",
        ),
        asyncio.create_task(
            vision_loop(vision, [comms_queue, decision_queue]),
            name="vision_loop",
        ),
        asyncio.create_task(
            comms_loop(comms, comms_queue),
            name="comms_loop",
        ),
        asyncio.create_task(
            decision_loop(decision, decision_queue, exporter=exporter),
            name="decision_loop",
        ),
    ]

    logger.info("Hub iniciado con %d loops.", len(tasks))
    try:
        await asyncio.gather(*tasks)
    except asyncio.CancelledError:
        pass
    finally:
        for t in tasks:
            if not t.done():
                t.cancel()
        await asyncio.gather(*tasks, return_exceptions=True)
        logger.info("Todos los loops detenidos limpiamente.")


def run(config_path: Optional[str], mode: str) -> None:
    """Load config and launch the async hub.

    CLI ``mode`` overrides the ``mode`` key in ``argos.yaml``.
    Ctrl-C is handled gracefully.
    """
    cfg = load_config(config_path)
    effective_mode = mode or cfg.get("mode", "simulated")

    try:
        asyncio.run(main_hub(cfg, effective_mode))
    except KeyboardInterrupt:
        console.print("\n[bold yellow]Apagado solicitado. Saliendo de ARGOS hub.")
