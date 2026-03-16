# ARGOS – Sistema integral de reconocimiento y seguridad en cuevas

Bienvenido al repositorio **ARGOS**, un proyecto de ingeniería enfocado en el **monitoreo ambiental** y la **seguridad** en operaciones de exploración de cuevas.  El sistema integra hardware, firmware embebido y software de alto nivel para obtener datos del entorno subterráneo (calidad del aire, temperatura, distancia) y enviarlos de forma inalámbrica mediante **LoRa** hacia una estación base donde se visualizan y analizan los resultados.  ARGOS surge como iniciativa del grupo **CALIBOTS**, orientada a prototipos educativos y de investigación.

<div align="center">
  <img src="assets/brand/SIN_FONDO.png" alt="Logo de ARGOS" width="200" />
</div>

- **Estado**: en desarrollo
- **Plataforma principal**: Raspberry Pi 5
- **Lenguaje principal**: Python (software) + C/C++ (firmware)
- **Licencia**: MIT

## Tabla de contenidos

1. [Contexto y problema](#contexto-y-problema)
2. [Objetivos](#objetivos)
3. [Arquitectura](#arquitectura)
4. [Estructura del repositorio](#estructura-del-repositorio)
5. [Instalación](#instalación)
6. [Ejecución](#ejecución)
7. [Contribución](#contribución)
8. [Créditos](#créditos)
9. [Licencia](#licencia)

---

## Contexto y problema

La exploración de cuevas presenta riesgos significativos debido a la **falta de iluminación**, la **variación en la calidad del aire** y la **posible presencia de obstáculos o espacios estrechos**.  Los expedicionarios requieren herramientas confiables para evaluar el entorno y tomar decisiones de forma segura.  ARGOS busca proporcionar un **sistema autónomo** que recopile datos ambientales, detecte riesgos y permita transmitir información en tiempo real hacia la superficie.  Así se mejoran los protocolos de seguridad y se reducen los accidentes en actividades de espeleología.

## Objetivos

### Objetivo general

Diseñar, implementar y validar un sistema denominado **ARGOS** capaz de **monitorear parámetros ambientales en cuevas**, procesar la información en una unidad central (Raspberry Pi) y transmitir datos mediante comunicaciones de largo alcance para su visualización y análisis.

### Objetivos específicos

- Desarrollar una arquitectura modular que integre hardware (sensores, actuadores), firmware y software.
- Implementar drivers para sensores de calidad de aire (MQ‑135), temperatura/humedad (BME280) y distancia (VL53L0X).
- Desplegar un esquema de comunicaciones LoRa para telemetría y un módulo de visión basado en cámara USB y algoritmos de detección con OpenCV/YOLO.
- Diseñar una interfaz de consola para la visualización de datos y la configuración del sistema.
- Validar el prototipo en un entorno controlado simulando condiciones de una cueva y medir su desempeño.

## Arquitectura

La arquitectura de ARGOS se basa en tres capas claramente diferenciadas:

```

[ Usuario / Interfaz ]  
| ← consola de monitoreo  
v  
[ Software de aplicación ]  
| ← CLI `argos` y módulos Python  
v  
[ Firmware / Control embebido ]  
| ← microcontroladores con Arduino/PlatformIO  
v  
[ Hardware ] ← sensores (MQ‑135, BME280, VL53L0X), cámara USB, módulos LoRa, motores

```

1. **Hardware** – Incluye la Raspberry Pi 5 como unidad central, sensores de gas, temperatura y distancia, cámara USB, iluminación, módulos LoRa Heltec para comunicación de largo alcance y motores controlados mediante puentes H.  La lista detallada de materiales se encuentra en `hardware/bom.md`.
2. **Firmware** – Programas embebidos para las placas de sensores/actuadores que gestionan la lectura de datos y la comunicación LoRa.  Cada módulo tiene un directorio propio bajo `firmware/` y un README con instrucciones de compilación.
3. **Software** – Aplicación escrita en Python que corre en la Raspberry Pi.  Esta capa inicializa la configuración (`config/argos.yaml`), se comunica con los microcontroladores, procesa la telemetría, gestiona el registro de datos y muestra la información en la consola.  Se distribuye como paquete `argos_app` instalable mediante `pip`.

## Estructura del repositorio

```

ARGOS/  
├── assets/ # Logos, diagramas y otros recursos gráficos  
├── config/  
│ ├── argos.example.yaml # Plantilla de configuración del sistema  
│ └── argos.yaml # Configuración real (gitignored)  
├── deploy/  
│ └── raspi/ # Archivos de despliegue (systemd service)  
├── docs/  
│ ├── architecture/ # Diagramas y descripciones técnicas  
│ ├── identity/ # Manual de identidad visual  
│ ├── references/ # Bibliografía APA/IEEE  
│ ├── safety/ # Protocolos de seguridad y umbrales  
│ ├── templates/ # Plantillas para cronogramas, BOM, pruebas  
│ ├── thesis/ # Documentación de tesis por capítulos  
│ └── readme.md # Guía de la documentación  
├── firmware/  
│ ├── button_tx/ # Firmware para el transmisor de pulsador  
│ └── ... # Otros módulos embebidos  
├── hardware/  
│ └── bom.md # Lista de materiales y enlaces  
├── software/  
│ ├── pyproject.toml # Configuración de empaquetado de `argos_app`  
│ ├── src/argos_app/  
│ │ ├── **init**.py  
│ │ ├── **main**.py # Punto de entrada para `python -m argos_app`  
│ │ ├── cli.py # Definición del comando `argos`  
│ │ ├── runtime.py # Carga de configuración y arranque  
│ │ ├── comms/ # Módulos de comunicación (LoRa, Wi‑Fi)  
│ │ ├── sensors/ # Drivers de BME280, VL53L0X, MQ‑135  
│ │ ├── decision/ # Motor de riesgo y generación de alertas  
│ │ ├── vision/ # Captura con cámara y detección con OpenCV/YOLO  
│ │ └── utils/ # Funciones de apoyo  
│ └── tests/ # Pruebas unitarias  
├── tests/ # Pruebas adicionales del repositorio  
├── .editorconfig  
├── .gitignore  
├── CHANGELOG.md  
├── CODE_OF_CONDUCT.md  
├── CONTRIBUTING.md  
└── README.md
```
### Descripción de carpetas

- **assets/** – Contiene imágenes de diagramas de arquitectura, logotipos y fotos del prototipo.
- **config/** – Plantillas y configuración real del sistema.  No se debe comprometer la configuración real (`argos.yaml`) para proteger información sensible.
- **deploy/** – Scripts y plantillas para desplegar la aplicación como servicio en Raspberry Pi.  El archivo `argos.service.example` muestra cómo configurar systemd.
- **docs/** – Documentación técnica y académica; incluye planos de arquitectura, capítulos de tesis y protocolos de seguridad.
- **firmware/** – Programas embebidos para microcontroladores; cada subcarpeta corresponde a un módulo físico con su propio README.
- **hardware/** – Planos, lista de materiales (`bom.md`) y recomendaciones de montaje.
- **software/** – Código Python que conforma la aplicación ARGOS; empaquetado como módulo instalable.
- **tests/** – Pruebas unitarias que validan el funcionamiento de las diferentes capas.
## Instalación

### Requisitos

- **Hardware:** Raspberry Pi 5 (o compatible) con Raspberry Pi OS Bookworm, fuentes de alimentación adecuadas, sensores y módulos listados en `hardware/bom.md`.
- **Software:** Python ≥ 3.10, `git`, `pip` y, opcionalmente, PlatformIO o Arduino IDE para el firmware.
### Pasos

1. **Clonar el repositorio:**

   ```bash
   git clone https://github.com/T4t4n32/ARGOS.git
   cd ARGOS
	```
2. **Preparar el entorno virtual:**
    
    ```bash
    cd software
    python3 -m venv .venv
    source .venv/bin/activate
    ```
    
3. **Instalar el paquete y dependencias:**
    
    ```bash
    pip install --upgrade pip
    pip install .
    ```
    
    Al instalar la carpeta `software` como paquete se genera automáticamente el comando `argos`.
    
4. **Copiar la configuración de ejemplo:**
    
    ```bash
    cp config/argos.example.yaml config/argos.yaml
    # editar config/argos.yaml según pines, sensores y umbrales
    ```
    
5. **(Opcional) Compilar y cargar firmware:** Consulta cada subcarpeta de `firmware/` para compilar con PlatformIO o Arduino IDE.
    

## Ejecución

Una vez instalado el paquete, puedes iniciar ARGOS en modo simulado o en modo hardware.

### Modo simulado

Para probar la aplicación sin hardware conectado (envía valores de ejemplo y evita inicializar sensores):

```bash
argos --mode simulated --config config/argos.yaml
```

### Modo hardware

Para ejecutar con la Raspberry Pi conectada a los sensores y a los módulos LoRa:

```bash
argos --mode hardware --config config/argos.yaml
```

El sistema mostrará información en consola sobre la versión del proyecto, cargará los módulos de sensores, comunicaciones y visión definidos en `argos_app/runtime.py` y comenzará a emitir datos periódicamente.

### Servicio en Raspberry Pi

Para que la aplicación se ejecute automáticamente al iniciar la Raspberry Pi, copia el archivo de ejemplo a `/etc/systemd/system/` y habilítalo:

```bash
sudo cp deploy/raspi/argos.service.example /etc/systemd/system/argos.service
sudo systemctl daemon-reload
sudo systemctl enable argos
sudo systemctl start argos
```

Asegúrate de ajustar las rutas del servicio a la ubicación real de tu instalación (por ejemplo, `/opt/argos`).

## Contribución

Las aportaciones son bienvenidas. Por favor, sigue estos pasos:

1. **Fork** del repositorio en GitHub.
    
2. Crea una rama para tu mejora o corrección.
    
3. Asegúrate de que tu código siga la estructura del proyecto y añade pruebas unitarias cuando sea posible.
    
4. Envía un **pull request** describiendo con claridad las modificaciones realizadas.
    

Consulta `CONTRIBUTING.md` y `CODE_OF_CONDUCT.md` para detalles adicionales.

## Créditos

Este proyecto es desarrollado por integrantes del grupo **CALIBOTS** como parte de un esfuerzo educativo y de investigación. Agradecemos a todas las personas que colaboran con sugerencias, pruebas y retroalimentación.

## Licencia

ARGOS se distribuye bajo la licencia **MIT**. Consulta el archivo [`LICENSE`](https://chatgpt.com/g/g-p-69a0751234a48191ba25738166318ee9-m-a-n-g-o/c/LICENSE.md) para más detalles.