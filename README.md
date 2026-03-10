# ARGOS — Sistema Integral de Reconocimiento y Seguridad en Cuevas

**ARGOS V1** es un prototipo funcional de **seguridad operativa** para exploración en entornos tipo cueva. Convierte una exploración incierta en un proceso **medible, trazable y comunicable** mediante un protocolo claro:

**Medir → Decidir → Alertar → Registrar evidencia**

> Estado: **Operativo (V1)** sobre **Raspberry Pi 5**.

---

## Contenido
- [Qué es ARGOS](#qué-es-argos)
- [Qué resuelve](#qué-resuelve)
- [Cómo funciona](#cómo-funciona)
- [Ventajas](#ventajas)
- [Impacto](#impacto)
- [Requisitos](#requisitos)
- [Instalación y ejecución](#instalación-y-ejecución)
- [Configuración](#configuración)
- [Salidas y evidencias](#salidas-y-evidencias)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Contribuir](#contribuir)
- [Licencia](#licencia)
- [Seguridad](#seguridad)
- [Créditos](#créditos)

---

## Qué es ARGOS
ARGOS V1 es un sistema que **evalúa y monitorea** condiciones relevantes para seguridad en entornos subterráneos, emite **alertas operacionales** y genera **evidencia verificable** (logs + capturas) para análisis posterior.

ARGOS opera en 3 momentos:
- **Antes:** autodiagnóstico + evaluación inicial del entorno (estado de riesgo).
- **Durante:** monitoreo continuo + anti-colisión + telemetría LoRa + evidencia.
- **Después:** reporte final de sesión y trazabilidad de eventos.

---

## Qué resuelve
En cuevas y entornos similares, los riesgos más críticos suelen combinar:
- condiciones ambientales que pueden deteriorarse (aire/temperatura/ventilación),
- baja visibilidad y obstáculos (colisiones/atascos),
- pérdida de comunicación,
- ausencia de evidencia técnica para analizar incidentes y mejorar protocolos.

ARGOS V1 responde con un flujo operativo repetible: **datos → decisiones → alertas → evidencia**.

---

## Cómo funciona
ARGOS sigue una arquitectura simple y robusta:

**Sensores + Cámara → Raspberry Pi 5 → Motor de riesgo → LoRa (telemetría crítica) + Evidencias (logs/capturas) → Reporte final**

### Módulos V1
- **Sensado ambiental**
  - BME280: temperatura/humedad/presión
  - MQ-135: proxy cualitativo de “aire degradado” (no mide O₂)
- **Mitigación física**
  - VL53L0X (ToF): distancia y alerta por proximidad (anti-colisión)
- **Visión + evidencia**
  - Cámara + iluminación (linterna/LED): detección y registro de eventos/anomalías
- **Telemetría crítica**
  - LoRa 433 MHz: estado y alertas en paquetes cortos
- **Trazabilidad**
  - Logs con timestamp + capturas + reporte de sesión (CSV/JSON)

---

## Ventajas
- **Operación clara:** protocolo antes–durante–después.
- **Telemetría robusta:** canal crítico LoRa 433 MHz (independiente de internet).
- **Evidencia real:** logs y capturas para auditoría y mejora.
- **Escalable:** V1 demuestra integración; V2/V3 pueden mejorar sensores, carcasa y cobertura.
- **Enfoque educativo-profesional:** diseñado para trabajo STEM/FLL con rigor y documentación.

---

## Impacto
ARGOS V1 aporta valor en:
- **prevención** (datos antes de operar),
- **mitigación** (alertas durante),
- **aprendizaje y mejora** (evidencia después),
- **transferencia educativa** (documentación formal para replicar y evolucionar el sistema).

---

## Requisitos

### Hardware V1 (objetivo)
- Raspberry Pi 5
- Cámara: webcam USB (principal) / iPhone (solo soporte de demo si se usa)
- 4 motores (tracción) + driver
- Sensores:
  - BME280
  - MQ-135
  - VL53L0X
- LoRa 433 MHz
- Iluminación (linterna/LED)

### Software
- Raspberry Pi OS (recomendado 64-bit)
- Python 3
- Dependencias Python (ver `software/requirements.txt`)

---

## Instalación y ejecución

### 1) Clonar el repositorio
```bash
git clone <URL_DEL_REPO>
cd ARGOS
````

### 2) Preparar el entorno (Raspberry Pi)

```bash
cd software
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3) Configurar

```bash
cp config/argos.example.yaml config/argos.yaml
```

### 4) Ejecutar (modo hardware)

```bash
python -m argos_app --mode hardware
```

### 5) Ejecutar (modo simulado / pruebas sin hardware)

```bash
python -m argos_app --mode simulated
```

---

## Configuración

La configuración vive en:

* `software/config/argos.yaml`

Ahí se definen:

* buses I2C/SPI,
* direcciones de sensores,
* pines de motores y luz,
* parámetros de telemetría,
* umbrales operativos.

Archivo de ejemplo:

* `software/config/argos.example.yaml`

---

## Salidas y evidencias

ARGOS genera evidencia de sesión de forma automática:

* **Logs**

  * ubicados en `data/logs/` (no versionado)
  * incluyen timestamps y eventos (estado, alertas, telemetría, visión)

* **Evidencias (capturas)**

  * ubicadas en `data/evidence/` (no versionado)
  * capturas asociadas a eventos (p. ej. anomalía)

* **Reporte final**

  * resumen de máximos/mínimos, alertas y estabilidad del enlace
  * exportable por Wi-Fi cuando esté disponible

> Detalles de formatos y plantillas: `docs/plantillas/` y `docs/seguridad/`.

---

## Estructura del repositorio

Estructura estable del proyecto:

```
ARGOS/
├── README.md
├── VERSION
├── CHANGELOG.md
├── LICENSE.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── assets/
│   └── brand/
├── docs/
│   ├── tesis/
│   ├── arquitectura/
│   ├── seguridad/
│   ├── plantillas/
│   ├── referencias/
│   ├── releases/
│   └── identidad/
├── software/
│   ├── README.md
│   ├── requirements.txt
│   ├── config/
│   ├── legacy/
│   └── src/
├── hardware/
├── datasets/
├── deploy/
└── tests/
```

---

## Contribuir

Contribuciones se aceptan con enfoque profesional: cambios pequeños, evidencia y documentación.

* Guía completa: `CONTRIBUTING.md`
* Bitácora/formatos: `docs/plantillas/`
* Release notes: `docs/releases/`

### Estándar mínimo para un cambio aceptado

* descripción del cambio,
* prueba rápida (log/video/foto),
* actualización del changelog si aplica.

---

## Licencia

Ver `LICENSE.md`.

---

## Seguridad

ARGOS V1 es un prototipo educativo. No reemplaza instrumentos certificados ni autoriza ingreso a cuevas reales.
Política y advertencias: `SECURITY.md` y `docs/seguridad/`.

---

## Créditos

Proyecto desarrollado por **CALIBOTS KAIROS** — Colegio Comfandi El Prado (Cali, Valle del Cauca, Colombia).

Mentores/Coaches:

* Richard Suárez
* Diego
