# Release schedule — ARGOS (2026)

Objetivo: registrar releases con entregables claros, evitando cambios constantes de estructura.

Formato:
- Cada release se documenta en `docs/releases/vX.Y.Z.md`
- Se actualiza `VERSION` + `CHANGELOG.md`
- Se crea tag `vX.Y.Z` en Git

## Reglas de versionado (SemVer)
- MAJOR: cambios grandes (estructura/contratos) o “hito” de estabilidad pública.
- MINOR: nuevas funciones compatibles (sensores, LoRa, visión, reportes).
- PATCH: correcciones sin cambiar comportamiento principal.

Referencia SemVer: https://semver.org/spec/v2.0.0.html

## Roadmap por releases (propuesto)
### v1.0.0 — Baseline (ya)
- Repo estable + docs + plantillas
- Base de software para Raspberry Pi 5
- Manual del equipo

### v1.1.0 — Sensores estables + logging
Entregables mínimos:
- BME280 + VL53L0X funcionando con lectura estable
- Registro local unificado (CSV/JSON) con timestamps
- Checklist de pruebas completado

### v1.2.0 — Telemetría LoRa 433 MHz (canal crítico)
Entregables mínimos:
- Envío/recepción estable de estado + alertas
- Métricas de enlace (pérdidas; RSSI/SNR si aplica)
- Prueba en “cueva simulada” (mínimo 3 sesiones)

### v1.3.0 — Visión + evidencia
Entregables mínimos:
- Captura de cámara estable
- Detección básica (clases definidas)
- Evidencias automáticas por evento (captura + log)

### v1.4.0 — Demo integrado (FLL-ready)
Entregables mínimos:
- Flujo antes–durante–después completo
- Reporte final automático
- Demo repetible (misma prueba, mismo resultado)

### v1.5.0 — Endurecimiento (robustez)
Entregables mínimos:
- Mejoras de arranque, recuperación ante fallos, y energía
- Documentación final para jueces y público externo

## Recomendación de cadencia
- 1 release MINOR cada 2–4 semanas (según avances reales)
- PATCH cuando se arreglen fallos críticos (sin esperar release grande)