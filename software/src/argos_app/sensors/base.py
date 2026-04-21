"""Base class for all ARGOS sensor drivers.

This module provides the :class:`BaseSensor` abstract class that all
concrete sensor implementations (PT100, MQ135, simulated, etc.) should
inherit from.  It lives in a separate module to avoid circular imports
between ``runtime.py`` and the sensor drivers.
"""

from __future__ import annotations

from typing import Any, Dict


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
