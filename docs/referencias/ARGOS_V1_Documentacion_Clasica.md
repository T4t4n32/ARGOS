# ARGOS V1 — Documentación clásica del proyecto
**Título:** ARGOS V1: Sistema Integral de Reconocimiento y Seguridad en Entornos Espeleológicos  
**Equipo:** CALIBOTS KAIROS (Colegio Comfandi El Prado, Cali, Colombia)  
**Versión:** V1 (borrador formal)  
**Fecha:** 2026-03-06

---

## Nombre del proyecto
**ARGOS V1: Sistema Integral de Reconocimiento y Seguridad en Entornos Espeleológicos**

---

## Introducción
La exploración de cuevas y entornos subterráneos presenta riesgos asociados a atmósferas peligrosas (por ejemplo, deficiencia de oxígeno), baja visibilidad, obstáculos y pérdida de comunicación. En seguridad ocupacional, estos escenarios se relacionan con *espacios confinados*, donde se exige evaluación previa, monitoreo continuo y planes de rescate.

ARGOS V1 operacionaliza la seguridad en tres momentos: **antes** (evaluación), **durante** (monitoreo y alertas) y **después** (registro y trazabilidad), integrando sensórica ambiental, detección de obstáculos, telemetría LoRa y visión computacional.

---

## Planteamiento del problema
### Problema central
En cuevas, amenazas críticas pueden no ser evidentes. Entrar sin datos expone a:
- Atmósferas peligrosas (p. ej., O₂ deficiente).
- Colisiones/atrapamientos por baja visibilidad.
- Pérdida de comunicación con el exterior.
- Mayor riesgo ante rescates improvisados.

### Evidencia (magnitud del riesgo)
Como referencia industrial, BLS reporta **1,030** muertes por lesiones ocupacionales vinculadas a espacios confinados (2011–2018). NIOSH advierte que una gran proporción de fatalidades involucra rescatistas improvisados, reforzando la necesidad de protocolos y monitoreo.

---

## Objetivos
### Objetivo general
Diseñar e implementar **ARGOS V1**, un sistema integrado basado en Raspberry Pi 5 que **evalúe y monitoree** condiciones de seguridad en entornos subterráneos, genere **alertas operacionales**, transmita telemetría crítica mediante **LoRa 433 MHz** y registre evidencia técnica para análisis posterior.

### Objetivos específicos
1. Integrar sensórica ambiental (temperatura/humedad y calidad de aire como proxy) y definir un motor de riesgo (Verde/Amarillo/Rojo) con umbrales referenciados.
2. Integrar sensor ToF para anti-colisión y alertas por proximidad.
3. Implementar telemetría LoRa robusta (mensajes cortos, repetición, confirmación) y logging local.
4. Implementar visión computacional (OpenCV + detector tipo YOLO) con iluminación controlada.
5. Validar en entorno simulado con métricas: latencia de alertas, estabilidad del enlace y desempeño de detección.

---

## Justificación
ARGOS V1 aporta:
- **Prevención** (datos antes de entrar).
- **Mitigación** (alertas durante operación).
- **Trazabilidad** (logs con timestamp).
- **Accesibilidad** (prototipo educativo escalable).

---

## Marco teórico (síntesis)
- OSHA define atmósfera deficiente de oxígeno como **< 19.5% O₂** y enriquecida como **> 23.5% O₂**.
- Para CO₂, OSHA publica PEL‑TWA 5000 ppm; NIOSH REL‑TWA 5000 ppm y REL‑STEL 30,000 ppm.
- **MQ‑135** es un proxy cualitativo (no mide O₂).  
- **VL53L0X** (ToF) se usa para anti‑colisión (alcance depende de condiciones).  
- LoRa sub‑GHz es adecuado para telemetría; su desempeño en entornos subterráneos depende del medio y requiere pruebas locales.

> Nota: ARGOS V1 no reemplaza instrumentación certificada ni autoriza ingreso real; los umbrales se usan como referencia para diseño y pruebas controladas.

---

## Descripción del proyecto (arquitectura)
### Entrada → Procesamiento → Salida
**Entradas:** BME280, MQ‑135, VL53L0X, cámara, energía.  
**Procesamiento:** Raspberry Pi 5 (filtrado, motor de riesgo, visión, eventos, logs).  
**Salidas:** LoRa (crítica), Wi‑Fi opcional, reporte final (CSV/JSON) + evidencias.

### Flujo antes–durante–después
**Antes:** autodiagnóstico + medición inicial → estado.  
**Durante:** loop de monitoreo + alertas LoRa + evidencias.  
**Después:** reporte y revisión.

---

## Hardware (V1 acordada)
- Raspberry Pi 5  
- Cámara: webcam USB (recomendado V1) o iPhone (soporte en demo)  
- 4 motores (tracción)  
- Sensores: BME280, MQ‑135, VL53L0X  
- LoRa 433 MHz  
- Linterna/LED frontal  

**Complementos recomendados:** driver de motores, ADC (para MQ‑135 si analógico), batería+BMS+fusible, DC‑DC, carcasa/sellado, conectores.

---

## Conclusiones
ARGOS V1 consolida una base para seguridad operativa con sensórica, alertas, telemetría y trazabilidad. V2 debe priorizar sensores dedicados de **CO₂ (NDIR)** y **O₂ electroquímico**, además de mayor robustez mecánica.

---

## Bibliografía
1. OSHA. 29 CFR 1910.146 — Permit-required confined spaces. https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146  
2. NIOSH. Preventing Occupational Fatalities in Confined Spaces (86-110). https://www.cdc.gov/niosh/docs/86-110/default.html  
3. BLS. Fatal occupational injuries involving confined spaces, 2011–2018. https://www.bls.gov/iif/factsheets/fatal-occupational-injuries-confined-spaces-2011-19.htm  
4. OSHA. Carbon Dioxide — Chemical Data. https://www.osha.gov/chemicaldata/183  
5. CDC/NIOSH. Pocket Guide — Carbon dioxide. https://www.cdc.gov/niosh/npg/npgd0103.html  
6. Raspberry Pi. Raspberry Pi 5. https://www.raspberrypi.com/products/raspberry-pi-5/  
7. Raspberry Pi. Introducing Raspberry Pi 5. https://www.raspberrypi.com/news/introducing-raspberry-pi-5/  
8. Bosch Sensortec. BME280 datasheet. https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf  
9. Hanwei. MQ‑135 datasheet. https://www.datasheetq.com/en/preview/MQ-135-HANWEI  
10. ST. VL53L0X product page. https://www.st.com/content/st_com/en/products/imaging-and-photonics-solutions/time-of-flight-sensors/vl53l0x.html  
11. Semtech. SX1262. https://www.semtech.fr/products/wireless-rf/lora-connect/sx1262  
12. Raspberry Pi Docs. Camera software (libcamera/Picamera2). https://www.raspberrypi.com/documentation/computers/camera_software.html  
13. Ultralytics. YOLO Docs. https://docs.ultralytics.com/  
14. PyPI. opencv-python. https://pypi.org/project/opencv-python/

---

## Anexos (plantillas)
**BOM (presupuesto):** tabla de ítems, cantidades y costos.  
**Cronograma:** fases, semanas, responsables, evidencias.  
**Plan de pruebas:** método, criterio de éxito, evidencia.  
**Registro de iteraciones:** fecha, cambio, motivo, resultado, responsable.
