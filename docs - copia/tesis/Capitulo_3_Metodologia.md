# Capítulo 3 — Metodología

## 3.1 Enfoque y diseño
Metodología de **desarrollo tecnológico/ingeniería** con prototipado iterativo:
1) Requerimientos → 2) Diseño → 3) Implementación → 4) Pruebas controladas → 5) Iteración.

## 3.2 Recolección de datos (qué se mide)
- Sensores: T/H (BME280), proxy aire (MQ-135), distancia (VL53L0X).
- Telemetría: estado/alertas LoRa, tasa de pérdida, RSSI/SNR (si aplica).
- Visión: detecciones por clase y capturas cuando se active “anomalía”.
- Energía: voltaje/corriente (si se instrumenta).

## 3.3 Población y muestra (validación cualitativa)
- 2–5 entrevistas a perfiles cercanos (docente, SST, rescate, ciencias) para validar narrativa/uso.

## 3.4 Instrumentos
- Checklist pre/durante/post.
- Plan de pruebas (métricas).
- Bitácora de iteraciones.
- Guía de entrevista.

## 3.5 Procedimiento (paso a paso)
1) Pruebas unitarias de cada sensor.  
2) Integración de sensores + motor de riesgo + logs.  
3) Integración LoRa (telemetría) + pruebas de alcance.  
4) Integración cámara + pipeline visión (OpenCV/YOLO).  
5) Prueba de misión completa en “cueva simulada”.  
6) Análisis y mejoras (PHVA / mejora continua).

## 3.6 Métricas (V1)
- Latencia alerta (ms).
- Pérdida de paquetes (%).
- Autonomía (min).
- Estabilidad de lecturas (desviación).
- Desempeño de detección (precision/recall básico en dataset propio).

## 3.7 Cronograma (resumen)
Ver plantilla en: `docs/plantillas/Cronograma.md`.
