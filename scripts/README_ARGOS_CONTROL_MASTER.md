# Scripts de control maestro para ARGOS en Raspberry Pi 4B

Este paquete agrega un módulo seguro para otorgar permisos de control de hardware y operación del stack ARGOS.

## Archivos

```text
scripts/
├── argos-control-master.sh
├── argos-control-check.sh
└── argos-control-revoke.sh
```

## Qué activa el script maestro

- Grupos de hardware: `gpio`, `i2c`, `spi`, `video`, `dialout`, `input`, `render`, `plugdev`, `netdev`.
- Grupo principal del proyecto: `argos`.
- Carpetas de ejecución:
  - `/opt/argos/app`
  - `/opt/argos/data`
  - `/opt/argos/runtime`
  - `/opt/argos/config`
  - `/etc/argos`
  - `/var/log/argos`
  - `/var/lib/argos`
- Reglas `udev` para I2C, SPI, GPIO, cámara/video y serial USB.
- Activación persistente en `config.txt`:
  - `dtparam=i2c_arm=on`
  - `dtparam=spi=on`
  - opcional: `enable_uart=1`
  - opcional: `dtoverlay=w1-gpio`
- `sudoers` limitado para controlar servicios ARGOS, sin entregar root completo.

## Instalación recomendada

Copia la carpeta `scripts/` dentro de:

```bash
deploy/raspberry/scripts/
```

Luego ejecuta:

```bash
cd deploy/raspberry/scripts
sudo bash argos-control-master.sh
```

Si tu usuario no es `pi`, usa:

```bash
sudo ARGOS_USER=$USER bash argos-control-master.sh
```

## Para activar UART o 1-Wire

```bash
sudo ARGOS_USER=$USER ARGOS_ENABLE_UART=1 bash argos-control-master.sh
sudo ARGOS_USER=$USER ARGOS_ENABLE_1WIRE=1 bash argos-control-master.sh
```

## Verificación

```bash
sudo /opt/mango/raspberry/scripts/argos-control-check.sh
```

## Revocación conservadora

```bash
sudo /opt/mango/raspberry/scripts/argos-control-revoke.sh
```

Para quitar también grupos del usuario:

```bash
sudo /opt/mango/raspberry/scripts/argos-control-revoke.sh --remove-user-groups
```

## Nota de seguridad

Este paquete evita usar permisos globales como `chmod 777`. El acceso se controla por grupos Linux, reglas `udev` y comandos `sudo` limitados a servicios/scripts de ARGOS.
