# Plantilla — Plan de pruebas (ARGOS V1)

## Tabla principal
| Prueba | Objetivo | Procedimiento | Métrica | Criterio de éxito | Evidencia |
|---|---|---|---|---|---|
| Sensores ambientales | Validar estabilidad | 10 min lectura continua | desviación | < umbral definido | log.csv |
| ToF anti-colisión | Validar umbral | acercar a obstáculo | latencia | < X ms | video + logs |
| LoRa enlace | Validar comunicación | pruebas por distancia | pérdida % | < X% | rssi.csv |
| Visión | Validar detección | dataset + inferencia | precision/recall | >= meta | reporte |
| Energía | Validar autonomía | sesión completa | minutos | >= meta | mediciones |

## Notas
- Documentar condiciones (luz, distancia, obstáculos, paredes).
- Guardar configuración de parámetros usada en cada prueba.
