# Lista de materiales
### Materiales principales

| Componente                            | Cantidad | Función dentro del proyecto                                                                                                                                                  | Observaciones                                                                 |
| ------------------------------------- | -------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **Raspberry Pi 5**                    |        1 | Unidad principal de procesamiento y control del sistema. Se encarga de ejecutar la lógica del proyecto, gestionar periféricos y coordinar los diferentes módulos conectados. | Puede funcionar como cerebro central del prototipo.                           |
| **Linterna / sistema de iluminación** |        1 | Proporciona iluminación auxiliar para mejorar la visibilidad del entorno de trabajo o de captura visual.                                                                     | Útil en condiciones de baja luz.                                              |
| **Batería**                           |        1 | Fuente de alimentación principal del sistema, permitiendo autonomía y portabilidad del prototipo.                                                                            | Se recomienda definir capacidad, voltaje y tipo según el consumo total.       |
| **Sensor de calidad de aire**         |        1 | Permite medir variables relacionadas con el estado del aire, útiles para el monitoreo ambiental.                                                                             | La referencia exacta debe definirse según las variables que se quieran medir. |
| **Sensor de temperatura**             |        1 | Registra la temperatura del entorno o del sistema, aportando datos para supervisión y análisis.                                                                              | Puede complementarse con humedad si el proyecto lo requiere.                  |
| **Módulo LoRa Heltec**                |        1 | Facilita la comunicación inalámbrica de largo alcance para el envío y recepción de datos entre nodos del sistema.                                                            | Adecuado para telemetría y monitoreo remoto.                                  |
| **Cámara web**                        |        1 | Captura imágenes o video para funciones de supervisión, registro visual o procesamiento mediante visión por computadora.                                                     | Preferiblemente compatible por USB con la Raspberry Pi 5.                     |
| **Puentes H**                         |        3 | Permiten controlar el sentido de giro y la velocidad de los motores desde el sistema principal.                                                                              | La referencia debe ajustarse a la corriente y voltaje de los motores.         |
| **Motores**                           |        6 | Generan el movimiento mecánico del prototipo.                                                                                                                                | Es importante definir si serán motores DC, con caja reductora o de otro tipo. |

## Organización por categorías
### 1. Procesamiento y control
- **Raspberry Pi 5**
Este componente actúa como la unidad central del sistema, ya que procesa la información, ejecuta el software principal y coordina la interacción entre sensores, actuadores y módulos de comunicación.
### 2. Alimentación
- **Batería**
La batería suministra la energía necesaria para el funcionamiento del prototipo. Su selección debe considerar el consumo total del sistema, el tiempo de autonomía deseado y la seguridad eléctrica.
### 3. Sensores
- **Sensor de calidad de aire**
- **Sensor de temperatura**
Estos sensores permiten recolectar información del entorno. Su integración resulta clave para tareas de monitoreo, análisis de condiciones ambientales y generación de datos útiles para el proyecto.
### 4. Comunicación
- **LoRa Heltec**
El módulo LoRa posibilita la transmisión de datos a larga distancia con bajo consumo energético, siendo una alternativa adecuada cuando se necesita comunicación remota y estable entre dispositivos.
### 5. Visión e iluminación
- **Cámara web**
- **Linterna / sistema de iluminación**
La cámara web permite obtener información visual del entorno, mientras que la linterna complementa este proceso al mejorar la iluminación en espacios oscuros o de baja visibilidad.
### 6. Movimiento y accionamiento
- **3 puentes H**
- **6 motores**
Los motores proporcionan el desplazamiento o la acción mecánica del prototipo. Los puentes H son indispensables para controlarlos correctamente, ya que permiten invertir el giro y regular su funcionamiento desde el sistema electrónico.
## Observaciones generales

- La presente lista corresponde a una **base inicial de materiales**.
- Algunos componentes aún requieren la definición de su **referencia exacta**, según criterios como consumo, compatibilidad, precisión, potencia o costo.
- Se recomienda complementar esta sección más adelante con:
  - modelo específico,
  - voltaje de operación,
  - consumo estimado,
  - fabricante,
  - costo aproximado,
  - y justificación técnica de selección.