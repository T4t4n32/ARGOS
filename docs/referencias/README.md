# ARGOS: resumen ejecutivo

Este documento resume la motivación, objetivos y alcance del proyecto
ARGOS.  Para detalles extensos sobre arquitectura, materiales,
implementación y marco teórico, consulta el archivo original en el
repositorio raíz o la documentación académica en esta misma carpeta.

## Objetivo general

Construir un prototipo demostrable que reduzca el riesgo en cuevas
mediante la integración de sensórica ambiental, detección de
obstáculos, visión computacional y telemetría robusta por LoRa.  El
sistema emite un semáforo (GO/AMARILLO/ROJO), identifica elementos
claves (casco, persona, cuerda, etc.), detecta anomalías y genera un
reporte final con métricas y evidencias.

## Alcance V1

ARGOS V1 es un proyecto educativo que no sustituye instrumentación
profesional ni protocolos reales de exploración.  Se prueba únicamente
en entornos simulados y su sensórica de gas (MQ‑135) se utiliza como
indicador cualitativo de “aire degradado” en combinación con medidas
futuras de CO₂/O₂.

## Métricas de éxito sugeridas

| Variable | Métrica sugerida |
|---------|------------------|
| Seguridad ambiental | Estabilidad de lecturas, tasa de falsos ROJO |
| Obstáculos | Latencia detección → alerta |
| IA | Precisión por clase, tasa de anomalías |
| LoRa | Alcance útil, tasa de entrega |
| Demo | Tiempo para comprender el sistema, calidad del reporte final |

Para mayor detalle y justificación teórica, revisa los documentos
referenciados en esta carpeta y en la tesis.