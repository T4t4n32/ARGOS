# Changelog

Todos los cambios notables en el proyecto ARGOS serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/),
y este proyecto se adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]
> Cambios actualmente en desarrollo activo. Se trasladarán a una versión formal cuando se completen y verifiquen las pruebas operativas.

### Added
- Integración del prototipo original dentro de `software/legacy/` como fuente de referencia operativa de la versión 1.
- Sistema de registro (logging) unificado con marcas de tiempo (timestamps) y estructura estable para análisis posterior.
- Generador de reportes de final de sesión (resumen de estado, alertas, eventos y evidencia técnica).
- Implementación de telemetría a través del módulo LoRa a 433 MHz como canal de comunicación crítico.

### Changed
- Refactorización de la arquitectura de software hacia módulos independientes (sensores, comunicaciones, decisión, visión).
- Estandarización de nomenclaturas de archivos y rutas del repositorio para mejorar la mantenibilidad.

### Fixed
- Mecanismos de recuperación ante fallos comunes del prototipo de hardware (lecturas inestables, reinicios de módulos, desconexiones I²C).
- Robustez en la secuencia de arranque del software principal.

### Security
- Validación de checklists operativos y advertencias de seguridad física antes de la ejecución de despliegues en simulaciones.

---

## [1.0.0] - 2026-03-10
**Release inicial: "Arquitectura Base y Estandarización"**

### Added
- Repositorio formal y estable con estructura modular (`docs/`, `software/`, `hardware/`, `assets/`, `datasets/`, `deploy/`, `tests/`).
- Documentación técnica del proyecto estructurada por capítulos.
- Plantillas operativas para el ciclo de ingeniería (cronogramas, lista de materiales - BOM, plan de pruebas, bitácoras).
- Lineamientos de identidad visual y logotipos oficiales.

### Changed
- Definición formal del flujo operativo en tres fases: **Antes, Durante y Después**.
- Alineación del mensaje institucional del proyecto: ARGOS se consolida como una plataforma educativa enfocada en seguridad operativa, medición y trazabilidad.

### Security
- Establecimiento de políticas de seguridad física para pruebas en entornos controlados ("cueva simulada").
- Aclaración técnica formal sobre las limitaciones del sensor MQ-135 como indicador proxy, desestimando su uso como sensor de oxígeno certificado.

---

## [0.1.0] - 2026-03-01
**Prototipo y Prueba de Concepto**

### Added
- Estructura inicial del repositorio y definición de acuerdos técnicos de alto nivel.
- Primera versión de la narrativa técnica: monitoreo, telemetría y recolección de evidencias.

### Changed
- Definición de la plataforma de hardware central (Raspberry Pi 5) y proyección de arquitectura modular.

---

## Roadmap Planificado

### [1.1.0] — Estabilización de Sensores
- **Meta:** Garantizar lecturas confiables de todos los módulos ambientales y consolidar el registro de telemetría por sesión para su posterior análisis.

### [1.2.0] — Red LoRa 433 MHz
- **Meta:** Puesta en producción de la telemetría remota. Medición de pérdida de paquetes y estabilidad de enlace a distancia.

### [1.3.0] — Visión y Evidencia
- **Meta:** Captura autónoma de fotogramas por evento y registro de evidencia en entornos de baja iluminación controlada.

### [1.4.0] — Demostración Integrada
- **Meta:** Validación del ciclo completo (Antes–Durante–Después) en un entorno repetible y auditable.