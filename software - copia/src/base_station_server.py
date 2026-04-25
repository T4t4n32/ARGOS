#!/usr/bin/env python3
"""
ARGOS Base Station Server
─────────────────────────
Servidor WebSocket que retransmite telemetría LoRa al Dashboard.

Modos de operación:
  --test       Genera datos simulados sin necesidad de hardware (por defecto).
  --hardware   Intenta conectar al módulo LoRa Rx por puerto serial.

Uso:
  python src/base_station_server.py              # Modo test (simulación)
  python src/base_station_server.py --hardware   # Modo hardware (serial)
"""

import asyncio
import json
import sys
import random
import time
from typing import Set

import websockets

# ─── Configuración ───────────────────────────────────────────────────────────
SERIAL_PORT = "/dev/ttyUSB0"
SERIAL_BAUD = 115200
WS_HOST = "0.0.0.0"
WS_PORT = 8765

connected_clients: Set = set()


# ─── Simulador de telemetría ─────────────────────────────────────────────────
class MockSimulator:
    """Genera datos realistas para probar el Dashboard sin hardware."""

    def __init__(self):
        self.temp = 24.0
        self.gas = 400
        self.distance = 1200

    def get_data(self) -> dict:
        self.temp += random.uniform(-0.5, 0.5)
        self.temp = max(18.0, min(38.0, self.temp))

        self.gas += random.uniform(-15, 25)
        self.gas = max(200, min(1800, self.gas))

        self.distance += random.uniform(-60, 60)
        self.distance = max(100, min(2000, self.distance))

        if self.gas > 800 or self.temp > 30.0 or self.distance < 500:
            risk = "CRITICAL"
        elif self.gas > 600 or self.temp > 28.0 or self.distance < 800:
            risk = "WARNING"
        else:
            risk = "NORMAL"

        return {
            "t": round(self.temp, 1),
            "g": int(self.gas),
            "d": int(self.distance),
            "risk": risk,
            "timestamp": time.time(),
            "source": "SIMULATION",
        }


# ─── WebSocket ───────────────────────────────────────────────────────────────
async def register(websocket):
    connected_clients.add(websocket)
    print(f"[WS] Cliente conectado ({len(connected_clients)} activos)")
    try:
        await websocket.wait_closed()
    finally:
        connected_clients.discard(websocket)
        print(f"[WS] Cliente desconectado ({len(connected_clients)} activos)")


async def broadcast(message: str):
    if connected_clients:
        clients = set(connected_clients)  # snapshot para evitar mutación
        await asyncio.gather(
            *[client.send(message) for client in clients],
            return_exceptions=True,
        )


# ─── Lectores de datos ──────────────────────────────────────────────────────
async def test_reader():
    """Genera datos simulados cada 2 segundos."""
    simulator = MockSimulator()
    while True:
        data = simulator.get_data()
        payload = json.dumps(data)
        print(f"[TEST] → {payload}")
        await broadcast(payload)
        await asyncio.sleep(2.0)


async def hardware_reader():
    """Lee datos reales desde el puerto serial del módulo LoRa Rx."""
    try:
        import serial  # Solo se importa si se usa modo hardware
    except ImportError:
        print("ERROR: El paquete 'pyserial' no está instalado.")
        print("       Instálalo con: pip install pyserial")
        print("       O usa el modo test: python src/base_station_server.py --test")
        return

    try:
        ser = serial.Serial(SERIAL_PORT, SERIAL_BAUD, timeout=1)
        print(f"✅ Conectado al módem LoRa en {SERIAL_PORT}")
    except Exception as e:
        print(f"ERROR: No se pudo abrir {SERIAL_PORT} ({e})")
        print("       Verifica que el Arduino Rx esté conectado por USB.")
        print("       Cayendo a modo test...")
        await test_reader()
        return

    while True:
        try:
            if ser.in_waiting > 0:
                line = ser.readline().decode("utf-8", errors="ignore").strip()
                if line.startswith("{") and line.endswith("}"):
                    print(f"[LoRa RX] → {line}")
                    await broadcast(line)
            await asyncio.sleep(0.01)
        except Exception as e:
            print(f"[LoRa RX] Error: {e}")
            await asyncio.sleep(2)


# ─── Main ────────────────────────────────────────────────────────────────────
async def main(mode: str):
    print("╔══════════════════════════════════════════════╗")
    print("║        ARGOS Base Station Server             ║")
    print(f"║  Modo: {mode.upper():<10s}  Puerto WS: {WS_PORT:<10d}   ║")
    print("╚══════════════════════════════════════════════╝")
    print(f"→ Dashboard: ws://{WS_HOST}:{WS_PORT}")
    print()

    reader = hardware_reader if mode == "hardware" else test_reader

    async with websockets.serve(register, WS_HOST, WS_PORT):
        await reader()


if __name__ == "__main__":
    mode = "test"
    if "--hardware" in sys.argv:
        mode = "hardware"

    try:
        asyncio.run(main(mode))
    except KeyboardInterrupt:
        print("\n[Server] Detenido por el usuario.")
