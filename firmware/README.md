# Firmware de ARGOS

Este directorio agrupa los programas embebidos necesarios para los
distintos módulos de hardware del sistema ARGOS.  Cada subcarpeta
contiene el código fuente y la documentación específica para un
microcontrolador o componente.

## Subcarpetas

- **button_tx/** – Firmware para un transmisor de botón que envía
  eventos mediante LoRa.  Consulta el `README.md` en esa carpeta para
  instrucciones de compilación y uso.

### Añadir otros módulos

Si integras nuevos sensores o actuadores con microcontroladores, crea
una subcarpeta con el nombre descriptivo y añade un `README.md` que
explique cómo compilar, configurar y cargar el firmware.  Procura
incluir también los archivos de configuración (por ejemplo,
`platformio.ini` para PlatformIO) y notas sobre el pinout del
microcontrolador.