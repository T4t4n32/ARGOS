#!/usr/bin/env bash
# ==============================================================================
# ARGOS CONTROL MASTER
# Activa permisos, protocolos e infraestructura local para control de hardware
# en Raspberry Pi 4B: GPIO, I2C, SPI, UART/serial, cámara CSI, servicios ARGOS,
# hotspot/cámara y carpetas de ejecución.
#
# Seguridad:
# - NO usa chmod 777.
# - NO deja todo como root.
# - Usa grupos Linux, reglas udev y sudoers limitado a servicios/scripts ARGOS.
# ==============================================================================

set -Eeuo pipefail

ARGOS_USER="${ARGOS_USER:-${SUDO_USER:-pi}}"
ARGOS_GROUP="${ARGOS_GROUP:-argos}"
ARGOS_BASE="${ARGOS_BASE:-/opt/argos}"
ARGOS_ETC="${ARGOS_ETC:-/etc/argos}"
ARGOS_LOG="${ARGOS_LOG:-/var/log/argos}"
ARGOS_LIB="${ARGOS_LIB:-/var/lib/argos}"
ARGOS_RUN="${ARGOS_RUN:-/run/argos}"
MANGO_BASE="${MANGO_BASE:-/opt/mango/raspberry}"
SCRIPT_SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Activaciones por defecto.
ARGOS_ENABLE_I2C="${ARGOS_ENABLE_I2C:-1}"
ARGOS_ENABLE_SPI="${ARGOS_ENABLE_SPI:-1}"
ARGOS_ENABLE_UART="${ARGOS_ENABLE_UART:-0}"
ARGOS_ENABLE_1WIRE="${ARGOS_ENABLE_1WIRE:-0}"
ARGOS_INSTALL_PACKAGES="${ARGOS_INSTALL_PACKAGES:-1}"
ARGOS_APPLY_SUDOERS="${ARGOS_APPLY_SUDOERS:-1}"
ARGOS_APPLY_UDEV="${ARGOS_APPLY_UDEV:-1}"

NEED_REBOOT=0

log()  { printf '\033[1;32m[ARGOS]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    err "Ejecuta con sudo: sudo bash $0"
  fi
}

require_user_exists() {
  if ! id "${ARGOS_USER}" >/dev/null 2>&1; then
    err "El usuario ARGOS_USER='${ARGOS_USER}' no existe. Usa: sudo ARGOS_USER=tu_usuario bash $0"
  fi
}

detect_boot_config() {
  if [[ -f /boot/firmware/config.txt ]]; then
    echo "/boot/firmware/config.txt"
  elif [[ -f /boot/config.txt ]]; then
    echo "/boot/config.txt"
  else
    echo ""
  fi
}

backup_file_once() {
  local file="$1"
  if [[ -f "$file" && ! -f "${file}.argos.bak" ]]; then
    cp "$file" "${file}.argos.bak"
    log "Backup creado: ${file}.argos.bak"
  fi
}

ensure_config_line() {
  local file="$1"
  local line="$2"

  [[ -n "$file" ]] || return 0
  [[ -f "$file" ]] || return 0

  if grep -Eq "^[[:space:]]*#?[[:space:]]*${line//\//\\/}[[:space:]]*$" "$file"; then
    # Si existe comentada, la descomenta.
    sed -i -E "s|^[[:space:]]*#[[:space:]]*(${line//\//\\/})[[:space:]]*$|\1|" "$file"
  else
    printf '\n# ARGOS hardware enable\n%s\n' "$line" >> "$file"
  fi

  NEED_REBOOT=1
}

install_packages() {
  [[ "$ARGOS_INSTALL_PACKAGES" == "1" ]] || {
    warn "Instalación de paquetes omitida por ARGOS_INSTALL_PACKAGES=0"
    return 0
  }

  if ! command -v apt-get >/dev/null 2>&1; then
    warn "apt-get no está disponible. Omitiendo instalación automática de paquetes."
    return 0
  fi

  export DEBIAN_FRONTEND=noninteractive
  log "Actualizando índice APT..."
  apt-get update -y || warn "apt-get update falló. Continuo con lo posible."

  local packages=(
    sudo
    udev
    systemd
    network-manager
    i2c-tools
    python3-smbus
    python3-venv
    python3-pip
    python3-serial
    libgpiod-tools
    python3-libgpiod
    v4l-utils
    ffmpeg
    nginx
    rpicam-apps
  )

  for pkg in "${packages[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      log "Paquete presente: $pkg"
    else
      log "Instalando: $pkg"
      apt-get install -y "$pkg" || warn "No se pudo instalar '$pkg'. Revisa repositorios o versión del sistema."
    fi
  done
}

ensure_groups_and_user() {
  log "Creando grupo principal y grupos de hardware si faltan..."

  local groups=(
    "$ARGOS_GROUP"
    gpio
    i2c
    spi
    video
    dialout
    input
    render
    plugdev
    netdev
  )

  for group in "${groups[@]}"; do
    if ! getent group "$group" >/dev/null 2>&1; then
      groupadd --system "$group" || warn "No se pudo crear grupo '$group'"
    fi
  done

  local add_groups
  add_groups="$(IFS=,; echo "${groups[*]}")"

  log "Agregando usuario '${ARGOS_USER}' a grupos: ${add_groups}"
  usermod -aG "$add_groups" "$ARGOS_USER"
  warn "Los grupos nuevos aplican completamente al cerrar sesión o reiniciar."
}

create_directories() {
  log "Creando estructura de carpetas ARGOS..."

  install -d -m 0755 "$ARGOS_BASE"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_BASE/app"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_BASE/bin"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_BASE/data"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_BASE/runtime"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_BASE/config"

  install -d -m 0750 -o root -g "$ARGOS_GROUP" "$ARGOS_ETC"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_LOG"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_LIB"
  install -d -m 2775 -o "$ARGOS_USER" -g "$ARGOS_GROUP" "$ARGOS_RUN"

  if [[ ! -f "$ARGOS_ETC/argos.env" ]]; then
    cat > "$ARGOS_ETC/argos.env" <<EOF
# ARGOS runtime configuration
ARGOS_USER=${ARGOS_USER}
ARGOS_BASE=${ARGOS_BASE}
ARGOS_APP_DIR=${ARGOS_BASE}/app
ARGOS_START_CMD=python3 main.py

# Cámara / streaming
CAM_WIDTH=1280
CAM_HEIGHT=720
CAM_FPS=24
CAM_HLS_DIR=/var/www/html/argos-camera
CAM_HLS_PLAYLIST=stream.m3u8
CAM_TUNING_FILE=auto

# Hotspot local
HOTSPOT_SSID=ARGOS_PI_CAM
HOTSPOT_PASSWORD=ChangeThisPassword123
HOTSPOT_INTERFACE=wlan0
HOTSPOT_IP=10.42.0.1
EOF
    chown root:"$ARGOS_GROUP" "$ARGOS_ETC/argos.env"
    chmod 0640 "$ARGOS_ETC/argos.env"
    log "Creado: $ARGOS_ETC/argos.env"
  else
    log "Conservado: $ARGOS_ETC/argos.env"
  fi
}

install_scripts_to_opt() {
  log "Instalando scripts de control en ${MANGO_BASE}/scripts..."

  install -d -m 0755 "$MANGO_BASE/scripts"

  if [[ -f "$SCRIPT_SRC_DIR/argos-control-check.sh" ]]; then
    install -m 0755 "$SCRIPT_SRC_DIR/argos-control-check.sh" "$MANGO_BASE/scripts/argos-control-check.sh"
  fi

  if [[ -f "$SCRIPT_SRC_DIR/argos-control-revoke.sh" ]]; then
    install -m 0755 "$SCRIPT_SRC_DIR/argos-control-revoke.sh" "$MANGO_BASE/scripts/argos-control-revoke.sh"
  fi

  install -m 0755 "$0" "$MANGO_BASE/scripts/argos-control-master.sh"
}

configure_boot_protocols() {
  local boot_config
  boot_config="$(detect_boot_config)"

  if [[ -z "$boot_config" ]]; then
    warn "No encontré /boot/firmware/config.txt ni /boot/config.txt. Omito activación persistente por config.txt."
    return 0
  fi

  log "Configurando protocolos en: $boot_config"
  backup_file_once "$boot_config"

  [[ "$ARGOS_ENABLE_I2C" == "1" ]] && ensure_config_line "$boot_config" "dtparam=i2c_arm=on"
  [[ "$ARGOS_ENABLE_SPI" == "1" ]] && ensure_config_line "$boot_config" "dtparam=spi=on"
  [[ "$ARGOS_ENABLE_UART" == "1" ]] && ensure_config_line "$boot_config" "enable_uart=1"
  [[ "$ARGOS_ENABLE_1WIRE" == "1" ]] && ensure_config_line "$boot_config" "dtoverlay=w1-gpio"

  log "Cámara CSI: en Raspberry Pi OS moderno se gestiona con rpicam/libcamera; no activo modo legacy."
}

write_udev_rules() {
  [[ "$ARGOS_APPLY_UDEV" == "1" ]] || {
    warn "Reglas udev omitidas por ARGOS_APPLY_UDEV=0"
    return 0
  }

  log "Instalando reglas udev seguras para hardware ARGOS..."

  cat > /etc/udev/rules.d/99-argos-control.rules <<'EOF'
# ARGOS hardware permissions
# Mantiene permisos por grupos, no permisos globales inseguros.

# I2C
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"

# SPI
KERNEL=="spidev*", GROUP="spi", MODE="0660"

# GPIO character devices
KERNEL=="gpiochip*", GROUP="gpio", MODE="0660"

# Cámara / Video4Linux
SUBSYSTEM=="video4linux", GROUP="video", MODE="0660"

# Serial USB / Arduino / microcontroladores
KERNEL=="ttyUSB[0-9]*", GROUP="dialout", MODE="0660", SYMLINK+="argos-ttyUSB%n"
KERNEL=="ttyACM[0-9]*", GROUP="dialout", MODE="0660", SYMLINK+="argos-ttyACM%n"

# Controladores de entrada, mandos o botones externos
SUBSYSTEM=="input", KERNEL=="event*", GROUP="input", MODE="0660"
EOF

  udevadm control --reload-rules || warn "No se pudieron recargar reglas udev."
  udevadm trigger || warn "No se pudo ejecutar udevadm trigger."
}

write_sudoers_limited() {
  [[ "$ARGOS_APPLY_SUDOERS" == "1" ]] || {
    warn "sudoers omitido por ARGOS_APPLY_SUDOERS=0"
    return 0
  }

  if ! command -v visudo >/dev/null 2>&1; then
    warn "visudo no está disponible. Omitiendo sudoers limitado."
    return 0
  fi

  log "Creando sudoers limitado para controlar SOLO servicios/scripts ARGOS..."

  local tmp
  tmp="$(mktemp)"

  cat > "$tmp" <<'EOF'
# ARGOS limited control permissions
# Permite al grupo argos controlar el stack ARGOS sin entregar root completo.

Cmnd_Alias ARGOS_SYSTEMCTL = \
  /usr/bin/systemctl daemon-reload, \
  /usr/bin/systemctl start argos-stack.target, \
  /usr/bin/systemctl stop argos-stack.target, \
  /usr/bin/systemctl restart argos-stack.target, \
  /usr/bin/systemctl status argos-stack.target, \
  /usr/bin/systemctl start argos-app.service, \
  /usr/bin/systemctl stop argos-app.service, \
  /usr/bin/systemctl restart argos-app.service, \
  /usr/bin/systemctl status argos-app.service, \
  /usr/bin/systemctl start argos-camera-hls.service, \
  /usr/bin/systemctl stop argos-camera-hls.service, \
  /usr/bin/systemctl restart argos-camera-hls.service, \
  /usr/bin/systemctl status argos-camera-hls.service, \
  /usr/bin/systemctl start argos-hotspot.service, \
  /usr/bin/systemctl stop argos-hotspot.service, \
  /usr/bin/systemctl restart argos-hotspot.service, \
  /usr/bin/systemctl status argos-hotspot.service

Cmnd_Alias ARGOS_SCRIPTS = \
  /opt/mango/raspberry/scripts/hotspot-on.sh, \
  /opt/mango/raspberry/scripts/hotspot-off.sh, \
  /opt/mango/raspberry/scripts/restart-camera.sh, \
  /opt/mango/raspberry/scripts/argos-status.sh, \
  /opt/mango/raspberry/scripts/argos-control-check.sh

%argos ALL=(root) NOPASSWD: ARGOS_SYSTEMCTL, ARGOS_SCRIPTS
EOF

  if visudo -cf "$tmp"; then
    install -m 0440 "$tmp" /etc/sudoers.d/argos-control
    log "Instalado: /etc/sudoers.d/argos-control"
  else
    rm -f "$tmp"
    err "El archivo sudoers generado no pasó validación. No se instaló."
  fi

  rm -f "$tmp"
}

reload_systemd_if_present() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload || warn "systemctl daemon-reload falló."
  fi
}

print_summary() {
  cat <<EOF

==============================================================================
ARGOS CONTROL MASTER COMPLETADO
==============================================================================

Usuario configurado:
  ${ARGOS_USER}

Grupo principal:
  ${ARGOS_GROUP}

Carpetas:
  ${ARGOS_BASE}
  ${ARGOS_ETC}
  ${ARGOS_LOG}
  ${ARGOS_LIB}

Scripts instalados:
  ${MANGO_BASE}/scripts/argos-control-master.sh
  ${MANGO_BASE}/scripts/argos-control-check.sh
  ${MANGO_BASE}/scripts/argos-control-revoke.sh

Comando de verificación:
  sudo ${MANGO_BASE}/scripts/argos-control-check.sh

Notas:
  - Cierra sesión o reinicia para que los grupos del usuario apliquen.
  - Si se modificó config.txt, reinicia para activar I2C/SPI/UART/1-Wire.
  - Este script NO entrega root total. Entrega control limitado y seguro para ARGOS.

EOF

  if [[ "$NEED_REBOOT" == "1" ]]; then
    warn "REINICIO RECOMENDADO: se modificó configuración de arranque."
    echo "sudo reboot"
  fi
}

main() {
  require_root
  require_user_exists
  log "Iniciando control maestro ARGOS para usuario '${ARGOS_USER}'..."

  install_packages
  ensure_groups_and_user
  create_directories
  install_scripts_to_opt
  configure_boot_protocols
  write_udev_rules
  write_sudoers_limited
  reload_systemd_if_present

  if [[ -x "$MANGO_BASE/scripts/argos-control-check.sh" ]]; then
    "$MANGO_BASE/scripts/argos-control-check.sh" || true
  fi

  print_summary
}

main "$@"
