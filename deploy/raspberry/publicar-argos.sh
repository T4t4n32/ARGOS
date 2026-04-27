#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/common.sh
source "$SCRIPT_DIR/scripts/lib/common.sh"
require_root

ARGOS_ENV_FILE="${ARGOS_ENV_FILE:-/etc/argos/argos.env}"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

log "Publicando ARGOS para arranque automático en Raspberry Pi..."

if [[ ! -d /opt/mango/raspberry || ! -x /opt/mango/raspberry/scripts/start-camera-hls.sh ]]; then
  warn "No encontré la instalación base en /opt/mango/raspberry. Ejecutando install.sh primero."
  bash "$SCRIPT_DIR/install.sh"
else
  log "Instalación base detectada: /opt/mango/raspberry"
fi

install -d -m 0755 /opt/mango/raspberry
rsync -a --delete --exclude 'logs/' "$SCRIPT_DIR/" /opt/mango/raspberry/
find /opt/mango/raspberry -type f -name '*.sh' -exec chmod +x {} \;

install -d -m 0755 /etc/argos
if [[ ! -f "$ARGOS_ENV_FILE" ]]; then
  install -m 0640 "$SCRIPT_DIR/argos.env.example" "$ARGOS_ENV_FILE"
  log "Creado $ARGOS_ENV_FILE desde argos.env.example"
  warn "Revisa ARGOS_START_CMD antes de producción: sudo nano $ARGOS_ENV_FILE"
fi

# shellcheck disable=SC1090
source "$ARGOS_ENV_FILE"
ARGOS_BASE_DIR="${ARGOS_BASE_DIR:-/opt/argos}"
ARGOS_APP_DIR="${ARGOS_APP_DIR:-/opt/argos/app}"
ARGOS_VENV_DIR="${ARGOS_VENV_DIR:-/opt/argos/venv}"
ARGOS_LOG_DIR="${ARGOS_LOG_DIR:-/var/log/argos}"
ARGOS_RUN_DIR="${ARGOS_RUN_DIR:-/run/argos}"
ARGOS_SYNC_APP="${ARGOS_SYNC_APP:-yes}"
ARGOS_INSTALL_PYTHON_DEPS="${ARGOS_INSTALL_PYTHON_DEPS:-yes}"
ARGOS_REQUIREMENTS_FILE="${ARGOS_REQUIREMENTS_FILE:-requirements.txt}"
ARGOS_ENABLE_HOTSPOT="${ARGOS_ENABLE_HOTSPOT:-yes}"
ARGOS_ENABLE_CAMERA="${ARGOS_ENABLE_CAMERA:-yes}"
ARGOS_ENABLE_APP="${ARGOS_ENABLE_APP:-yes}"
ARGOS_RSYNC_EXCLUDES="${ARGOS_RSYNC_EXCLUDES:-.git .venv venv __pycache__ node_modules dist build logs *.pyc}"

install -d -m 0755 "$ARGOS_BASE_DIR" "$ARGOS_APP_DIR" "$ARGOS_LOG_DIR" "$ARGOS_RUN_DIR" "$ARGOS_BASE_DIR/runtime"
install -m 0755 "$SCRIPT_DIR/runtime/argos-runner.sh" "$ARGOS_BASE_DIR/runtime/argos-runner.sh"

if [[ "$ARGOS_SYNC_APP" == "yes" ]]; then
  log "Sincronizando código del proyecto hacia $ARGOS_APP_DIR ..."
  RSYNC_ARGS=(rsync -a --delete)
  for pattern in $ARGOS_RSYNC_EXCLUDES; do
    RSYNC_ARGS+=(--exclude "$pattern")
  done
  RSYNC_ARGS+=("$PROJECT_ROOT/" "$ARGOS_APP_DIR/")
  "${RSYNC_ARGS[@]}"
else
  warn "ARGOS_SYNC_APP=no; no se copiará código a $ARGOS_APP_DIR"
fi

if [[ "$ARGOS_INSTALL_PYTHON_DEPS" == "yes" && -f "$ARGOS_APP_DIR/$ARGOS_REQUIREMENTS_FILE" ]]; then
  log "Instalando dependencias Python en $ARGOS_VENV_DIR desde $ARGOS_REQUIREMENTS_FILE ..."
  python3 -m venv "$ARGOS_VENV_DIR"
  "$ARGOS_VENV_DIR/bin/python" -m pip install --upgrade pip wheel
  "$ARGOS_VENV_DIR/bin/pip" install -r "$ARGOS_APP_DIR/$ARGOS_REQUIREMENTS_FILE"
else
  warn "No se instalaron dependencias Python: no existe $ARGOS_APP_DIR/$ARGOS_REQUIREMENTS_FILE o ARGOS_INSTALL_PYTHON_DEPS=no."
fi

log "Instalando unidades systemd ARGOS..."
install -m 0644 "$SCRIPT_DIR/systemd/argos-hotspot.service" /etc/systemd/system/argos-hotspot.service
install -m 0644 "$SCRIPT_DIR/systemd/argos-camera-hls.service" /etc/systemd/system/argos-camera-hls.service
install -m 0644 "$SCRIPT_DIR/systemd/argos-app.service" /etc/systemd/system/argos-app.service
install -m 0644 "$SCRIPT_DIR/systemd/argos-stack.target" /etc/systemd/system/argos-stack.target
systemctl daemon-reload

if systemctl list-unit-files | grep -q '^mango-camera-hls.service'; then
  systemctl disable --now mango-camera-hls.service >/dev/null 2>&1 || true
fi

systemctl disable argos-hotspot.service argos-camera-hls.service argos-app.service >/dev/null 2>&1 || true
WANTS_DIR="/etc/systemd/system/argos-stack.target.wants"
install -d -m 0755 "$WANTS_DIR"
rm -f "$WANTS_DIR/argos-hotspot.service" "$WANTS_DIR/argos-camera-hls.service" "$WANTS_DIR/argos-app.service"

if [[ "$ARGOS_ENABLE_HOTSPOT" == "yes" ]]; then
  ln -sf /etc/systemd/system/argos-hotspot.service "$WANTS_DIR/argos-hotspot.service"
fi
if [[ "$ARGOS_ENABLE_CAMERA" == "yes" ]]; then
  ln -sf /etc/systemd/system/argos-camera-hls.service "$WANTS_DIR/argos-camera-hls.service"
fi
if [[ "$ARGOS_ENABLE_APP" == "yes" ]]; then
  ln -sf /etc/systemd/system/argos-app.service "$WANTS_DIR/argos-app.service"
fi

systemctl enable argos-stack.target

log "Iniciando ARGOS ahora..."
systemctl restart argos-stack.target || true
if [[ "$ARGOS_ENABLE_HOTSPOT" == "yes" ]]; then
  systemctl restart argos-hotspot.service || warn "argos-hotspot.service no inició. Revisa NetworkManager/hotspot."
fi
if [[ "$ARGOS_ENABLE_CAMERA" == "yes" ]]; then
  systemctl restart nginx || true
  systemctl restart argos-camera-hls.service || warn "argos-camera-hls.service no inició. Revisa cámara CSI."
fi
if [[ "$ARGOS_ENABLE_APP" == "yes" ]]; then
  systemctl restart argos-app.service || warn "argos-app.service no inició. Revisa ARGOS_START_CMD o logs."
fi

log "Publicación ARGOS completada. En el próximo encendido arrancará automáticamente."
log "Estado: sudo /opt/mango/raspberry/scripts/argos-status.sh"
log "Logs app: sudo journalctl -u argos-app.service -f"
log "Logs cámara: sudo journalctl -u argos-camera-hls.service -f"
