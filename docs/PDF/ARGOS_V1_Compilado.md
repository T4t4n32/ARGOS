# ARGOS V1 — Documentación clásica del proyecto
**Título:** ARGOS V1: Sistema Integral de Reconocimiento y Seguridad en Entornos Espeleológicos  
**Equipo:** CALIBOTS KAIROS (Colegio Comfandi El Prado, Cali, Colombia)  
**Versión:** V1 (borrador formal)  
**Fecha:** 2026-03-06

---

## Nombre del proyecto
**ARGOS V1: Sistema Integral de Reconocimiento y Seguridad en Entornos Espeleológicos**

## Introducción
La exploración de cuevas y entornos subterráneos presenta riesgos asociados a atmósferas peligrosas (por ejemplo, deficiencia de oxígeno), baja visibilidad, obstáculos y pérdida de comunicación. En seguridad ocupacional, estos escenarios se relacionan con *espacios confinados*, donde se exige evaluación previa, monitoreo continuo y planes de rescate.

ARGOS V1 operacionaliza la seguridad en tres momentos: **antes** (evaluación), **durante** (monitoreo y alertas) y **después** (registro y trazabilidad), integrando sensórica ambiental, detección de obstáculos, telemetría LoRa y visión computacional.

## Planteamiento del problema
### Problema central
En cuevas, amenazas críticas pueden no ser evidentes. Entrar sin datos expone a: atmósferas peligrosas, colisiones/atrapamientos por baja visibilidad, pérdida de comunicación y mayor riesgo ante rescates improvisados.

### Evidencia (magnitud del riesgo)
Como referencia industrial, BLS reporta **1,030** muertes por lesiones ocupacionales vinculadas a espacios confinados (2011–2018). NIOSH advierte que una gran proporción de fatalidades involucra rescatistas improvisados.

## Objetivos
### Objetivo general
Diseñar e implementar **ARGOS V1**, un sistema integrado basado en Raspberry Pi 5 que evalúe condiciones de seguridad, genere alertas, transmita telemetría crítica por **LoRa 433 MHz** y registre evidencia.

### Objetivos específicos
1) Sensórica ambiental + motor de riesgo (Verde/Amarillo/Rojo).  
2) ToF para anti‑colisión.  
3) Telemetría LoRa robusta + logging local.  
4) Visión computacional con iluminación controlada.  
5) Validación en “cueva simulada” con métricas.

## Hardware (V1 acordada)
- Raspberry Pi 5
- Cámara: webcam USB (V1) o iPhone (demo)
- 4 motores
- BME280, MQ‑135, VL53L0X
- LoRa 433 MHz
- Linterna/LED

## Bibliografía (selección)
- OSHA 29 CFR 1910.146: https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146
- NIOSH 86-110: https://www.cdc.gov/niosh/docs/86-110/default.html
- BLS confined spaces: https://www.bls.gov/iif/factsheets/fatal-occupational-injuries-confined-spaces-2011-19.htm

---

# ARGOS V1 — Informe técnico estilo IEEE (texto)

> Plantillas IEEE (Word/LaTeX):
> https://conferences.ieeeauthorcenter.ieee.org/write-your-paper/authoring-tools-and-templates/

## Título
**ARGOS V1: Sistema Integral de Reconocimiento y Seguridad en Entornos Espeleológicos**

### Resumen—
La exploración de cuevas presenta riesgos asociados a atmósferas peligrosas, baja visibilidad, obstáculos y pérdida de comunicación. Este documento describe ARGOS V1, un sistema integrado basado en Raspberry Pi 5 que combina sensórica ambiental (temperatura/humedad y calidad de aire como proxy), detección de obstáculos con sensor ToF, visión computacional y telemetría LoRa sub‑GHz. ARGOS operacionaliza la seguridad mediante un protocolo antes–durante–después: evaluación pre‑entrada, monitoreo continuo, alertas y trazabilidad mediante registros con timestamp.

**Palabras clave—** seguridad industrial; espacios confinados; espeleología; LoRa; Raspberry Pi; visión computacional; sensores ambientales.

## I. Introducción
OSHA define una atmósfera deficiente de oxígeno como aquella con menos de 19.5% de O₂ por volumen [1]. NIOSH resalta que una proporción importante de muertes en espacios confinados involucra rescates improvisados [2]. ARGOS V1 integra sensado, decisión, comunicación y evidencia para reducir exposición al riesgo y mejorar trazabilidad.

## II. Contexto y motivación
BLS reportó 1,030 muertes por lesiones ocupacionales que involucraron espacios confinados entre 2011 y 2018 [3]. Aunque la espeleología no siempre es laboral, las lecciones de seguridad industrial son transferibles.

## III. Estado del arte
OSHA/NIOSH documentan límites de referencia para CO₂ (TWA 5000 ppm, STEL 30,000 ppm) [4], [5]. La propagación de radio subterránea depende del entorno; LoRa sub‑GHz es adecuada para telemetría robusta [11]. En visión, se recomienda iluminación propia y entrenamiento con datos reales; en Raspberry Pi se integra libcamera/Picamera2 [12] y se procesa con OpenCV [14] y YOLO [13].

## IV. Arquitectura del sistema
ARGOS V1 se implementa con Raspberry Pi 5 (5V/5A USB‑C PD) [6] y consideraciones de potencia pico (~12W) [7]. Sensores: BME280 [8], MQ‑135 proxy [9], VL53L0X ToF [10]. Telemetría: LoRa 433 MHz [11]. Software: Raspberry Pi OS; captura y detección; logs con timestamp.

## V. Protocolo operativo
Antes: medición inicial y estado (Verde/Amarillo/Rojo). Durante: monitoreo, alertas y evidencias. Después: reporte final.

## VI. Plan de validación
Latencia de alerta, estabilidad del enlace, desempeño de detección, robustez.

## VII. Discusión y limitaciones
MQ‑135 no mide O₂ y es cualitativo [9]. LoRa requiere pruebas locales. Visión depende de iluminación y dataset.

## VIII. Conclusión y trabajo futuro
ARGOS V1 integra medición, comunicación y trazabilidad. En V2 se recomienda CO₂ NDIR y O₂ electroquímico, mayor protección mecánica y validación comparativa.

## Referencias
[1] https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146
[2] https://www.cdc.gov/niosh/docs/86-110/default.html
[3] https://www.bls.gov/iif/factsheets/fatal-occupational-injuries-confined-spaces-2011-19.htm
[4] https://www.osha.gov/chemicaldata/183
[5] https://www.cdc.gov/niosh/npg/npgd0103.html
[6] https://www.raspberrypi.com/products/raspberry-pi-5/
[7] https://www.raspberrypi.com/news/introducing-raspberry-pi-5/
[8] https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf
[9] https://www.datasheetq.com/en/preview/MQ-135-HANWEI
[10] https://www.st.com/content/st_com/en/products/imaging-and-photonics-solutions/time-of-flight-sensors/vl53l0x.html
[11] https://www.semtech.fr/products/wireless-rf/lora-connect/sx1262
[12] https://www.raspberrypi.com/documentation/computers/camera_software.html
[13] https://docs.ultralytics.com/
[14] https://pypi.org/project/opencv-python/
