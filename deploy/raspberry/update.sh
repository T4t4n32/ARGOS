#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$SCRIPT_DIR/scripts/lib/common.sh"
require_root
load_env

log "Actualizando paquetes del sistema..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

if [[ -d "$SCRIPT_DIR/.git" ]]; then
  log "Repositorio Git detectado; intentando git pull --ff-only..."
  git -C "$SCRIPT_DIR" pull --ff-only || warn "No se pudo hacer git pull. Puede haber cambios locales o no estar en un repo remoto."
fi

log "Reinstalando/actualizando archivos de despliegue en $INSTALL_DIR ..."
install -d -m 0755 "$INSTALL_DIR" "$DATA_DIR" "$LOG_DIR" "$WEB_ROOT" "$STREAM_DIR"
rsync -a --delete --exclude 'logs/' "$SCRIPT_DIR/" "$INSTALL_DIR/"
find "$INSTALL_DIR" -type f -name '*.sh' -exec chmod +x {} \;

log "Actualizando nginx y systemd..."
install -m 0644 "$INSTALL_DIR/nginx/mango-camera.conf" /etc/nginx/sites-available/mango-camera.conf
ln -sf /etc/nginx/sites-available/mango-camera.conf /etc/nginx/sites-enabled/mango-camera.conf
install -m 0644 "$INSTALL_DIR/systemd/mango-camera-hls.service" /etc/systemd/system/mango-camera-hls.service
nginx -t
systemctl daemon-reload
systemctl restart nginx
systemctl restart mango-camera-hls.service || warn "No se pudo reiniciar mango-camera-hls.service. Ejecuta doctor.sh."

log "Actualización completada."
