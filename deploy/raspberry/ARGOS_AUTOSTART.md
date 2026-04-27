# ARGOS Autostart / Publicación en Raspberry Pi

Este módulo convierte la Raspberry Pi en un nodo que arranca solo al encenderse:

1. Levanta el hotspot local.
2. Inicia el servidor web `nginx`.
3. Inicia la transmisión HLS de la cámara CSI NoIR.
4. Inicia el programa principal de ARGOS.

## Publicar

```bash
cd deploy/raspberry
sudo bash publicar-argos.sh
```

El script deja habilitado `argos-stack.target`, que agrupa los procesos principales de ARGOS.

## Editar el comando principal de ARGOS

```bash
sudo nano /etc/argos/argos.env
```

Cambia esta línea según tu estructura real:

```bash
ARGOS_START_CMD=python3 main.py
```

Después de editar:

```bash
sudo systemctl daemon-reload
sudo systemctl restart argos-app.service
```

## Ver estado

```bash
sudo /opt/mango/raspberry/scripts/argos-status.sh
```

## Ver logs

```bash
sudo journalctl -u argos-app.service -f
sudo journalctl -u argos-camera-hls.service -f
sudo journalctl -u argos-hotspot.service -f
```

## Despublicar

```bash
sudo /opt/mango/raspberry/scripts/despublicar-argos.sh
```
