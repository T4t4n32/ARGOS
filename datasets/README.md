# Datasets y Telemetría de ARGOS

Este directorio alberga la estructura, esquemas (metadatos) y muestras de datos generados por la plataforma **ARGOS**. 

ARGOS no es solo un vehículo explorador; es una **plataforma de adquisición de datos ambientales**. El verdadero valor del proyecto radica en la captura sistemática de variables en entornos extremos (como cuevas) para su posterior análisis (Data Monetization / Research).

## Estructura del Directorio

- `metadata/`: Contiene el diccionario de datos (`schema.json`). Define qué significa cada columna recolectada, sus unidades de medida y sus umbrales operativos.
- `samples/`: Contiene archivos CSV de muestra ("gold standard") que representan lecturas ideales o capturas de pruebas. Estos archivos sirven para que los desarrolladores de Frontend (Lovable-UI) y analistas de datos puedan trabajar sin depender del hardware físico.
- `exports/` (Ignorado por Git): Aquí es donde el módulo `DatasetExporter` de Python guardará **automáticamente** los datos reales capturados durante cada sesión en la Raspberry Pi.

## Estándar de Grabación (CSV Time-Series)

El sistema exporta la telemetría en un formato de tabla Plana (CSV) por sesión, con una marca de tiempo estricta.

Columnas estándar:
`timestamp, session_id, temp_c, humidity_perc, pressure_hpa, gas_mq135_adc, distance_mm, risk_level`

*(Para ver la descripción técnica de cada variable, consulta `metadata/schema.json`)*.
