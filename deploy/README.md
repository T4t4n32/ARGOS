# MANGO Raspberry Pi Deploy System

Paquete generado para desplegar Raspberry Pi 4B + Cámara CSI NoIR + Hotspot + Streaming HLS.

Entrada principal:

```bash
cd deploy/raspberry
sudo bash install.sh
```

Lee `deploy/raspberry/README.md` antes de producción.

## Publicar ARGOS al arranque

```bash
cd deploy/raspberry
sudo bash publicar-argos.sh
```

Luego ajusta el comando principal en:

```bash
sudo nano /etc/argos/argos.env
```
