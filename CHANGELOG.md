# Changelog — ARGOS (CALIBOTS KAIROS)

Este archivo cuenta la historia real del proyecto **ARGOS**: lo que se construyó, lo que se mejoró y lo que falta.
Está escrito para que lo entienda tanto un jurado como alguien del equipo que llega nuevo.

Formato basado en:
- Keep a Changelog: https://keepachangelog.com/en/1.0.0/
- Semantic Versioning (SemVer): https://semver.org/

## Convenciones rápidas
- **Added**: algo nuevo aparece.
- **Changed**: algo existe, pero cambia su forma o comportamiento.
- **Fixed**: se arregla algo que estaba mal.
- **Removed**: se elimina algo (por decisión).
- **Docs**: documentación.
- **Safety**: cambios que afectan seguridad física/protocolo.

## “Nota humana”
Sí: estamos aprendiendo.  
Sí: a veces algo funciona… y al siguiente día deja de funcionar.  
No: no inventamos resultados ni “milagros”. Aquí solo se escribe lo que existe o lo que quedó planificado con claridad.

---

## [Unreleased]
> Lo que está en trabajo activo. Entra aquí primero, y cuando se cumpla el entregable, se pasa a una versión.

### Added
- Integración del prototipo actual dentro de `software/legacy/` como “fuente de verdad” del V1 operativo.
- Registro de sesión unificado (logs por timestamp) con estructura estable para análisis posterior.
- Reporte final de sesión (resumen de estado, alertas, eventos y evidencia).
- Telemetría LoRa 433 MHz como canal crítico: estado + alertas en paquetes cortos.

### Changed
- Organización del software hacia módulos (sensores / comunicación / decisión / visión) sin romper el prototipo base.
- Estandarización de nombres de archivos y rutas para que el equipo no pierda tiempo buscando “dónde iba esto”.

### Fixed
- Recuperación ante fallos comunes de prototipo (lecturas inestables, reinicios, desconexiones).
- Robustez de arranque (que el sistema no dependa de “hacer magia” para iniciar).

### Docs
- Ajustes finos del documento por capítulos cuando existan resultados medibles (Cap. 4 y Cap. 5).
- Plantillas de pruebas completadas con datos reales (no simulados).

### Safety
- Checklist de operación y advertencias validadas por coaches antes de cualquier demo.

---

## [1.0.0] — 2026-03-10
**Release:** “Base sólida, sin improvisar”

### Added
- Repositorio formal y estable con estructura clara:
  - `docs/`, `software/`, `hardware/`, `assets/`, `datasets/`, `deploy/`, `tests/`.
- Documentación tipo proyecto por capítulos (1–5) lista para desarrollo:
  - Cap. 4 y 5 quedaron como plantilla (sin inventar resultados).
- Manual del equipo en PDF para que cualquiera pueda explicar ARGOS sin depender de slides.
- Plantillas operativas:
  - cronograma, BOM, plan de pruebas, bitácora, checklist, guía de entrevista.
- Referencias formales (APA e IEEE) para sostener el proyecto con fuentes reales.
- Guía de identidad visual y selección oficial de logos:
  - `LOGO_ARGOS.png`, `SIN FONDO.png`, `SINFONDO_12.png`.

### Changed
- Definición oficial del enfoque: **Antes – Durante – Después** (operación) como eje del proyecto.
- Mensaje oficial del proyecto: prototipo educativo con enfoque de seguridad operativa y trazabilidad.

### Fixed
- Eliminación de ambigüedad en el discurso:
  - ARGOS no es “solo reconocer cuevas”.
  - ARGOS es protocolo: medir → decidir → alertar → evidenciar.

### Docs
- Documento base listo para que cualquier integrante pueda:
  - presentar el problema,
  - justificar el proyecto,
  - y entender el plan de pruebas.

### Safety
- Política de seguridad incluida:
  - pruebas solo en entornos controlados,
  - y sin presentar MQ-135 como sensor de oxígeno.

#### En palabras del equipo (versión corta)
- “Dejamos de improvisar. Ahora todo tiene lugar, nombre y explicación.”
- “Si alguien se pierde, el repo lo trae de vuelta.”

---

## [0.1.0] — 2026-03-01
**Release:** “Primer orden real”

### Added
- Estructura inicial del proyecto y acuerdos técnicos de alto nivel.
- Primera versión de la narrativa: seguridad + telemetría + evidencia.

### Changed
- Se decidió una ruta realista de prototipo: Raspberry Pi como núcleo y evolución por módulos.

### Fixed
- “El proyecto existe solo en la cabeza” → pasó a documentos claros.
- “Cada quien tiene su versión” → se unificó una versión base.

#### En palabras del equipo
- “Todavía era caos, pero ya era un caos con carpetas.”

---

## Próximos releases (planificados, no publicados)
> Esto es un mapa. No se marca como “hecho” hasta tener evidencia (logs, pruebas y demo repetible).

### [1.1.0] — Sensores + logging estable
**Meta:** lecturas confiables + registro por sesión listo para analizar.

### [1.2.0] — LoRa 433 MHz estable
**Meta:** telemetría crítica operativa y medida (pérdidas/estabilidad).

### [1.3.0] — Visión + evidencia
**Meta:** capturas por evento y evidencia clara, incluso en baja iluminación con luz controlada.

### [1.4.0] — Demo integrado (FLL-ready)
**Meta:** “antes–durante–después” completo, repetible y defendible ante jueces.

---

## Cómo se acepta un cambio en el Changelog (regla interna)
Un cambio entra al changelog si cumple mínimo:
- Qué cambió (1 línea)
- Por qué importa (1 línea)
- Evidencia (log / foto / video / reporte)

Porque esto lo construye un equipo joven, sí…  
pero con disciplina de ingeniería.