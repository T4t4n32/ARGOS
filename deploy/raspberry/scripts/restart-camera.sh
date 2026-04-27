#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
require_root
load_env
systemctl restart mango-camera-hls.service
sleep 2
systemctl --no-pager --full status mango-camera-hls.service || true
log "Stream: http://${HOTSPOT_IP4%/*}/cam/stream.m3u8"
