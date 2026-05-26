# Capítulo 1 — Introducción

## 1.1 Presentación del proyecto
ARGOS V1 es un sistema tecnológico orientado a **operacionalizar la seguridad** en exploración espeleológica (cuevas) mediante un enfoque **antes–durante–después**:
- **Antes:** evaluación inicial de condiciones ambientales y de operación.
- **Durante:** monitoreo continuo, alertas y telemetría.
- **Después:** trazabilidad y reporte de evidencias.

El prototipo V1 integra: **Raspberry Pi 5**, sensores ambientales (temperatura/humedad y proxy de aire), sensor de distancia (ToF) para anti-colisión, **telemetría LoRa 433 MHz** como canal crítico, iluminación propia y un módulo de **visión computacional** para registrar eventos/anomalías.

## 1.2 Planteamiento del problema (versión unificada)
La exploración de cuevas implica condiciones que degradan la seguridad y la eficiencia operativa: **baja visibilidad**, obstáculos inesperados, pérdida de orientación y —especialmente— **riesgo atmosférico**.

Desde seguridad industrial, muchos escenarios se relacionan con *espacios confinados*: ventilación limitada y posibilidad de atmósferas peligrosas. Como referencia normativa, 29 CFR 1910.146 define una atmósfera deficiente de oxígeno como aquella con menos de **19.5% de O₂** por volumen.  
Fuente: https://www.law.cornell.edu/cfr/text/29/1910.146

En términos de impacto, el BLS reportó **1,030** muertes por lesiones ocupacionales vinculadas a espacios confinados (2011–2018), lo que refleja la severidad de estos escenarios.  
Fuente: https://www.bls.gov/iif/factsheets/fatal-occupational-injuries-confined-spaces-2011-19.htm

NIOSH advierte que “más del 60%” de fatalidades en espacios confinados involucran a rescatistas improvisados, reforzando la necesidad de protocolos, monitoreo y comunicación.  
Fuente: https://www.cdc.gov/niosh/docs/86-110/default.html

**Problema central (síntesis):**  
Un explorador puede ingresar a un entorno espeleológico sin información continua y verificable sobre condiciones críticas y sin un canal de comunicación robusto, lo cual incrementa el riesgo operacional y dificulta la toma de decisiones y el rescate.

## 1.3 Pregunta guía
¿Cómo diseñar e implementar un sistema integrado, de bajo costo y escalable, que permita **evaluar y monitorear riesgos**, emitir **alertas oportunas**, mantener **telemetría** en condiciones difíciles y generar **evidencias trazables**?

## 1.4 Objetivos
### 1.4.1 Objetivo general
Diseñar e implementar ARGOS V1 para monitorear condiciones relevantes de seguridad, generar alertas, transmitir telemetría LoRa y registrar evidencia técnica.

### 1.4.2 Objetivos específicos
1) Integrar sensórica ambiental y motor de riesgo (Verde/Amarillo/Rojo).  
2) Integrar ToF para anti-colisión y umbrales de proximidad.  
3) Implementar telemetría LoRa robusta y logging local.  
4) Implementar visión computacional (OpenCV + detector tipo YOLO) con iluminación controlada.  
5) Validar en entorno simulado con métricas: latencia, pérdida de paquetes, autonomía y desempeño de detección.

## 1.5 Justificación
ARGOS V1 aporta prevención, mitigación y trazabilidad. Se alinea con el enfoque de **Jerarquía de Controles**: control de ingeniería/administrativo (monitoreo + alertas + registro) como apoyo a decisiones.  
Fuente: https://www.cdc.gov/niosh/hierarchy-of-controls/index.html

## 1.6 Alcance, limitaciones y estructura del documento
### Alcance (V1)
- Sensado básico (T/H y proxy de aire), ToF, telemetría LoRa, evidencias (logs + capturas) y pruebas en “cueva simulada”.

### Limitaciones (V1)
- El MQ-135 es un **proxy cualitativo** (no mide O₂ y no es selectivo). Ejemplo de ficha pública: https://www.datasheetq.com/en/preview/MQ-135-HANWEI  
- LoRa subterráneo depende del entorno; requiere pruebas locales.  
- Visión en baja luz requiere iluminación propia y dataset del entorno.

### Estructura del documento
Cap. 1 Introducción; Cap. 2 Marco teórico/conceptual; Cap. 3 Metodología; Cap. 4 Resultados; Cap. 5 Conclusiones y recomendaciones.
