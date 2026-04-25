# Deploy — ARGOS Raspberry Pi 5

Este directorio contiene todo lo necesario para instalar, configurar y ejecutar
ARGOS en una **Raspberry Pi 5 con Pi OS Bookworm** (64-bit).

---

## Instalación rápida

Desde la raíz del repositorio:

```bash
sudo bash deploy/install.sh
sudo reboot          # obligatorio para aplicar GPIO, I2C, SPI y grupos
```

El script realiza los 11 pasos descritos abajo de forma completamente
automática. Después del reboot ARGOS arranca solo al encender la Pi.

---

## ¿Qué instala el script?

| Paso | Qué hace |
|------|----------|
| 1 | `apt-get update && upgrade` |
| 2 | Libs nativas: build-essential, i2c-tools, OpenCV, ffmpeg… |
| 3 | Habilita I2C y SPI via `raspi-config nonint` |
| 4 | Crea entorno virtual Python en `software/.venv` |
| 5 | `pip install -r deploy/requirements_pi.txt` + argos_app |
| 6 | Copia `software/config/argos.example.yaml` → `argos.yaml` si no existe |
| 7 | Descarga **mediamtx** (servidor RTSP) a `~/mediamtx` |
| 8 | Verifica ffmpeg |
| 9 | Crea hotspot **ARGOS-KAIROS** via nmcli (ver sección abajo) |
| 10 | Instala y habilita servicios systemd `argos-hub` y `argos-main` |
| 11 | Verificación final |

---

## Hotspot WiFi — ARGOS-KAIROS

El instalador configura el punto de acceso usando **NetworkManager (nmcli)**,
que es el gestor de red predeterminado en Pi OS Bookworm.  
*No usa hostapd ni dnsmasq*, que son incompatibles con NetworkManager.

| Parámetro | Valor |
|-----------|-------|
| SSID | `ARGOS-KAIROS` |
| Contraseña | `argos2026` |
| IP del robot | `192.168.4.1` |
| Rango DHCP | `192.168.4.x` (asignado automáticamente por NM) |
| Dashboard | `http://argos.local:8888` |

### Cambiar la contraseña del hotspot

```bash
sudo nmcli con mod argos-hotspot wifi-sec.psk "nueva_contraseña"
sudo nmcli con up argos-hotspot
```

### Ver estado del hotspot

```bash
nmcli con show argos-hotspot
nmcli device status
```

### Eliminar y recrear el hotspot

```bash
sudo nmcli con delete argos-hotspot
sudo bash deploy/install.sh   # vuelve a crearlo
```

---

## Servicios systemd

Hay dos servicios independientes:

| Servicio | Descripción | Cuándo usarlo |
|----------|-------------|---------------|
| `argos-hub` | Hub de sensores asyncio | Siempre (sim o hardware) |
| `argos-main` | Control completo del robot | Solo en modo hardware |

### Comandos útiles

```bash
# Estado
sudo systemctl status argos-hub
sudo systemctl status argos-main

# Logs en tiempo real
journalctl -u argos-hub -f
journalctl -u argos-main -f

# Iniciar / detener manualmente
sudo systemctl start  argos-hub
sudo systemctl stop   argos-hub
sudo systemctl restart argos-hub

# Deshabilitar arranque automático
sudo systemctl disable argos-hub
```

### Cambiar de modo simulado a hardware

Edita `/etc/systemd/system/argos-hub.service` y cambia:

```ini
ExecStart=…/argos-hub --mode simulated
```

por:

```ini
ExecStart=…/argos-hub --mode hardware
```

Luego recarga:

```bash
sudo systemctl daemon-reload
sudo systemctl restart argos-hub
```

---

## Archivos en este directorio

```
deploy/
├── install.sh           ← Instalador maestro (ejecutar con sudo)
├── requirements_pi.txt  ← Dependencias Python específicas para Pi
├── argos-hub.service    ← Unidad systemd para el sensor hub
├── argos-main.service   ← Unidad systemd para el control del robot
└── README.md            ← Este archivo
```

> **Nota:** La carpeta `deploy/raspi/` contiene el instalador original de
> referencia y puede ignorarse si usas `deploy/install.sh`.

---

## Solución de problemas

**El hotspot no aparece después del reboot**

```bash
sudo nmcli con up argos-hotspot
```

**GPIO no funciona (lgpio)**

```bash
groups $USER           # debe incluir "gpio"
sudo reboot            # si no está, el reboot del instalador lo aplica
```

**argos-hub falla al iniciar**

```bash
journalctl -u argos-hub -n 50 --no-pager
# Verifica que software/config/argos.yaml exista
```

**Actualizar ARGOS después de un git pull**

```bash
source software/.venv/bin/activate
pip install -e software/
sudo systemctl restart argos-hub argos-main
```
