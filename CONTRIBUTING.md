# CONTRIBUTING — ARGOS (CALIBOTS KAIROS)
**Cómo contribuir sin romper el proyecto**

ARGOS es un proyecto escolar, pero se mantiene con disciplina:  
**orden, evidencia y seguridad**.

Este archivo define exactamente cómo se trabaja en el repositorio para que el proyecto avance sin caos.

---

## 1) Principios del proyecto (lo que no se negocia)
1. **Estructura estable:** no se reorganizan carpetas “porque sí”.
2. **Evidencia real:** cualquier cambio importante se acompaña de prueba (log/foto/video/reporte).
3. **Seguridad primero:** si un cambio aumenta riesgo físico, se revisa con coach antes de probar.
4. **Cero exageración:** no se declara “listo” sin verificación.

---

## 2) Qué tipo de contribuciones aceptamos
### Código
- Lectura estable de sensores (BME280, VL53L0X, MQ-135 vía ADC si aplica).
- Telemetría LoRa 433 MHz (paquetes cortos, estabilidad, métricas).
- Motor de riesgo (estados Verde/Amarillo/Rojo) con logs claros.
- Visión computacional (captura + evidencia por evento).
- Reporte final de sesión (resumen de máximos/mínimos, eventos y fallos).

### Documentación
- Correcciones de texto, coherencia técnica y ortografía.
- Mejoras a plantillas (plan de pruebas, cronograma, checklist).
- Referencias y sustento (sin inventar fuentes).
- Diagramas de arquitectura y cableado.

### Hardware
- Diagramas de conexión, lista BOM, recomendaciones de energía.
- Mejores prácticas de montaje y protección.

---

## 3) Reglas de trabajo (Git y organización)

### 3.1 Nombres de ramas
- `feature/<tema>` — nueva función
- `fix/<tema>` — corrección
- `docs/<tema>` — documentación
- `hardware/<tema>` — cambios en hardware
- `release/<version>` — preparación de release

Ejemplos:
- `feature/lora-telemetry`
- `fix/vl53l0x-timeout`
- `docs/tesis-cap2-update`

### 3.2 Commits (estilo y claridad)
Commits cortos y claros. Formato recomendado:
- `Add: ...`
- `Fix: ...`
- `Docs: ...`
- `Refactor: ...`

Ejemplos:
- `Add: lora packet encoder for alerts`
- `Fix: bme280 read retry on i2c error`
- `Docs: update safety thresholds references`

---

## 4) Dónde va cada cosa (para no perder tiempo)
- **Documentación:** `docs/`
- **Código Pi 5:** `software/`
- **Prototipo original (sin tocar):** `software/legacy/current_prototype.py`
- **Hardware/BOM:** `hardware/`
- **Identidad visual:** `assets/brand/`
- **Datasets (sin crudos):** `datasets/`
- **Servicios y despliegue:** `deploy/`
- **Pruebas:** `tests/`

Regla:
> Si no sabes dónde va, no lo subas todavía. Pregunta primero.

---

## 5) Evidencia mínima por contribución (obligatorio)
Cualquier cambio que afecte funcionamiento debe incluir al menos 1 evidencia:

✅ Evidencias válidas:
- log de consola
- archivo `log.csv` / `session.json`
- foto de montaje/cableado
- video corto de prueba (10–30s)
- captura de detección (visión)
- tabla simple de resultados (pérdida LoRa, latencia, etc.)

❌ No válido:
- “a mí me funcionó”
- “debería servir”
- “lo probé pero no guardé evidencia”

---

## 6) Checklist antes de subir cambios
### Software (mínimo)
- El código corre en modo simulado (si aplica).
- No rompe el arranque del proyecto.
- Logs no se suben al repo (`data/`, `logs/` van en `.gitignore`).
- Configuración se hace por `software/config/argos.yaml` (no hardcodear pines).

### Documentación
- Si cambias algo importante, actualiza el capítulo o plantilla relevante.
- Si agregas referencias, deben ser reales y citables.

### Seguridad
- Si el cambio afecta energía/motores/batería, se registra advertencia en `docs/seguridad/` o `SECURITY`.

---

## 7) Cambios que requieren revisión estricta
Estos cambios no se integran sin revisión:
- energía (baterías, reguladores, corrientes),
- control de motores (drivers, PWM),
- LoRa (potencia, estabilidad, paquetes críticos),
- umbrales de seguridad o lógica de riesgo,
- cambios de estructura del repo.

---

## 8) Política de archivos sensibles (repositorio limpio)
Prohibido subir:
- credenciales, tokens, `.env`,
- información privada del equipo/colegio,
- datasets crudos grandes (por defecto),
- carpetas personales (ej. `.obsidian/`).

---

## 9) Cómo proponer una mejora (formato recomendado)
Cuando propongas un cambio grande, describe:

1) **Qué problema resuelve**
2) **Qué cambia**
3) **Cómo se prueba**
4) **Qué evidencia entrega**

Ejemplo corto:
- Problema: lecturas ToF fallan en algunos ciclos  
- Cambio: reintento y timeout  
- Prueba: 10 min de lectura continua  
- Evidencia: log + gráfica simple (opcional)

---

## 10) Frase oficial del equipo (la que se respeta siempre)
> “ARGOS avanza con evidencia y seguridad, no con suposiciones.”

Gracias por contribuir. Aquí se construye en serio, aunque todavía estemos aprendiendo.