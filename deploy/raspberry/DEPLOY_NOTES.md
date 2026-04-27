# Notas técnicas de diseño

## Decisión de streaming

Se eligió HLS servido por `nginx` porque permite abrir la cámara desde un navegador dentro de la red local generada por el hotspot. La ruta directa es:

```text
/cam/stream.m3u8
```

Para menor latencia en pruebas técnicas, se puede añadir más adelante un perfil RTSP/WebRTC con MediaMTX, pero HLS es más simple y estable para una primera base desplegable.

## Decisión de hotspot

Se usa `NetworkManager` con `nmcli`, porque Raspberry Pi OS Bookworm lo usa de forma natural en instalaciones modernas y permite crear un AP sin mantener manualmente archivos de `hostapd` y `dnsmasq`.

## Seguridad mínima

- Cambiar `HOTSPOT_PASSWORD` antes de uso real.
- No exponer este servicio a internet sin autenticación.
- El stream está pensado para red local/hotspot.
- Para producción, añadir autenticación en `nginx` o en una app local.
