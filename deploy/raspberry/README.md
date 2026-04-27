# Deploy Raspberry Pi 4B + Cámara CSI NoIR + Hotspot + Streaming HLS

Sistema inicial de despliegue para acondicionar una Raspberry Pi 4B/B+ como nodo de cámara local. Instala dependencias, configura carpetas, prepara `nginx`, crea un hotspot con NetworkManager y publica la cámara CSI NoIR por HLS dentro de la red generada por la Raspberry Pi.

## Objetivo

Cuando la Raspberry Pi arranque, debe poder:

1. Levantar un hotspot Wi-Fi propio.
2. Capturar video desde la cámara CSI NoIR usando `rpicam-vid` o `libcamera-vid`.
3. Convertir el video a HLS con `ffmpeg`.
4. Servir la vista en vivo por `nginx`.
5. Permitir actualización del sistema y de scripts con un solo comando.

## Estructura incluida

```text
deploy/raspberry/
├── install.sh                      # Instalación completa inicial
├── update.sh                       # Actualización de paquetes + scripts + servicios
├── raspi.env.example               # Variables editables del nodo
├── README.md
├── nginx/
│   └── mango-camera.conf           # Sitio local para nginx
├── systemd/
│   └── mango-camera-hls.service    # Servicio de streaming HLS
├── scripts/
│   ├── lib/common.sh               # Funciones compartidas
│   ├── setup-hotspot.sh            # Crea/actualiza hotspot
│   ├── hotspot-on.sh               # Activa hotspot
│   ├── hotspot-off.sh              # Apaga hotspot
│   ├── start-camera-hls.sh         # Captura cámara y genera HLS
│   ├── restart-camera.sh           # Reinicia servicio de cámara
│   └── doctor.sh                   # Diagnóstico general
└── www/
    └── index.html                  # Página local del stream
```

## Requisitos recomendados

- Raspberry Pi 4B.
- Raspberry Pi OS Bookworm Lite o Desktop, preferiblemente 64-bit.
- Cámara CSI NoIR conectada al puerto `CAMERA` de la Raspberry Pi 4.
- Fuente de alimentación estable.
- Conexión a internet durante la primera instalación para descargar paquetes.

## Instalación rápida

Desde la raíz del repositorio o desde la carpeta donde tengas estos archivos:

```bash
cd deploy/raspberry
sudo bash install.sh
```

El instalador crea `/etc/mango/raspi.env`. Antes de usarlo en producción, cambia la contraseña del hotspot:

```bash
sudo nano /etc/mango/raspi.env
```

Cambia especialmente:

```bash
HOTSPOT_SSID=MANGO_PI_CAM
HOTSPOT_PASSWORD=ChangeMe_MANGO_2026
```

Luego aplica:

```bash
sudo /opt/mango/raspberry/scripts/setup-hotspot.sh
sudo systemctl restart mango-camera-hls.service
```

## Uso

Conéctate desde tu celular o portátil a la red Wi-Fi creada por la Raspberry Pi:

```text
SSID: MANGO_PI_CAM
URL:  http://10.42.0.1/
```

También puede funcionar por mDNS:

```text
http://mango-pi.local/
```

La playlist HLS directa queda en:

```text
http://10.42.0.1/cam/stream.m3u8
```

## Comandos útiles

Diagnóstico completo:

```bash
sudo /opt/mango/raspberry/scripts/doctor.sh
```

Reiniciar cámara:

```bash
sudo /opt/mango/raspberry/scripts/restart-camera.sh
```

Ver logs del streaming:

```bash
sudo journalctl -u mango-camera-hls.service -f
```

Activar hotspot:

```bash
sudo /opt/mango/raspberry/scripts/hotspot-on.sh
```

Apagar hotspot:

```bash
sudo /opt/mango/raspberry/scripts/hotspot-off.sh
```

Actualizar Raspberry + scripts:

```bash
cd deploy/raspberry
sudo bash update.sh
```

## Ajustes de cámara

Edita:

```bash
sudo nano /etc/mango/raspi.env
```

Parámetros principales:

```bash
CAM_WIDTH=1280
CAM_HEIGHT=720
CAM_FPS=24
CAM_BITRATE=2500000
CAM_TUNING_FILE=auto
```

Para más estabilidad en hotspot, baja a:

```bash
CAM_WIDTH=854
CAM_HEIGHT=480
CAM_FPS=20
CAM_BITRATE=1200000
```

Para mejor calidad, sube con cuidado:

```bash
CAM_WIDTH=1920
CAM_HEIGHT=1080
CAM_FPS=24
CAM_BITRATE=4500000
```

## Nota sobre NoIR

El script intenta usar automáticamente archivos de calibración/tuning NoIR comunes, por ejemplo:

```text
/usr/share/libcamera/ipa/rpi/vc4/imx219_noir.json
/usr/share/libcamera/ipa/rpi/vc4/imx708_noir.json
```

Si tu cámara usa otro sensor, puedes definir manualmente:

```bash
CAM_TUNING_FILE=/ruta/al/tuning.json
```

O desactivarlo:

```bash
CAM_TUNING_FILE=none
```

## Problemas comunes

### 1. No carga la cámara

Ejecuta:

```bash
sudo /opt/mango/raspberry/scripts/doctor.sh
```

Revisa que `rpicam-hello --list-cameras` detecte la cámara. Si no aparece, apaga la Raspberry y revisa el flex CSI.

### 2. El navegador no reproduce el video

Abre la playlist en VLC:

```text
http://10.42.0.1/cam/stream.m3u8
```

Si en Chrome/Edge no carga, revisa que exista:

```bash
ls -lah /var/www/html/assets/hls.min.js
```

Si no existe, conecta la Raspberry a internet y ejecuta de nuevo:

```bash
sudo bash /opt/mango/raspberry/install.sh
```

### 3. El hotspot no aparece

Ejecuta:

```bash
sudo rfkill unblock wifi
sudo nmcli radio wifi on
sudo /opt/mango/raspberry/scripts/setup-hotspot.sh
```

También revisa:

```bash
nmcli device
nmcli connection show
```

## Próxima expansión recomendada

Esta base está lista para crecer hacia:

- Endpoint `/api/health` local.
- Captura de snapshots cada cierto tiempo.
- Grabación local por eventos.
- Integración con sensores ambientales.
- Envío LoRa/MQTT.
- Dashboard local en la Raspberry.
- Sincronización con VPS cuando haya internet.

## Publicación ARGOS: arranque automático al encender

Cuando ya tengas el código principal de ARGOS listo o quieras dejar la Raspberry en modo ejecución, usa:

```bash
cd deploy/raspberry
sudo bash publicar-argos.sh
```

Este comando instala y habilita el arranque automático con `systemd`:

```text
argos-stack.target        Grupo general de arranque
argos-hotspot.service     Hotspot local
argos-camera-hls.service  Cámara CSI NoIR por HLS
argos-app.service         Programa principal de ARGOS
```

Edita el comando real del programa principal en:

```bash
sudo nano /etc/argos/argos.env
```

La línea principal es:

```bash
ARGOS_START_CMD=python3 main.py
```

Ver estado:

```bash
sudo /opt/mango/raspberry/scripts/argos-status.sh
```

Ver logs del programa:

```bash
sudo journalctl -u argos-app.service -f
```
