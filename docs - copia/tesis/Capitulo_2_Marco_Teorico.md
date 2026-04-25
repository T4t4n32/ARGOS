# Capítulo 2 — Marco teórico y conceptual

## 2.1 Marco teórico
### 2.1.1 Espacios confinados y atmósferas peligrosas
- 29 CFR 1910.146 define atmósfera deficiente de oxígeno como <19.5% O₂.  
  https://www.law.cornell.edu/cfr/text/29/1910.146
- NIOSH 86-110 enfatiza evaluación previa, monitoreo continuo y rescate planificado.  
  https://www.cdc.gov/niosh/docs/86-110/default.html

### 2.1.2 CO₂ como referencia de ventilación
- OSHA Chemical Data (CO₂) recopila límites ocupacionales (PEL-TWA 5000 ppm).  
  https://www.osha.gov/chemicaldata/183
- NIOSH Pocket Guide (CO₂) incluye referencias REL/IDLH.  
  https://www.cdc.gov/niosh/npg/npgd0103.html

### 2.1.3 Jerarquía de controles y gestión del riesgo
- Jerarquía de controles (NIOSH) como marco de priorización de medidas.  
  https://www.cdc.gov/niosh/hierarchy-of-controls/index.html
- ISO 31000 como marco de proceso (identificar, analizar, evaluar, tratar, monitorear y comunicar riesgos).  
  https://www.iso.org/iso-31000-risk-management.html

## 2.2 Marco conceptual (definiciones operativas)
- Riesgo atmosférico, telemetría crítica, trazabilidad, anomalía (visión), estado de riesgo (verde/amarillo/rojo).
- “Antes–durante–después”: protocolo operativo de ARGOS.

## 2.3 Marco legal y normativo (Colombia + referencia internacional)
- Colombia: Resolución 0491 de 2020 (espacios confinados) — compilación institucional.  
  https://www.icbf.gov.co/cargues/avance/compilacion/docs/resolucion_mtra_0491_2020.htm
- Colombia: Decreto 1072 de 2015 (SG-SST) — compilación normativa.  
  https://normas.cra.gov.co/gestor/docs/decreto_1072_2015.htm
- Internacional: 29 CFR 1910.146 (OSHA) como referencia técnica.  
  https://www.law.cornell.edu/cfr/text/29/1910.146

## 2.4 Antecedentes (tecnología)
### 2.4.1 Sensores (V1)
- BME280 (ambiental). https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf
- MQ-135 (proxy cualitativo). https://www.datasheetq.com/en/preview/MQ-135-HANWEI
- VL53L0X (ToF, hasta 2 m en condiciones apropiadas).  
  https://www.st.com/content/st_com/en/products/imaging-and-photonics-solutions/time-of-flight-sensors/vl53l0x.html

### 2.4.2 Comunicación (LoRa)
- SX1262 (características: alta sensibilidad, +22 dBm, gran link budget).  
  https://www.semtech.com/products/wireless-rf/lora-transceivers/sx1262

### 2.4.3 Visión computacional
- OpenCV (paquete Python). https://pypi.org/project/opencv-python/
- Ultralytics YOLO (documentación). https://docs.ultralytics.com/
