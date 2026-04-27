#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
load_env

mkdir -p "$STREAM_DIR"
rm -f "$STREAM_DIR"/*.m3u8 "$STREAM_DIR"/*.ts 2>/dev/null || true

CAM_BIN="$(camera_bin)" || die "No encontré rpicam-vid ni libcamera-vid. Instala rpicam-apps/libcamera-apps."
TUNING_FILE="$(select_noir_tuning_file || true)"

cmd=("$CAM_BIN" -t 0 -n --width "$CAM_WIDTH" --height "$CAM_HEIGHT" --framerate "$CAM_FPS" --bitrate "$CAM_BITRATE" --codec h264 --inline -o -)
if [[ -n "$TUNING_FILE" ]]; then
  cmd+=(--tuning-file "$TUNING_FILE")
  log "Usando tuning NoIR: $TUNING_FILE"
fi
if [[ -n "$CAM_EXTRA_ARGS" ]]; then
  # Simple parsing for optional expert flags. Avoid quotes inside CAM_EXTRA_ARGS.
  read -r -a extra_args <<< "$CAM_EXTRA_ARGS"
  cmd+=("${extra_args[@]}")
fi

log "Iniciando cámara CSI: ${CAM_WIDTH}x${CAM_HEIGHT}@${CAM_FPS}, bitrate=${CAM_BITRATE}"
log "Publicando HLS en: $STREAM_DIR/stream.m3u8"

"${cmd[@]}" | ffmpeg   -hide_banner -loglevel warning   -fflags nobuffer -flags low_delay   -f h264 -i -   -c:v copy   -f hls   -hls_time "$CAM_HLS_TIME"   -hls_list_size "$CAM_HLS_LIST_SIZE"   -hls_flags delete_segments+append_list+omit_endlist+program_date_time   -hls_segment_filename "$STREAM_DIR/segment_%05d.ts"   "$STREAM_DIR/stream.m3u8"
