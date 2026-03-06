# ARGOS V1: Sistema Integral de Reconocimiento y Seguridad en Entornos Espeleológicos

**Documento técnico (versión V1)**  
**Equipo:** CALIBOTS KAIROS (Colegio Comfandi El Prado, Cali)  
**Fecha:** 2026-03-04  
**Propósito:** Documento de ingeniería para sustentar ante jueces FLL (rigor + claridad).

---

## 1. RESUMEN EJECUTIVO

### 1.1. Descripción breve del problema
La exploración de cuevas y espacios subterráneos presenta riesgos operacionales críticos: atmósferas peligrosas (deficiencia de oxígeno y acumulación de gases), baja visibilidad, pérdida de comunicación, y posibilidad de atrapamientos. En seguridad industrial, estos escenarios se relacionan con “espacios confinados” y requieren medición previa/continua y protocolos de entrada/rescate. ([osha.gov](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146))

### 1.2. Solución ARGOS en una frase
**ARGOS V1** propone un sistema portátil/robótico basado en **Raspberry Pi 5**, sensores ambientales (O₂/CO₂, temperatura/humedad), detección de obstáculos y **telemetría LoRa 433 MHz**, complementado con **visión computacional** para apoyar decisiones de seguridad “antes, durante y después” de la exploración.

### 1.3. Impacto esperado en la seguridad del explorador
ARGOS busca **reducir la exposición al riesgo** mediante: alertas tempranas (umbrales), registro trazable de evidencias (logs), y un canal de comunicación robusto para monitoreo remoto. La motivación es consistente con hallazgos de NIOSH: una gran proporción de fatalidades en espacios confinados involucra intentos de rescate sin condiciones seguras. ([beta.cdc.gov](https://beta.cdc.gov/niosh/docs/86-110))

---

## 2. PLANTEAMIENTO DEL PROBLEMA Y CONTEXTO

### 2.1. Riesgos en la espeleología
**Riesgos principales (en lenguaje de ingeniería):**
- **Atmósferas peligrosas:** deficiencia de O₂, acumulación de CO₂ u otros contaminantes; esto puede incapacitar y dificultar el auto-rescate. OSHA define “atmósfera deficiente” como <19.5% O₂ (y enriquecida >23.5%). ([osha.gov](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146))
- **Atrapamientos/colapso local:** geometría irregular, pasajes estrechos, suelos resbaladizos.
- **Visibilidad limitada:** iluminación insuficiente y polvo/niebla; reduce navegación segura y capacidad de inspección.
- **Pérdida de comunicación:** el entorno subterráneo atenúa señales, dificultando coordinación y monitoreo.

### 2.2. Estadísticas de accidentes (espacios confinados y rescate)
Aunque “cuevas” no son siempre “sitio laboral”, la evidencia de seguridad en espacios confinados sirve como referencia de riesgo:
- NIOSH reporta que, en un periodo de referencia (CFOI), las fatalidades en espacios confinados **promediaron ~92 por año** en EE. UU. (variando entre 81 y 100 en un periodo de 5 años citado por NIOSH). ([archive.cdc.gov](https://archive.cdc.gov/www_cdc_gov/niosh/topics/confinedspace/default.html))
- BLS reportó **1,030 muertes** por lesiones ocupacionales que involucraron un espacio confinado entre **2011–2018** (con variación anual). ([bls.gov](https://www.bls.gov/iif/factsheets/fatal-occupational-injuries-confined-spaces-2011-19.htm))
- NIOSH advierte que **>60%** de fatalidades en espacios confinados involucran “would-be rescuers” (personas que entran a rescatar sin control de riesgos). ([beta.cdc.gov](https://beta.cdc.gov/niosh/docs/86-110))
- En espeleología, organizaciones de rescate publican reportes anuales de incidentes (ej. British Cave Rescue Council), útiles para análisis cualitativo de tipos de incidentes y factores contribuyentes. ([caverescue.org.uk](https://www.caverescue.org.uk/about-cave-rescue/incident-reports/))

### 2.3. Limitaciones de soluciones actuales
- **Monitores industriales** (multi-gas, intrínsecamente seguros) suelen ser costosos para equipos escolares.
- La mayoría de soluciones se enfocan en **medir** o **comunicar**, pero no integran bien: **(sensado + lógica de riesgo + evidencia + visualización + telemetría)**.
- En entornos subterráneos, la conectividad (Wi-Fi/4G) puede ser inexistente; se requiere un canal alterno y arquitectura tolerante a desconexiones.

---

## 3. INVESTIGACIÓN DEL ESTADO DEL ARTE (State of the Art)

### 3.1. Monitoreo ambiental subterráneo (minería/especialidad)
La literatura de minería subterránea destaca la necesidad de comunicaciones confiables y monitoreo para operaciones y seguridad; se reconoce que el comportamiento de propagación bajo tierra es un factor crítico y que los datos de propagación son relativamente escasos, por lo que se realizan mediciones específicas en túneles/minas. ([mdpi.com](https://www.mdpi.com/1424-8220/22/22/8653))

### 3.2. Uso de LoRa en entornos subterráneos
- En minas subterráneas (túneles), se han realizado **mediciones y modelos** de propagación LoRa (p.ej. 915 MHz) mostrando comportamiento influenciado por geometría del túnel (efecto “guía de onda” en algunos casos). ([mdpi.com](https://www.mdpi.com/1424-8220/22/22/8653))
- Estudios más recientes analizan cobertura/propagación LoRa en minas tipo “room-and-pillar”. ([mdpi.com](https://www.mdpi.com/1424-8220/25/12/3594))
- Para bandas sub-GHz como **433 MHz**, existe evidencia en escenarios “underground-to-aboveground” y “underground-to-underground” (aunque en suelo agrícola, no roca), útil para entender limitaciones y rol de antenas, potencia y tasa de datos. ([mdpi.com](https://www.mdpi.com/1424-8220/19/19/4232))
- En cuevas específicamente, se han estudiado bandas desde LF hasta UHF y se observa que frecuencias más bajas penetran mejor paredes, mientras frecuencias altas funcionan mejor en línea de vista corta con mayor atenuación en geometrías complejas. ([geomatejournal.com](https://geomatejournal.com/geomate/article/view/4394))

**Implicación para ARGOS:** LoRa es viable para telemetría, pero debe diseñarse como **red tolerante a pérdidas** (mensajes cortos, confirmación, repetición, y/o multi-hop opcional).

### 3.3. Visión computacional en baja luminosidad
La detección en baja luz es un problema activo: se proponen variantes tipo YOLO optimizadas para escenas oscuras sin depender de módulos pesados de “enhancement”. ([mdpi.com](https://www.mdpi.com/2076-3417/15/1/90))  
**Implicación para ARGOS:** (1) usar iluminación propia + (2) pipeline robusto (denoise/CLAHE opcional) + (3) modelo liviano entrenado con condiciones reales.

---

## 4. ARQUITECTURA TÉCNICA (Núcleo del proyecto)

### 4.1. Hardware y Electrónica

#### 4.1.1 Núcleo de procesamiento: Raspberry Pi 5
**Justificación técnica:**
- CPU Cortex-A76 @ 2.4 GHz, buena relación rendimiento/consumo para visión + comunicaciones. ([raspberrypi.com](https://www.raspberrypi.com/products/raspberry-pi-5/))
- Recomendación de alimentación: **5V/5A (USB-C PD)**. ([raspberrypi.com](https://www.raspberrypi.com/products/raspberry-pi-5/))
- En cargas pico intensivas, se reportan consumos máximos del orden de ~12W (según comunicación técnica de Raspberry Pi). ([raspberrypi.com](https://www.raspberrypi.com/news/introducing-raspberry-pi-5/))

#### 4.1.2 Sensores ambientales (V1 propuesto)
> **Nota crítica:** el sensor MQ-135 **no mide O₂** y su respuesta es amplia a múltiples gases; en ARGOS se usa como **indicador de “aire degradado”**, no como medición certificada para decisiones de vida o muerte.

- **Temperatura/Humedad/Presión: BME280 (I²C/SPI)**
  - Rango temp aprox. -40 a 85°C, humedad 0–100%RH (no condensación), consumo muy bajo, y tolerancia típica de humedad alrededor de ±3%RH (según datasheet). ([bosch-sensortec.com](https://www.bosch-sensortec.com/products/environmental-sensors/humidity-sensors-bme280/))
- **“Calidad de aire” (proxy): MQ-135**
  - Detecta un rango amplio (NH₃, NOx, alcohol, benceno, humo, CO₂, etc.) con circuito simple, pero **sin selectividad**. (Uso: señal cualitativa/relativa). ([datasheetq.com](https://www.datasheetq.com/en/preview/MQ-135-HANWEI))
- **CO₂ recomendado (para umbrales): Sensirion SCD41 / SCD43 (I²C)**
  - Rango de salida hasta 40,000 ppm y precisión especificada (por rangos) en el datasheet; incluye T/H integradas. ([sensirion.com](https://sensirion.com/media/documents/48C4B7FB/67FE0194/CD_DS_SCD4x_Datasheet_D1.pdf))
  - Alternativa: **SCD30** (CO₂ + T/H, NDIR). ([sensirion.com](https://sensirion.com/media/documents/4EAF6AF8/61652C3C/Sensirion_CO2_Sensors_SCD30_Datasheet.pdf))
- **O₂ recomendado: DFRobot Gravity I²C Oxygen Sensor (0–25%Vol)**
  - Rango 0–25%Vol, resolución reportada 0.15%Vol, tiempo de respuesta ≤15s (datos de especificación). ([wiki.dfrobot.com](https://wiki.dfrobot.com/Gravity_I2C_Oxygen_Sensor_SKU_SEN0322))  
  - Alternativa industrial: Winsen ME2-O2 (celda electroquímica) para integrar con etapa analógica adecuada. ([winsen-sensor.com](https://www.winsen-sensor.com/sensors/o2-sensor/me2-o2.html))

#### 4.1.3 Sensores de distancia / anti-colisión
- **ToF VL53L0X**
  - Sensor ToF con alcance de medición absoluta “hasta ~2 m” (dependiendo de reflectancia/entorno). Útil para anti-colisión y “perfilado” local, no reemplaza un LiDAR 3D. ([st.com](https://www.st.com/content/st_com/en/products/imaging-and-photonics-solutions/time-of-flight-sensors/vl53l0x.html))

#### 4.1.4 Comunicación: LoRa + Wi‑Fi (dual)
- **Canal crítico (telemetría): LoRa 433 MHz**
  - Módulos tipo Ebyte E22 (familia 433/470 MHz) basados en Semtech SX126x/SX1268 según ficha de producto del fabricante. ([ebyte.com](https://www.ebyte.com/product/2806.html))
  - Justificación: sub‑GHz suele comportarse mejor que 2.4 GHz en obstáculos, y hay evidencia de investigación en transmisión subterránea con LoRa 433 MHz (aunque depende fuertemente del medio). ([mdpi.com](https://www.mdpi.com/1424-8220/19/19/4232))
- **Canal opcional (alto ancho de banda): Wi‑Fi**
  - Para setup, debug, descarga de logs, y demo en superficie.

**Marco regulatorio (Colombia, a verificar con ANE/MinTIC):**
- Colombia ha listado el segmento **433.05–434.79 MHz** dentro de bandas ICM (Industrial, Científica y Médica) en normativa compilada (referencia histórica). ([normograma.mintic.gov.co](https://normograma.mintic.gov.co/mintic/compilacion/docs/resolucion_mintic_0473_2010.htm))
- ANE indica que existen segmentos de “uso libre” con **condiciones técnicas y operativas** y que “uso libre” no significa sin restricciones. ([ane.gov.co](https://www.ane.gov.co/Atencion/SitePages/faq.aspx))

#### 4.1.5 Actuación y energía (V1)
- **4 motores (tracción)** + driver (ej. puente H) + control PWM.
- **Linterna/LED** frontal para asegurar iluminación controlada (mejora visión y reduce error).
- **Batería**: LiPo/Li‑ion con BMS y fusible (dimensionar por corriente pico de motores + Pi + radio).

---

### 4.2. Software e Inteligencia Artificial

#### 4.2.1 Sistema operativo
- **Raspberry Pi OS (Debian-based)** recomendado por Raspberry Pi para la mayoría de casos. ([raspberrypi.com](https://www.raspberrypi.com/documentation/raspbian/))

#### 4.2.2 Captura de cámara
- Uso de **libcamera** vía **Picamera2** como API Python recomendada. ([raspberrypi.com](https://www.raspberrypi.com/documentation/computers/camera_software.html))  
- Si se usa iPhone como cámara (opcional), se plantea como fuente remota (stream) solo para demos; el prototipo funcional prioriza cámara directa al Pi.

#### 4.2.3 Visión computacional (detección)
- **OpenCV (Python)** para pipeline de imagen (preprocesado, geometría básica, detección clásica complementaria). ([github.com](https://github.com/opencv/opencv-python))
- **YOLO (Ultralytics)** como base de detección de objetos entrenada para “artefactos” definidos por el equipo. ([docs.ultralytics.com](https://docs.ultralytics.com/))
- Para baja luminosidad, existen propuestas tipo “3L‑YOLO” y otras variantes enfocadas a escenas oscuras (referencia académica). ([mdpi.com](https://www.mdpi.com/2076-3417/15/1/90))

#### 4.2.4 Mapeo / navegación con cámaras (sin RealSense)
**En V1, el objetivo realista es:**
- **(A) Localización relativa + registro de recorrido** (trayectoria) usando Visual SLAM liviano o “visual odometry”, más que un mapa 3D perfecto.
- **(B) Anti‑colisión** con ToF y reglas simples.

Opciones de referencia (para argumentación técnica):
- **ORB‑SLAM3**: biblioteca open-source para SLAM visual/visual‑inercial (paper referenciado). ([emergentmind.com](https://www.emergentmind.com/articles/2007.11898))
- **RTAB‑Map**: SLAM grafos para RGB‑D/estéreo/LiDAR con loop closure y operación en tiempo real (documentación + papers listados por el proyecto). ([introlab.github.io](https://introlab.github.io/rtabmap/))

#### 4.2.5 Lógica de mitigación de riesgos (diagrama de decisiones)
**Concepto:** el sistema no “autoriza entrar”, sino que **clasifica riesgo** y produce alertas.

Ejemplo de estados:
- **VERDE:** O₂ normal + CO₂ bajo + sensores OK
- **AMARILLO:** tendencia a degradación o sensor proxy alto (MQ‑135)
- **ROJO:** umbral crítico (O₂ bajo, CO₂ alto) o pérdida de telemetría prolongada

Diagrama simplificado:
```text
[Start] 
  -> Self-check sensores (I2C/SPI) 
  -> Captura ambiente (O2/CO2/T/H + MQ135 + ToF)
  -> Clasificar riesgo (umbral + tendencia)
     -> (VERDE) log + telemetría normal
     -> (AMARILLO) log + telemetría prioritaria + alerta
     -> (ROJO) log + alerta crítica + recomendación "NO AVANZAR / RETROCEDER"
  -> Loop cada N segundos
```

---

### 4.3. Mecatrónica y Diseño Industrial

#### 4.3.1 Chasis y protección
- Objetivo: resistencia a salpicaduras, polvo, golpes. IP67/IP68 es deseable, pero difícil en prototipos escolares; se puede apuntar a **sellado por compartimentos** (electrónica separada de motores) y empaques.
- Referencia de interpretación de IP (IEC 60529): IP6X (polvo) e IPX7/IPX8 (inmersión). ([iec-equipment.com](https://www.iec-equipment.com/new/IP-Testing-to-IEC-60529-EN-60529-and-BS-EN-60529.html))

#### 4.3.2 Ergonomía y fijación
Tres formatos posibles:
1) **Robot autónomo** (preferido para V1 por seguridad: evita entrada humana directa).  
2) **Mochila/casco** (V2, mayor riesgo/ética/validación).  
3) **Estación fija + sonda** (V1 alternativo).

#### 4.3.3 Gestión térmica y energía
- Pi 5 puede requerir disipación/ventilación en cargas altas (visión). Se recomienda carcasa ventilada o cooler.
- Autonomía se estima con un presupuesto de potencia:
  - Pi (pico ~12W) + LoRa + sensores + motores (dominante). ([raspberrypi.com](https://www.raspberrypi.com/news/introducing-raspberry-pi-5/))  
**La autonomía final debe validarse midiendo corriente real en prototipo.**

---

## 5. PROTOCOLO DE SEGURIDAD Y NORMATIVA

### 5.1. Umbrales críticos (referencias OSHA/NIOSH)
- **Oxígeno (O₂):**
  - Deficiente: **<19.5%** por volumen (OSHA). ([osha.gov](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146))
  - Enriquecida: **>23.5%** por volumen (OSHA). ([osha.gov](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146))
- **CO₂:**
  - Límite ocupacional típico OSHA PEL‑TWA: **5000 ppm**; NIOSH REL‑TWA: **5000 ppm**; NIOSH REL‑STEL: **30,000 ppm** (tabla de límites). ([osha.gov](https://www.osha.gov/chemicaldata/183))
  - NIOSH Pocket Guide incluye recomendaciones de respiradores hasta 40,000 ppm en contexto de protección respiratoria, útil como referencia de severidad. ([cdc.gov](https://www.cdc.gov/niosh/npg/npgd0103.html))

> **Regla de ingeniería para FLL:** ARGOS usa estos umbrales como **referencia técnica**, pero **no reemplaza** instrumentación certificada ni procedimientos profesionales.

### 5.2. Trazabilidad de evidencias (logs)
- Cada medición y decisión debe guardarse con:
  - `timestamp` (hora), `estado_riesgo`, `O2`, `CO2`, `T`, `RH`, `MQ135_raw`, `ToF_mm`, `RSSI/SNR LoRa`, `frame_id` (si aplica).
- “Geolocalización relativa”: coordenadas del SLAM/odometría (x,y,θ) + marcador de eventos (ej. “alerta roja en punto 12”).
- Objetivo: que un juez pueda ver **qué pasó, cuándo y por qué** (auditable).

### 5.3. Cumplimiento normativo (referencias)
- **OSHA 29 CFR 1910.146**: define condiciones de atmósfera peligrosa (incluye O₂ <19.5%) y es el marco clásico de espacios confinados. ([osha.gov](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146))
- **NIOSH Alert 86‑110**: enfatiza monitoreo y que una gran parte de fatalidades ocurre en intentos de rescate. ([beta.cdc.gov](https://beta.cdc.gov/niosh/docs/86-110))
- Estándares de buenas prácticas:
  - **ANSI/ASSP Z117.1**: estándar de seguridad para ingreso/trabajo en espacios confinados (referencia de mejores prácticas). ([assp.org](https://www.assp.org/standards/standards-topics/confined-spaces-z117-1))
  - **NFPA 350**: guía para ingreso/trabajo seguro en espacios confinados (referencia, acceso comercial). ([webstore.ansi.org](https://webstore.ansi.org/standards/nfpa/nfpa3502022))

---

## 6. VIABILIDAD Y DESARROLLO

### 6.1. Presupuesto estimado (BOM) — *rango y prioridad*
> Los costos cambian por país/tienda. Esta BOM se plantea por “prioridad de compra”.

**Prioridad A (core demo + seguridad básica):**
- Raspberry Pi 5 + fuente 5V/5A ([raspberrypi.com](https://www.raspberrypi.com/products/raspberry-pi-5/))
- Cámara (USB) + iluminación LED
- BME280 ([bosch-sensortec.com](https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf))
- Sensor O₂ (DFRobot I²C) ([wiki.dfrobot.com](https://wiki.dfrobot.com/Gravity_I2C_Oxygen_Sensor_SKU_SEN0322))
- Módulo CO₂ (SCD41/SCD30) ([sensirion.com](https://sensirion.com/media/documents/48C4B7FB/67FE0194/CD_DS_SCD4x_Datasheet_D1.pdf))
- LoRa 433 (E22/SX126x) ([ebyte.com](https://www.ebyte.com/product/2806.html))

**Prioridad B (robótica + navegación):**
- 4 motores + driver + ruedas/chasis
- VL53L0X ToF ([st.com](https://www.st.com/content/st_com/en/products/imaging-and-photonics-solutions/time-of-flight-sensors/vl53l0x.html))
- Batería + BMS + fusible + reguladores

### 6.2. Cronograma de desarrollo (fases)
- **Fase 0 (1 semana):** definición final de “objetos a reconocer” + dataset + rúbrica de seguridad (umbrales y estados).
- **Fase 1 (1–2 semanas):** sensado + telemetría LoRa + logs + dashboard mínimo.
- **Fase 2 (2–3 semanas):** visión computacional (detección) en condiciones de baja luz con iluminación propia.
- **Fase 3 (2 semanas):** movilidad + anti‑colisión + pruebas en entorno simulado (pasillos oscuros/maqueta).
- **Fase 4 (iteración):** robustez, empaquetado, narrativa para jueces, evidencias.

### 6.3. Desafíos técnicos y soluciones propuestas
- **Baja luz:** iluminación integrada + entrenamiento con escenas reales; considerar modelos livianos. ([mdpi.com](https://www.mdpi.com/2076-3417/15/1/90))
- **Propagación subterránea:** mensajes cortos, repetición, watchdog de enlace; multi-hop opcional. ([mdpi.com](https://www.mdpi.com/1424-8220/22/22/8653))
- **Sensores “no industriales”:** declarar límites y validar con calibración simple; no basar decisiones críticas en MQ‑135. ([datasheetq.com](https://www.datasheetq.com/en/preview/MQ-135-HANWEI))

---

## 7. IMPACTO Y COMPARTICIÓN (Requisito FLL)

### 7.1. Beneficiarios directos e indirectos
- Directos: equipos de exploración, grupos académicos, rescate (como herramienta de apoyo).
- Indirectos: instituciones educativas, divulgación científica, cultura de prevención.

### 7.2. Plan para compartir la solución
- **Open Source parcial:** código de telemetría/logs y guía de construcción (sin exponer detalles peligrosos de operación).
- **Colaboración:** contacto con grupos de rescate/espeleología para entrevistas y validación conceptual.
- **Material educativo:** video corto “cómo leer niveles de CO₂/O₂ y por qué importa”, con evidencia de sensores y logs.

---

## 8. BIBLIOGRAFÍA Y REFERENCIAS (enlaces reales)

> Nota: por formato de esta plataforma, dejo los enlaces en una lista “copiable”. También están citados en el texto.

OSHA 29 CFR 1910.146 Permit-required confined spaces:
https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146

NIOSH Alert 86-110 Preventing Occupational Fatalities in Confined Spaces:
https://beta.cdc.gov/niosh/docs/86-110

NIOSH Confined Spaces topic (estadísticas CFOI promedio anual):
https://archive.cdc.gov/www_cdc_gov/niosh/topics/confinedspace/default.html

BLS Fact Sheet (Fatal occupational injuries involving confined spaces, 2011–2018):
https://www.bls.gov/iif/factsheets/fatal-occupational-injuries-confined-spaces-2011-19.htm

OSHA Chemical Data – Carbon Dioxide (PEL/REL/STEL):
https://www.osha.gov/chemicaldata/183

NIOSH Pocket Guide – Carbon dioxide:
https://www.cdc.gov/niosh/npg/npgd0103.html

Raspberry Pi 5 product page (specs, power):
https://www.raspberrypi.com/products/raspberry-pi-5/

Raspberry Pi blog (Pi 5 peak power ~12W, explicación PSU):
https://www.raspberrypi.com/news/introducing-raspberry-pi-5/

Raspberry Pi OS documentation:
https://www.raspberrypi.com/documentation/raspbian/

Raspberry Pi camera software (Picamera2):
https://www.raspberrypi.com/documentation/computers/camera_software.html

Picamera2 GitHub:
https://github.com/raspberrypi/picamera2

OpenCV Python packaging (opencv-python):
https://github.com/opencv/opencv-python

Ultralytics YOLO Docs:
https://docs.ultralytics.com/

RTAB-Map (SLAM) home:
https://introlab.github.io/rtabmap/
RTAB-Map GitHub:
https://github.com/introlab/rtabmap

ORB-SLAM3 (referencia del paper 2007.11898):
https://www.emergentmind.com/articles/2007.11898

LoRa propagation in underground gold mine (Sensors, 2022):
https://www.mdpi.com/1424-8220/22/22/8653

LoRa propagation in underground potash mines (Sensors, 2025):
https://www.mdpi.com/1424-8220/25/12/3594

Underground wireless data transmission using 433-MHz LoRa (Sensors, 2019):
https://www.mdpi.com/1424-8220/19/19/4232

Radio wave propagation in cave (GEOMATE Journal, 2024):
https://geomatejournal.com/geomate/article/view/4394

Low-light object detection (3L-YOLO, Appl. Sci. 2025):
https://www.mdpi.com/2076-3417/15/1/90

Bosch BME280 datasheet:
https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf

Sensirion SCD4x datasheet (SCD40/SCD41/SCD43):
https://sensirion.com/media/documents/48C4B7FB/67FE0194/CD_DS_SCD4x_Datasheet_D1.pdf

Sensirion SCD30 datasheet:
https://sensirion.com/media/documents/4EAF6AF8/61652C3C/Sensirion_CO2_Sensors_SCD30_Datasheet.pdf

ST VL53L0X product page:
https://www.st.com/content/st_com/en/products/imaging-and-photonics-solutions/time-of-flight-sensors/vl53l0x.html

DFRobot O2 sensor wiki (SEN0322):
https://wiki.dfrobot.com/Gravity_I2C_Oxygen_Sensor_SKU_SEN0322

Semtech SX1262 (LoRa transceiver):
https://www.semtech.com/products/wireless-rf/lora-transceivers/sx1262

LoRaRF Python library (SX126x/SX127x):
https://pypi.org/project/lorarf/

BCRC incident reports (cave rescue):
https://www.caverescue.org.uk/about-cave-rescue/incident-reports/

Colombia: Resolución MinTIC 473 de 2010 (banda 433.05–434.79 MHz listada como ICM):
https://normograma.mintic.gov.co/mintic/compilacion/docs/resolucion_mintic_0473_2010.htm

ANE FAQ (uso libre con condiciones técnicas):
https://www.ane.gov.co/Atencion/SitePages/faq.aspx

ANSI/ASSP Z117.1 overview:
https://www.assp.org/standards/standards-topics/confined-spaces-z117-1

NFPA 350 (referencia del estándar):
https://webstore.ansi.org/standards/nfpa/nfpa3502022

---

## Advertencia (para el equipo)
1) **No usar** MQ‑135 para “decidir si se puede entrar” (no es sensor selectivo ni certificado). ([datasheetq.com](https://www.datasheetq.com/en/preview/MQ-135-HANWEI))  
2) Todo umbral (O₂/CO₂) debe validarse con **calibración** y pruebas en ambiente controlado; los valores aquí son referencias OSHA/NIOSH para justificar ingeniería, no una autorización de operación real. ([osha.gov](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.146))  
3) Las condiciones de radio en cuevas varían; **probar** LoRa en escenarios reales y registrar RSSI/SNR para evidenciar limitaciones. ([mdpi.com](https://www.mdpi.com/1424-8220/22/22/8653))  
4) Para cualquier demostración física, priorizar simulación/maquetas y protocolos de seguridad supervisados por adultos responsables.
