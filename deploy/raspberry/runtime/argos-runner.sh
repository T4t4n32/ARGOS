#!/usr/bin/env bash
set -Eeuo pipefail

ENV_FILE="${ARGOS_ENV_FILE:-/etc/argos/argos.env}"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

ARGOS_BASE_DIR="${ARGOS_BASE_DIR:-/opt/argos}"
ARGOS_APP_DIR="${ARGOS_APP_DIR:-/opt/argos/app}"
ARGOS_VENV_DIR="${ARGOS_VENV_DIR:-/opt/argos/venv}"
ARGOS_LOG_DIR="${ARGOS_LOG_DIR:-/var/log/argos}"
ARGOS_RUN_DIR="${ARGOS_RUN_DIR:-/run/argos}"
ARGOS_START_CMD="${ARGOS_START_CMD:-python3 main.py}"

mkdir -p "$ARGOS_LOG_DIR" "$ARGOS_RUN_DIR"

if [[ ! -d "$ARGOS_APP_DIR" ]]; then
  echo "[argos-runner][ERROR] ARGOS_APP_DIR no existe: $ARGOS_APP_DIR" >&2
  exit 2
fi

cd "$ARGOS_APP_DIR"

echo "[argos-runner] ARGOS_MODE=${ARGOS_MODE:-production}"
echo "[argos-runner] APP_DIR=$ARGOS_APP_DIR"
echo "[argos-runner] START_CMD=$ARGOS_START_CMD"

if [[ -d "$ARGOS_VENV_DIR" && -f "$ARGOS_VENV_DIR/bin/activate" ]]; then
  # shellcheck disable=SC1091
  source "$ARGOS_VENV_DIR/bin/activate"
  echo "[argos-runner] Python venv activado: $ARGOS_VENV_DIR"
fi

exec bash -lc "$ARGOS_START_CMD"
