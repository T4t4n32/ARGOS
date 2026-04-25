# Flujo operativo — ARGOS V1 (antes/durante/después)

## Antes (pre-entrada)
1) Encendido y autodiagnóstico (sensores y radio).
2) Lecturas iniciales → estado (verde/amarillo/rojo).
3) Registro: `precheck` con timestamp.

## Durante (operación)
Loop cada N segundos:
- Sensores ambientales → evaluación de tendencia.
- ToF → alertas anti-colisión.
- Visión → detecciones y capturas ante “anomalía”.
- LoRa → envío de estado + eventos críticos.
- Log local continuo.

## Después (cierre)
1) Cierre de sesión.
2) Reporte final (resumen de máximos/mínimos, eventos y enlace).
3) Exportación por Wi‑Fi (si disponible) o extracción manual.

NIOSH 86-110 enfatiza evaluación previa y monitoreo continuo: https://www.cdc.gov/niosh/docs/86-110/default.html
