"""Command line interface for the ARGOS application.

This module defines a simple CLI that wraps the runtime and exposes a
single entry point called ``argos`` when the package is installed via
``pip``.  Users can specify a configuration file and choose between
simulated and hardware modes.
"""

import argparse
from argos_app.runtime import run


def main() -> int:
    """Execute the ARGOS application.

    The ``--config`` argument allows the user to specify a custom
    configuration file. If omitted, the application falls back to the
    environment variable ``ARGOS_CONFIG`` or, failing that, to
    ``config/argos.yaml`` in the project root.

    The ``--mode`` flag toggles between ``simulated`` and ``hardware``
    execution. In simulated mode, sensors are stubbed and random or
    placeholder values are emitted. In hardware mode, the Raspberry Pi
    peripherals are initialized and actual sensors are read.
    """
    parser = argparse.ArgumentParser(
        prog="argos",
        description="ARGOS system runtime (see README for full details)",
    )
    parser.add_argument(
        "--config",
        default=None,
        help=(
            "Path to the YAML configuration file. "
            "Defaults to the ARGOS_CONFIG environment variable or config/argos.yaml."
        ),
    )
    parser.add_argument(
        "--mode",
        default="simulated",
        choices=["simulated", "hardware"],
        help="Select run mode (default: simulated)",
    )
    args = parser.parse_args()
    run(config_path=args.config, mode=args.mode)
    return 0