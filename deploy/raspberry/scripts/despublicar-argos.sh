#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
require_root

warn "Desactivando arranque automático de ARGOS..."
systemctl disable --now argos-stack.target 2>/dev/null || true
systemctl disable --now argos-hotspot.service 2>/dev/null || true
systemctl disable --now argos-camera-hls.service 2>/dev/null || true
systemctl disable --now argos-app.service 2>/dev/null || true
systemctl daemon-reload
log "ARGOS despublicado. Los archivos quedan instalados, pero no arrancarán automáticamente."
