# Directorio de Despliegue (Deploy)

Este directorio contiene los scripts y archivos de configuración necesarios para llevar el proyecto ARGOS desde el entorno de desarrollo a un entorno de producción o ejecución continua (especialmente en la **Raspberry Pi 5**).

## 1. Script de Instalación Automatizada (`install_rpi5.sh`)

La forma oficial y recomendada de preparar una Raspberry Pi limpia para ejecutar ARGOS es utilizar el script de instalación maestro.

**Ruta:** `deploy/raspi/install_rpi5.sh`

### ¿Qué hace este script?
Automatiza el 100% del ecosistema de dependencias de hardware y software:
1. **Sistema Operativo:** Actualiza paquetes mediante `apt-get` e instala dependencias nativas (como `build-essential`, `i2c-tools` y librerías gráficas obligatorias para OpenCV).
2. **Hardware:** Habilita las interfaces físicas I2C y SPI de la Raspberry Pi usando `raspi-config nonint`. Además, da permisos al usuario para leer puertos seriales (útil para el LiDAR) y hardware de video.
3. **Backend Python:** Crea el entorno virtual (`.venv`), actualiza `pip`, instala las dependencias de `requirements.txt` e instala la aplicación `argos_app`. También provee una plantilla de configuración `argos.yaml` funcional.
4. **Frontend Lovable-UI:** Detecta, descarga e instala **Bun** (el runtime de alto rendimiento de JavaScript), para compilar e instalar las dependencias de Node.js del dashboard web.

### Cómo ejecutarlo
Desde la raíz del repositorio, ejecuta:
```bash
sudo ./deploy/raspi/install_rpi5.sh
```
*(Se requiere `sudo` ya que el script instala paquetes a nivel de sistema e interactúa con configuraciones del kernel).*

Al finalizar, es **altamente recomendable reiniciar la Raspberry Pi** (`sudo reboot`) para aplicar los cambios de grupos de usuarios e interfaces de hardware.

## 2. Automatización de Arranque (Systemd)

En la carpeta `deploy/raspi/` encontrarás `argos.service.example`. Este fue el servicio de referencia original.

Actualmente, **la mejor forma de configurar ARGOS para que arranque con la Raspberry Pi** es utilizar nuestro script maestro de control en la raíz del proyecto:

```bash
./argos-hub.sh install
```

Ese comando generará automáticamente un servicio `systemd` adaptado a tu ruta y usuario, creando un vigilante que se asegurará de que el robot se encienda y cargue su software y servidores web de forma autónoma con solo conectarlo a la batería.
