#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
load_env

echo "================ RASPBERRY DEPLOY DOCTOR ================"
echo "Fecha: $(date -Is)"
echo "Usuario: $(id)"
echo

echo "[1] Sistema operativo"
cat /etc/os-release 2>/dev/null || true
uname -a
if [[ -r /proc/device-tree/model ]]; then
  echo "Modelo: $(tr -d '\0' < /proc/device-tree/model)"
fi
echo

echo "[2] Comandos de cámara"
if CAM_HELLO="$(camera_hello_bin 2>/dev/null)"; then
  echo "Camera hello: $CAM_HELLO"
  "$CAM_HELLO" --list-cameras || true
else
  echo "No encontré rpicam-hello/libcamera-hello"
fi
if CAM_VID="$(camera_bin 2>/dev/null)"; then
  echo "Camera vid: $CAM_VID"
else
  echo "No encontré rpicam-vid/libcamera-vid"
fi
TUNING="$(select_noir_tuning_file || true)"
[[ -n "$TUNING" ]] && echo "Tuning NoIR seleccionado: $TUNING" || echo "Tuning NoIR: ninguno/auto no encontrado"
echo

echo "[3] Red / hotspot"
if command -v nmcli >/dev/null 2>&1; then
  nmcli device || true
  echo
  nmcli connection show || true
else
  echo "nmcli no instalado"
fi
echo

echo "[4] Servicios"
systemctl --no-pager --full status NetworkManager 2>/dev/null || true
systemctl --no-pager --full status nginx 2>/dev/null || true
systemctl --no-pager --full status mango-camera-hls.service 2>/dev/null || true
echo

echo "[5] Archivos HLS"
ls -lah "$STREAM_DIR" 2>/dev/null || true
echo

echo "[6] URLs esperadas"
echo "Hotspot SSID: $HOTSPOT_SSID"
echo "Web local por IP: http://${HOTSPOT_IP4%/*}/"
echo "Playlist HLS: http://${HOTSPOT_IP4%/*}/cam/stream.m3u8"
echo "mDNS si avahi funciona: http://${DEVICE_HOSTNAME}.local/"
echo "=========================================================="
