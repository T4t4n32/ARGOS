#!/usr/bin/env bash
# ==============================================================================
# ARGOS CONTROL REVOKE
# Revierte permisos especiales de ARGOS de forma conservadora.
# No borra carpetas ni elimina grupos por defecto.
# ==============================================================================

set -Eeuo pipefail

ARGOS_USER="${ARGOS_USER:-${SUDO_USER:-pi}}"
ARGOS_GROUP="${ARGOS_GROUP:-argos}"

log()  { printf '\033[1;32m[ARGOS]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

if [[ "${EUID}" -ne 0 ]]; then
  err "Ejecuta con sudo: sudo bash $0"
fi

log "Revocando accesos especiales ARGOS..."

if [[ -f /etc/sudoers.d/argos-control ]]; then
  rm -f /etc/sudoers.d/argos-control
  log "Eliminado: /etc/sudoers.d/argos-control"
fi

if [[ -f /etc/udev/rules.d/99-argos-control.rules ]]; then
  rm -f /etc/udev/rules.d/99-argos-control.rules
  log "Eliminado: /etc/udev/rules.d/99-argos-control.rules"
  udevadm control --reload-rules || warn "No se pudieron recargar reglas udev."
  udevadm trigger || warn "No se pudo ejecutar udevadm trigger."
fi

if [[ "${1:-}" == "--remove-user-groups" ]]; then
  warn "Quitando grupos de hardware al usuario ${ARGOS_USER}. Esto puede afectar otros proyectos."
  for group in argos gpio i2c spi video dialout input render plugdev netdev; do
    if getent group "$group" >/dev/null 2>&1; then
      gpasswd -d "$ARGOS_USER" "$group" >/dev/null 2>&1 || true
    fi
  done
  log "Grupos removidos donde fue posible. Cierra sesión o reinicia para aplicar."
else
  warn "No se removieron grupos del usuario. Usa --remove-user-groups si realmente quieres hacerlo."
fi

log "Revocación conservadora completada."
