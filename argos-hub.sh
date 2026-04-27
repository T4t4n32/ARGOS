#!/usr/bin/env bash
set -Eeuo pipefail

# ==============================================================================
# ARGOS HUB — entrada única de operación y despliegue
# ==============================================================================
# Uso principal:
#   ./argos-hub.sh publish   # instala/actualiza el stack de arranque
#   ./argos-hub.sh start     # inicia ARGOS vía systemd
#   ./argos-hub.sh status    # auditoría rápida del stack
# ==============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR="$PROJECT_DIR/deploy/raspberry"
SCRIPT_DIR="$DEPLOY_DIR/scripts"
ARGOS_ENV_FILE="${ARGOS_ENV_FILE:-/etc/argos/argos.env}"
RASPI_ENV_FILE="${ENV_FILE:-/etc/mango/raspi.env}"
STACK_TARGET="argos-stack.target"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { printf "${GREEN}[argos-hub]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[argos-hub][WARN]${NC} %s\n" "$*" >&2; }
err() { printf "${RED}[argos-hub][ERROR]${NC} %s\n" "$*" >&2; }
die() { err "$*"; exit 1; }

have_systemd() { command -v systemctl >/dev/null 2>&1 && [[ -d /run/systemd/system || -d /etc/systemd/system ]]; }
need_file() { [[ -f "$1" ]] || die "No existe el archivo requerido: $1"; }
need_dir() { [[ -d "$1" ]] || die "No existe el directorio requerido: $1"; }

as_root() {
  if [[ "${EUID}" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

usage() {
  cat <<'HELP'
ARGOS Hub — comando único de operación

Comandos principales:
  publish | install   Instala/actualiza el despliegue y deja ARGOS al arranque
  update              Actualiza dependencias/archivos de despliegue
  start               Inicia todo el stack ARGOS
  stop                Detiene todo el stack ARGOS
  restart             Reinicia todo el stack ARGOS
  status              Estado + diagnóstico operativo
  audit               Auditoría profunda de deploy, servicios, cámara y app
  doctor              Diagnóstico Raspberry/cámara/hotspot
  logs                Logs generales del stack
  app-log             Logs de argos-app.service
  camera-log          Logs de argos-camera-hls.service
  hotspot-log         Logs de argos-hotspot.service
  enable              Habilita arranque automático
  disable             Deshabilita arranque automático
  env                 Muestra rutas de configuración
  help                Muestra esta ayuda

Ejemplos:
  ./argos-hub.sh publish
  ./argos-hub.sh status
  ./argos-hub.sh logs
HELP
}

ensure_deploy_layout() {
  need_dir "$DEPLOY_DIR"
  need_file "$DEPLOY_DIR/publicar-argos.sh"
  need_file "$DEPLOY_DIR/install.sh"
  need_file "$SCRIPT_DIR/argos-status.sh"
  need_file "$SCRIPT_DIR/doctor.sh"
}

publish_stack() {
  ensure_deploy_layout
  log "Publicando stack ARGOS con deploy/raspberry/publicar-argos.sh ..."
  as_root bash "$DEPLOY_DIR/publicar-argos.sh"
}

update_stack() {
  ensure_deploy_layout
  log "Actualizando despliegue Raspberry/ARGOS ..."
  as_root bash "$DEPLOY_DIR/update.sh"
}

systemd_action() {
  local action="$1"
  have_systemd || die "systemd no está disponible en este entorno. Usa publish en la Raspberry Pi."
  as_root systemctl "$action" "$STACK_TARGET"
}

start_stack() {
  have_systemd || die "systemd no está disponible."
  log "Iniciando $STACK_TARGET ..."
  as_root systemctl start "$STACK_TARGET"
  as_root systemctl start argos-hotspot.service 2>/dev/null || true
  as_root systemctl start argos-camera-hls.service 2>/dev/null || true
  as_root systemctl start argos-app.service 2>/dev/null || true
  status_stack
}

stop_stack() {
  have_systemd || die "systemd no está disponible."
  log "Deteniendo servicios ARGOS ..."
  as_root systemctl stop argos-app.service 2>/dev/null || true
  as_root systemctl stop argos-camera-hls.service 2>/dev/null || true
  as_root systemctl stop argos-hotspot.service 2>/dev/null || true
  as_root systemctl stop "$STACK_TARGET" 2>/dev/null || true
  log "Stack detenido."
}

restart_stack() {
  stop_stack
  sleep 2
  start_stack
}

status_stack() {
  ensure_deploy_layout
  if [[ -x /opt/mango/raspberry/scripts/argos-status.sh ]]; then
    as_root /opt/mango/raspberry/scripts/argos-status.sh
  else
    as_root bash "$SCRIPT_DIR/argos-status.sh"
  fi
}

audit_stack() {
  ensure_deploy_layout
  if [[ -x /opt/mango/raspberry/scripts/argos-audit.sh ]]; then
    as_root /opt/mango/raspberry/scripts/argos-audit.sh
  else
    as_root bash "$SCRIPT_DIR/argos-audit.sh"
  fi
}

doctor_stack() {
  ensure_deploy_layout
  if [[ -x /opt/mango/raspberry/scripts/doctor.sh ]]; then
    as_root /opt/mango/raspberry/scripts/doctor.sh
  else
    as_root bash "$SCRIPT_DIR/doctor.sh"
  fi
}

show_logs() {
  have_systemd || die "systemd no está disponible."
  as_root journalctl -u argos-stack.target -u argos-hotspot.service -u argos-camera-hls.service -u argos-app.service -f
}

show_env() {
  printf "${CYAN}Proyecto:${NC} %s\n" "$PROJECT_DIR"
  printf "${CYAN}Deploy:${NC}   %s\n" "$DEPLOY_DIR"
  printf "${CYAN}ARGOS env:${NC} %s\n" "$ARGOS_ENV_FILE"
  printf "${CYAN}Raspi env:${NC} %s\n" "$RASPI_ENV_FILE"
  [[ -f "$ARGOS_ENV_FILE" ]] && sed -n '1,160p' "$ARGOS_ENV_FILE" || warn "Aún no existe $ARGOS_ENV_FILE"
}

case "${1:-help}" in
  publish|install) publish_stack ;;
  update) update_stack ;;
  start) start_stack ;;
  stop) stop_stack ;;
  restart) restart_stack ;;
  status) status_stack ;;
  audit) audit_stack ;;
  doctor) doctor_stack ;;
  logs) show_logs ;;
  app-log) have_systemd && as_root journalctl -u argos-app.service -f ;;
  camera-log) have_systemd && as_root journalctl -u argos-camera-hls.service -f ;;
  hotspot-log) have_systemd && as_root journalctl -u argos-hotspot.service -f ;;
  enable) systemd_action enable ;;
  disable) systemd_action disable ;;
  env) show_env ;;
  help|-h|--help) usage ;;
  *) usage; exit 1 ;;
esac
