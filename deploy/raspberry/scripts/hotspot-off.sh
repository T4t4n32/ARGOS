#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
require_root
load_env
need_cmd nmcli
nmcli connection down "$HOTSPOT_CONN_NAME" || true
log "Hotspot apagado: $HOTSPOT_CONN_NAME"
