# SECURITY — ARGOS (CALIBOTS KAIROS)
**Posición oficial del proyecto sobre seguridad**

ARGOS es un proyecto educativo, pero se trabaja con seriedad:  
**ningún demo vale más que la seguridad de una persona.**

Este documento define una postura clara y práctica para:
- pruebas físicas,
- uso de hardware (baterías, motores, sensores),
- manejo de datos/evidencias,
- y seguridad del repositorio.

---

## 1) Postura oficial (sin negociación)
1. **ARGOS NO autoriza entrada a cuevas reales.**  
   ARGOS V1 es un prototipo educativo y se prueba en **entornos controlados** (“cueva simulada”).
2. **Si hay duda, se detiene la prueba.**  
   Si no se puede probar de forma segura, no se prueba.
3. **No se vende seguridad falsa.**  
   No se afirma “es seguro” si no hay medición certificada y supervisión profesional.
4. **La evidencia manda.**  
   Cualquier decisión técnica importante se sustenta con pruebas y registros (logs/fotos/video).

---

## 2) Alcance: qué cubre esta política
**Cubre:**
- pruebas del prototipo (Raspberry Pi 5, motores, sensores, LoRa),
- cableado, alimentación y baterías,
- operación en laboratorio/colegio,
- publicación y manejo del repositorio.

**No cubre:**
- certificaciones industriales,
- protocolos oficiales de rescate,
- uso real en cuevas (no permitido en V1).

---

## 3) Seguridad física (taller/laboratorio)

### 3.1 Reglas mínimas antes de encender
- Verificar conexiones (polaridad, tierra/masa, cables sueltos).
- Confirmar que la Raspberry Pi **no alimenta motores** directamente.
- Confirmar que existe método de apagado rápido (interruptor, desconexión segura).
- Zona despejada: nada metálico suelto cerca del circuito.

### 3.2 Motores y movimiento
- Los motores siempre van con **driver** (puente H) y alimentación adecuada.
- Nunca probar con ruedas suspendidas sin asegurar el chasis (evitar golpes).
- Pruebas de movimiento primero a baja velocidad y en un área delimitada.

### 3.3 Baterías (posición estricta)
ARGOS solo usa baterías bajo condiciones seguras.

**Prohibido:**
- baterías infladas, golpeadas o calentándose,
- cargar baterías sin supervisión,
- operar sin fusible/BMS cuando aplique,
- “improvisar” con cintas o cables pelados.

**Obligatorio:**
- revisar temperatura y estado físico antes y después de pruebas,
- desconectar si se detecta olor extraño, humo, calor anormal o chispas.

> Si el equipo no puede garantizar seguridad de energía, ARGOS funciona con fuente estable y pruebas limitadas hasta resolverlo.

### 3.4 Iluminación
- La luz (linterna/LED) se considera parte del sistema de seguridad operativa:
  sin luz estable, la visión falla y aumenta riesgo de colisión en demos.

---

## 4) Seguridad de sensores (posición clara y honesta)
### 4.1 MQ-135 (proxy) — declaración oficial
- El MQ-135 **NO mide oxígeno**.
- Es un indicador cualitativo (proxy) y no es selectivo.
- En ARGOS V1 se usa para:
  - detectar tendencias de “aire degradado”,
  - elevar el estado de riesgo,
  - disparar alertas preventivas,
  - pero **nunca** como certificación de respirabilidad.

**Frase oficial para jueces:**
> “ARGOS V1 usa MQ-135 como proxy cualitativo y no reemplaza sensores certificados de O₂/CO₂.”

### 4.2 Umbrales (cómo se usan)
Los umbrales usados en software se consideran:
- **referencia de ingeniería**,
- útiles para simulación, alertas y pruebas controladas,
- no una autorización real de ingreso.

---

## 5) Seguridad operativa (protocolo)
### 5.1 Dónde se prueba (V1)
- Solo “cueva simulada”: cajas/túneles controlados, baja luz controlada, obstáculos seguros.
- No pruebas en espacios reales peligrosos ni en lugares sin supervisión.

### 5.2 Regla de detención inmediata
La prueba se detiene si ocurre cualquiera:
- calentamiento anormal (batería, driver, cables, Pi),
- olor a quemado, humo o chispa,
- pérdida repetida de control del robot,
- comportamiento errático por cableado suelto,
- caída/impacto del prototipo.

---

## 6) Seguridad del repositorio (código y datos)

### 6.1 Qué NO se publica
- Información privada del equipo/colegio (números, direcciones, datos personales).
- Claves, tokens, credenciales o archivos `.env`.
- Datos sensibles de pruebas que puedan interpretarse como “certificación” si no lo son.

### 6.2 Qué se publica (bien documentado)
- Código y documentación técnica con advertencias claras.
- Evidencias no sensibles (videos/fotos de “cueva simulada”).
- Resultados con contexto (condiciones de prueba, límites y errores).

### 6.3 Manejo de vulnerabilidades
Si alguien encuentra un fallo de software que pueda causar riesgo o abuso:
- se reporta a coaches/mentores y al responsable técnico,
- no se publica en issues públicos,
- se documenta la corrección en el changelog cuando esté resuelto.

---

## 7) Respuesta a incidentes (plan simple)
Si hay un incidente:
1) **Detener** (cortar energía/pausar).
2) **Asegurar** (retirar personas y objetos).
3) **Registrar** (qué pasó, cuándo, foto si aplica).
4) **Revisar** con coach/mentor.
5) **Corregir** antes de volver a probar.

Formato recomendado: `docs/plantillas/Bitacora_Iteraciones.md` + evidencia en logs.

---

## 8) Compromiso público del equipo
CALIBOTS KAIROS sostiene estas tres promesas:

1) **Seguridad primero.**
2) **Evidencia real.**
3) **Cero exageraciones.**

ARGOS se construye como proyecto escolar, sí.  
Pero con disciplina de ingeniería y respeto por el riesgo.