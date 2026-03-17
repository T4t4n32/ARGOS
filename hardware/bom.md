# Lista de materiales

La siguiente tabla recoge los componentes esenciales de ARGOS. Para cada elemento se indica la cantidad, su función dentro del sistema y observaciones relevantes.

| Componente | Cantidad | Función dentro del proyecto | Observaciones |
|-----------|---------:|-----------------------------|--------------|
| **Raspberry Pi 5** | 1 | Unidad principal de procesamiento y control del sistema. Ejecuta la lógica del proyecto, gestiona periféricos y coordina los diferentes módulos conectados. | Puede funcionar como cerebro central del prototipo. |
| **Linterna / sistema de iluminación** | 1 | Proporciona iluminación auxiliar para mejorar la visibilidad del entorno de trabajo o de captura visual. | Útil en condiciones de baja luz. |
| **Batería** | 1 | Fuente de alimentación principal del sistema, permitiendo autonomía y portabilidad del prototipo. | Se recomienda definir capacidad, voltaje y tipo según el consumo total. |
| **Sensor de calidad de aire** | 1 | Permite medir variables relacionadas con el estado del aire, útiles para el monitoreo ambiental. | La referencia exacta debe definirse según las variables que se quieran medir. |
| **Sensor de temperatura** | 1 | Registra la temperatura del entorno o del sistema, aportando datos para supervisión y análisis. | Puede complementarse con humedad si el proyecto lo requiere. |
| **Módulo LoRa Heltec** | 1 | Facilita la comunicación inalámbrica de largo alcance para el envío y recepción de datos entre nodos del sistema. | Adecuado para telemetría y monitoreo remoto. |
| **Cámara web** | 1 | Captura imágenes o vídeo para funciones de supervisión, registro visual o procesamiento mediante visión por computadora. | Preferiblemente compatible por USB con la Raspberry Pi 5. |
| **Puentes H** | 3 | Permiten controlar el sentido de giro y la velocidad de los motores desde el sistema principal. | La referencia debe ajustarse a la corriente y voltaje de los motores. |
| **Motores** | 6 | Generan el movimiento mecánico del prototipo. | Es importante definir si serán motores DC, con caja reductora u otro tipo. |

## Observaciones generales

- Esta lista corresponde a una **base inicial de materiales**.
- Algunos componentes requieren la definición de su **modelo específico**, voltaje de operación, consumo estimado, fabricante, costo aproximado y justificación técnica de selección.