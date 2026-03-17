from __future__ import annotations

"""Runtime entry point for the ARGOS application.

This module defines helper functions to load configuration and to run
the application in either simulated or hardware mode.  It currently
provides a scaffold implementation; integration of sensor drivers,
communication stacks and the decision engine should be added under
their respective subpackages.
"""

import os
from pathlib import Path
import yaml
from rich.console import Console

console = Console()


def load_config(config_path: str | None) -> dict:
    """Load the YAML configuration for ARGOS.

    The search order for the configuration is:
    1. The explicit ``config_path`` argument passed to ``run``.
    2. The environment variable ``ARGOS_CONFIG``, if set.
    3. A default file at ``config/argos.yaml`` relative to the project root.

    ``runtime.py`` resides in ``software/src/argos_app``. The project root
    is therefore four levels up from this file. By resolving the absolute
    path of ``__file__`` we can derive the project root dynamically.
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


def run(config_path: str | None, mode: str) -> None:
    """Run the ARGOS application.

    At present this function only loads the configuration and prints a
    placeholder banner. In future, it should initialise sensors,
    communications and the vision pipeline, then enter the main event
    loop.
    """
    cfg = load_config(config_path)
    console.rule(f"ARGOS V1 — mode={mode}")
    project = cfg.get("project", {})
    console.print(f"Project: {project.get('name')} v{project.get('version')}")
    console.print("This is a scaffold. Integrate sensors, LoRa and vision step-by-step.")
    console.print("Next: implement modules in sensors/, comms/, decision/, vision/.")
