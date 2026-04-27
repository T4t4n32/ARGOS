#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
require_root
load_env
need_cmd nmcli
rfkill unblock wifi || true
nmcli connection up "$HOTSPOT_CONN_NAME"
log "Hotspot encendido: $HOTSPOT_SSID -> http://${HOTSPOT_IP4%/*}/"
