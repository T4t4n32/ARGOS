#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
require_root
load_env

ARGOS_ENV_FILE="${ARGOS_ENV_FILE:-/etc/argos/argos.env}"
if [[ -f "$ARGOS_ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ARGOS_ENV_FILE"
fi

printf '\n========== ARGOS BOOT STATUS =========='; printf '\n'
printf 'Fecha: %s\n' "$(date -Is)"
printf 'Hostname: %s\n' "$(hostname)"
printf 'ARGOS_APP_DIR: %s\n' "${ARGOS_APP_DIR:-/opt/argos/app}"
printf 'ARGOS_START_CMD: %s\n' "${ARGOS_START_CMD:-python3 main.py}"
printf 'Hotspot URL: http://%s/\n' "${HOTSPOT_IP4%/*}"
printf 'HLS URL: http://%s/cam/stream.m3u8\n' "${HOTSPOT_IP4%/*}"

printf '\n[systemd enabled]\n'
systemctl is-enabled argos-stack.target 2>/dev/null || true
systemctl is-enabled argos-hotspot.service 2>/dev/null || true
systemctl is-enabled argos-camera-hls.service 2>/dev/null || true
systemctl is-enabled argos-app.service 2>/dev/null || true

printf '\n[systemd status]\n'
systemctl --no-pager --full status argos-stack.target 2>/dev/null || true
systemctl --no-pager --full status argos-hotspot.service 2>/dev/null || true
systemctl --no-pager --full status argos-camera-hls.service 2>/dev/null || true
systemctl --no-pager --full status argos-app.service 2>/dev/null || true

printf '\n[recent app logs]\n'
journalctl -u argos-app.service -n 40 --no-pager 2>/dev/null || true
printf '\n========================================\n'
