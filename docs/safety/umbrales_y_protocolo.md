# Umbrales y protocolo de alertas — ARGOS V1

## 1. Principio
ARGOS V1 usa umbrales como **referencias de ingeniería** para alertas y pruebas controladas. No reemplaza equipos certificados.

## 2. Umbral de oxígeno (referencia)
- “Oxygen deficient atmosphere” se define como < **19.5% O₂** por volumen (29 CFR 1910.146).  
  Fuente: https://www.law.cornell.edu/cfr/text/29/1910.146

## 3. CO₂ (referencias de exposición)
- OSHA Chemical Data (CO₂): PEL-TWA 5000 ppm. https://www.osha.gov/chemicaldata/183  
- NIOSH Pocket Guide: incluye REL/IDLH (CO₂). https://www.cdc.gov/niosh/npg/npgd0103.html

> Nota: en V1, si no hay sensor CO₂ NDIR real, estos valores se usan para marco teórico y para planificar V2.

## 4. MQ-135 (proxy) — cómo usarlo sin “sobre-vender”
- No mide O₂.
- Es amplio/no selectivo: útil como “bandera” de aire degradado y tendencia, no como valor exacto.
- Recomendación: usarlo para elevar estado a “amarillo” y pedir verificación.

Ejemplo de datasheet público: https://www.datasheetq.com/en/preview/MQ-135-HANWEI

## 5. Estados (recomendación V1)
- VERDE: sensores OK y lecturas estables.
- AMARILLO: tendencia a degradación / MQ-135 alto / obstáculos frecuentes / pérdida de radio intermitente.
- ROJO: umbral crítico (si existe sensor real) o falla grave de autodiagnóstico / pérdida prolongada de telemetría.

## 6. Evidencia mínima por alerta
Cada evento debe incluir:
- timestamp, tipo de alerta, valor/umbral, estado y acción recomendada.
