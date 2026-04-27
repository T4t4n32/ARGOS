#!/usr/bin/env bash
# ==============================================================================
# ARGOS CONTROL CHECK
# Verifica permisos, protocolos y servicios necesarios para ARGOS.
# ==============================================================================

set -Eeuo pipefail

ARGOS_USER="${ARGOS_USER:-${SUDO_USER:-pi}}"
ARGOS_GROUP="${ARGOS_GROUP:-argos}"
ARGOS_BASE="${ARGOS_BASE:-/opt/argos}"
ARGOS_ETC="${ARGOS_ETC:-/etc/argos}"
MANGO_BASE="${MANGO_BASE:-/opt/mango/raspberry}"

ok()   { printf '\033[1;32m[OK]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*"; }

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

check_user_groups() {
  echo
  echo "== Usuario y grupos =="
  if id "$ARGOS_USER" >/dev/null 2>&1; then
    ok "Usuario existe: $ARGOS_USER"
    id "$ARGOS_USER"
  else
    fail "Usuario no existe: $ARGOS_USER"
    return 0
  fi

  local groups=(argos gpio i2c spi video dialout input render plugdev netdev)
  for group in "${groups[@]}"; do
    if id -nG "$ARGOS_USER" | tr ' ' '\n' | grep -qx "$group"; then
      ok "$ARGOS_USER pertenece a $group"
    else
      warn "$ARGOS_USER todavía no aparece en $group. Puede requerir cerrar sesión o reiniciar."
    fi
  done
}

check_directories() {
  echo
  echo "== Carpetas ARGOS =="
  local dirs=(
    "$ARGOS_BASE"
    "$ARGOS_BASE/app"
    "$ARGOS_BASE/data"
    "$ARGOS_BASE/runtime"
    "$ARGOS_BASE/config"
    "$ARGOS_ETC"
    "/var/log/argos"
    "/var/lib/argos"
    "/run/argos"
  )

  for dir in "${dirs[@]}"; do
    if [[ -d "$dir" ]]; then
      ok "Existe: $dir"
      ls -ld "$dir"
    else
      warn "Falta: $dir"
    fi
  done
}

check_devices() {
  echo
  echo "== Dispositivos / protocolos =="

  [[ -e /dev/i2c-1 ]] && ok "I2C disponible: /dev/i2c-1" || warn "I2C no visible: /dev/i2c-1"
  [[ -e /dev/spidev0.0 || -e /dev/spidev0.1 ]] && ok "SPI disponible: $(ls /dev/spidev0.* 2>/dev/null | tr '\n' ' ')" || warn "SPI no visible: /dev/spidev0.*"
  [[ -e /dev/gpiochip0 ]] && ok "GPIO disponible: /dev/gpiochip0" || warn "GPIO no visible: /dev/gpiochip0"
  compgen -G "/dev/video*" >/dev/null && ok "Video/cámara visible: $(ls /dev/video* | tr '\n' ' ')" || warn "No hay /dev/video* visible"
  compgen -G "/dev/ttyUSB*" >/dev/null && ok "Serial USB: $(ls /dev/ttyUSB* | tr '\n' ' ')" || warn "No hay /dev/ttyUSB* conectado"
  compgen -G "/dev/ttyACM*" >/dev/null && ok "Serial ACM: $(ls /dev/ttyACM* | tr '\n' ' ')" || warn "No hay /dev/ttyACM* conectado"
}

check_commands() {
  echo
  echo "== Comandos clave =="

  for cmd in systemctl udevadm nmcli ffmpeg nginx python3; do
    if has_cmd "$cmd"; then
      ok "$cmd disponible: $(command -v "$cmd")"
    else
      warn "$cmd no disponible"
    fi
  done

  if has_cmd rpicam-vid; then
    ok "rpicam-vid disponible"
    rpicam-vid --version 2>/dev/null | head -n 2 || true
  elif has_cmd libcamera-vid; then
    warn "libcamera-vid disponible, pero se recomienda rpicam-vid en Raspberry Pi OS reciente"
    libcamera-vid --version 2>/dev/null | head -n 2 || true
  else
    warn "No encontré rpicam-vid/libcamera-vid"
  fi
}

check_services() {
  echo
  echo "== Servicios ARGOS =="

  local units=(argos-stack.target argos-app.service argos-camera-hls.service argos-hotspot.service)

  if ! has_cmd systemctl; then
    warn "systemctl no disponible"
    return 0
  fi

  for unit in "${units[@]}"; do
    if systemctl list-unit-files "$unit" >/dev/null 2>&1; then
      ok "Unit registrada: $unit"
      systemctl is-enabled "$unit" 2>/dev/null || true
      systemctl is-active "$unit" 2>/dev/null || true
    else
      warn "Unit no registrada todavía: $unit"
    fi
  done
}

check_security() {
  echo
  echo "== Seguridad aplicada =="

  [[ -f /etc/udev/rules.d/99-argos-control.rules ]] && ok "Reglas udev ARGOS instaladas" || warn "No existe /etc/udev/rules.d/99-argos-control.rules"
  [[ -f /etc/sudoers.d/argos-control ]] && ok "sudoers limitado ARGOS instalado" || warn "No existe /etc/sudoers.d/argos-control"

  if [[ -f /etc/sudoers.d/argos-control ]] && command -v visudo >/dev/null 2>&1; then
    visudo -cf /etc/sudoers.d/argos-control && ok "sudoers ARGOS válido" || fail "sudoers ARGOS inválido"
  fi
}

main() {
  echo "============================================================================="
  echo "ARGOS CONTROL CHECK"
  echo "============================================================================="
  check_user_groups
  check_directories
  check_devices
  check_commands
  check_services
  check_security
  echo
  echo "Chequeo terminado."
  echo "Si agregaste grupos o cambiaste /boot/firmware/config.txt, reinicia:"
  echo "  sudo reboot"
}

main "$@"
