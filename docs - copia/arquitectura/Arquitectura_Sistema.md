# Arquitectura del sistema — ARGOS V1 (bloques)

## 1. Visión general
ARGOS V1 sigue el patrón: **Sensado → Procesamiento → Decisión → Comunicación → Evidencia**.

## 2. Entradas (sensado)
- BME280: temperatura/humedad/presión (I²C).
- MQ-135: proxy de aire (analógico; usualmente requiere ADC si se lee en una Raspberry).
- VL53L0X: distancia ToF (I²C).
- Cámara (USB o CSI).
- Estado energético (recomendado en V1.1).

## 3. Procesamiento (Raspberry Pi 5)
- Filtrado (promedio móvil / mediana).
- Motor de riesgo (verde/amarillo/rojo).
- Visión (OpenCV + YOLO).
- Registro (logs + eventos).

Raspberry Pi 5 (Product Brief): https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-product-brief.pdf

## 4. Salidas
- LoRa 433 MHz (crítica): estado y alertas.
- Wi‑Fi (opcional): descarga de logs/evidencias en superficie.
- Reporte final: JSON/CSV + carpeta de evidencias.

Semtech SX1262: https://www.semtech.com/products/wireless-rf/lora-transceivers/sx1262

## 5. Regla operativa
En V1, la telemetría debe funcionar incluso si la visión falla, y los logs deben existir incluso si LoRa falla.
