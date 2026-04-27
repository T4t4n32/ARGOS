#!/usr/bin/env bash
set -Eeuo pipefail

ENV_FILE="${ENV_FILE:-/etc/mango/raspi.env}"
DEFAULT_ENV_EXAMPLE="/opt/mango/raspberry/raspi.env.example"

log() {
  printf '\033[1;32m[raspi-deploy]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[raspi-deploy][WARN]\033[0m %s\n' "$*" >&2
}

err() {
  printf '\033[1;31m[raspi-deploy][ERROR]\033[0m %s\n' "$*" >&2
}

die() {
  err "$*"
  exit 1
}

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    die "Ejecuta este script con sudo o como root."
  fi
}

load_env() {
  if [[ -f "$ENV_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$ENV_FILE"
  elif [[ -f "$DEFAULT_ENV_EXAMPLE" ]]; then
    # shellcheck disable=SC1090
    source "$DEFAULT_ENV_EXAMPLE"
    warn "No existe $ENV_FILE; usando valores de ejemplo."
  else
    warn "No encontré archivo de entorno. Usando valores mínimos internos."
  fi

  PROJECT_NAME="${PROJECT_NAME:-mango}"
  DEVICE_HOSTNAME="${DEVICE_HOSTNAME:-mango-pi}"
  INSTALL_DIR="${INSTALL_DIR:-/opt/mango/raspberry}"
  DATA_DIR="${DATA_DIR:-/var/lib/mango}"
  LOG_DIR="${LOG_DIR:-/var/log/mango}"
  WEB_ROOT="${WEB_ROOT:-/var/www/html}"
  STREAM_DIR="${STREAM_DIR:-/var/www/html/cam}"

  CAM_WIDTH="${CAM_WIDTH:-1280}"
  CAM_HEIGHT="${CAM_HEIGHT:-720}"
  CAM_FPS="${CAM_FPS:-24}"
  CAM_BITRATE="${CAM_BITRATE:-2500000}"
  CAM_HLS_TIME="${CAM_HLS_TIME:-1}"
  CAM_HLS_LIST_SIZE="${CAM_HLS_LIST_SIZE:-4}"
  CAM_TUNING_FILE="${CAM_TUNING_FILE:-auto}"
  CAM_EXTRA_ARGS="${CAM_EXTRA_ARGS:-}"

  HOTSPOT_CONN_NAME="${HOTSPOT_CONN_NAME:-MANGO-Hotspot}"
  HOTSPOT_IFACE="${HOTSPOT_IFACE:-wlan0}"
  HOTSPOT_SSID="${HOTSPOT_SSID:-MANGO_PI_CAM}"
  HOTSPOT_PASSWORD="${HOTSPOT_PASSWORD:-ChangeMe_MANGO_2026}"
  HOTSPOT_IP4="${HOTSPOT_IP4:-10.42.0.1/24}"
  HOTSPOT_AUTOSTART="${HOTSPOT_AUTOSTART:-yes}"
  HLS_JS_URL="${HLS_JS_URL:-https://cdn.jsdelivr.net/npm/hls.js@1/dist/hls.min.js}"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Falta el comando requerido: $1"
}

is_raspberry_pi() {
  [[ -r /proc/device-tree/model ]] && tr -d '\0' < /proc/device-tree/model | grep -qi "Raspberry Pi"
}

camera_bin() {
  if command -v rpicam-vid >/dev/null 2>&1; then
    printf 'rpicam-vid'
  elif command -v libcamera-vid >/dev/null 2>&1; then
    printf 'libcamera-vid'
  else
    return 1
  fi
}

camera_hello_bin() {
  if command -v rpicam-hello >/dev/null 2>&1; then
    printf 'rpicam-hello'
  elif command -v libcamera-hello >/dev/null 2>&1; then
    printf 'libcamera-hello'
  else
    return 1
  fi
}

select_noir_tuning_file() {
  # Raspberry Pi 4 and earlier use vc4 tuning files. Pi 5 uses pisp.
  local base_dirs=(
    "/usr/share/libcamera/ipa/rpi/vc4"
    "/usr/share/libcamera/ipa/rpi/pisp"
  )
  local names=(
    "imx708_noir.json"
    "imx219_noir.json"
    "ov5647_noir.json"
  )

  if [[ "$CAM_TUNING_FILE" == "" || "$CAM_TUNING_FILE" == "none" ]]; then
    return 0
  fi

  if [[ "$CAM_TUNING_FILE" != "auto" ]]; then
    [[ -f "$CAM_TUNING_FILE" ]] && printf '%s' "$CAM_TUNING_FILE"
    return 0
  fi

  local d n f
  for d in "${base_dirs[@]}"; do
    for n in "${names[@]}"; do
      f="$d/$n"
      if [[ -f "$f" ]]; then
        printf '%s' "$f"
        return 0
      fi
    done
  done
}

validate_hotspot_password() {
  if [[ ${#HOTSPOT_PASSWORD} -lt 8 ]]; then
    die "HOTSPOT_PASSWORD debe tener mínimo 8 caracteres para WPA/WPA2. Edita $ENV_FILE."
  fi
}
