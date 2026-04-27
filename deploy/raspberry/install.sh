#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$SCRIPT_DIR/scripts/lib/common.sh"
require_root

mkdir -p /etc/mango
if [[ ! -f /etc/mango/raspi.env ]]; then
  install -m 0640 "$SCRIPT_DIR/raspi.env.example" /etc/mango/raspi.env
  log "Creado /etc/mango/raspi.env desde raspi.env.example"
  warn "Edita HOTSPOT_PASSWORD antes de usarlo en producción: sudo nano /etc/mango/raspi.env"
fi

load_env
validate_hotspot_password

if is_raspberry_pi; then
  log "Hardware Raspberry Pi detectado: $(tr -d '\0' < /proc/device-tree/model)"
else
  warn "No pude confirmar que este equipo sea una Raspberry Pi. El script continuará, pero está pensado para Raspberry Pi OS."
fi

log "Actualizando índice APT e instalando paquetes base..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends   ca-certificates curl git rsync nano bash-completion   network-manager wireless-tools rfkill   nginx ffmpeg avahi-daemon   python3 python3-venv python3-pip

# Camera stack: package names vary across Raspberry Pi OS generations.
if ! command -v rpicam-hello >/dev/null 2>&1 && ! command -v libcamera-hello >/dev/null 2>&1; then
  log "Instalando stack de cámara Raspberry Pi..."
  apt-get install -y --no-install-recommends rpicam-apps ||   apt-get install -y --no-install-recommends libcamera-apps ||   apt-get install -y --no-install-recommends libcamera-apps-lite ||   warn "No se pudo instalar rpicam/libcamera automáticamente. Revisa repositorios de Raspberry Pi OS."
fi
apt-get install -y --no-install-recommends python3-picamera2 || warn "python3-picamera2 no quedó instalado; no es crítico para el streaming HLS."

log "Creando estructura en $INSTALL_DIR ..."
install -d -m 0755 "$INSTALL_DIR" "$DATA_DIR" "$LOG_DIR" "$WEB_ROOT" "$STREAM_DIR"
rsync -a --delete   --exclude 'logs/'   "$SCRIPT_DIR/" "$INSTALL_DIR/"
find "$INSTALL_DIR" -type f -name '*.sh' -exec chmod +x {} \;

log "Configurando hostname opcional..."
if [[ -n "$DEVICE_HOSTNAME" ]] && command -v raspi-config >/dev/null 2>&1; then
  raspi-config nonint do_hostname "$DEVICE_HOSTNAME" || warn "No se pudo cambiar hostname con raspi-config."
fi

log "Asegurando cámara auto-detect en config.txt cuando aplique..."
BOOT_CONFIG="/boot/firmware/config.txt"
[[ -f /boot/config.txt && ! -f "$BOOT_CONFIG" ]] && BOOT_CONFIG="/boot/config.txt"
if [[ -f "$BOOT_CONFIG" ]]; then
  if grep -qE '^camera_auto_detect=' "$BOOT_CONFIG"; then
    sed -i 's/^camera_auto_detect=.*/camera_auto_detect=1/' "$BOOT_CONFIG"
  else
    printf '\n# MANGO/ARGOS camera autodetect\ncamera_auto_detect=1\n' >> "$BOOT_CONFIG"
  fi
else
  warn "No encontré config.txt de arranque. Saltando ajuste camera_auto_detect."
fi

log "Instalando sitio local de cámara..."
install -d -m 0755 "$WEB_ROOT/assets" "$STREAM_DIR"
install -m 0644 "$INSTALL_DIR/www/index.html" "$WEB_ROOT/index.html"
if [[ ! -f "$WEB_ROOT/assets/hls.min.js" ]]; then
  curl -fsSL "$HLS_JS_URL" -o "$WEB_ROOT/assets/hls.min.js" ||     warn "No se pudo descargar hls.js local. Safari/VLC seguirán funcionando; Chrome/Edge pueden requerir internet o hls.js local."
fi

log "Configurando nginx..."
install -m 0644 "$INSTALL_DIR/nginx/mango-camera.conf" /etc/nginx/sites-available/mango-camera.conf
ln -sf /etc/nginx/sites-available/mango-camera.conf /etc/nginx/sites-enabled/mango-camera.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl enable --now nginx

log "Instalando servicios systemd..."
install -m 0644 "$INSTALL_DIR/systemd/mango-camera-hls.service" /etc/systemd/system/mango-camera-hls.service
systemctl daemon-reload
systemctl enable mango-camera-hls.service

log "Configurando NetworkManager y hotspot..."
systemctl enable --now NetworkManager
rfkill unblock wifi || true
if [[ "$HOTSPOT_AUTOSTART" == "yes" ]]; then
  "$INSTALL_DIR/scripts/setup-hotspot.sh" || warn "No se pudo levantar el hotspot automáticamente. Ejecuta doctor.sh para diagnosticar."
fi

log "Iniciando servicio de cámara HLS..."
systemctl restart mango-camera-hls.service || warn "El servicio de cámara no inició. Revisa conexión CSI y ejecuta: sudo $INSTALL_DIR/scripts/doctor.sh"

log "Instalación base completada."
log "URLs esperadas dentro del hotspot: http://10.42.0.1/ y http://${DEVICE_HOSTNAME}.local/"
log "Diagnóstico: sudo $INSTALL_DIR/scripts/doctor.sh"
