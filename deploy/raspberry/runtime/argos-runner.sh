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
ARGOS_MODE="${ARGOS_MODE:-production}"
ARGOS_REQUIRE_CONFIG="${ARGOS_REQUIRE_CONFIG:-no}"
ARGOS_CONFIG_FILE="${ARGOS_CONFIG_FILE:-}"

mkdir -p "$ARGOS_LOG_DIR" "$ARGOS_RUN_DIR"

if [[ ! -d "$ARGOS_APP_DIR" ]]; then
  echo "[argos-runner][ERROR] ARGOS_APP_DIR no existe: $ARGOS_APP_DIR" >&2
  exit 2
fi

cd "$ARGOS_APP_DIR"

if [[ "$ARGOS_REQUIRE_CONFIG" == "yes" && -n "$ARGOS_CONFIG_FILE" && ! -f "$ARGOS_CONFIG_FILE" ]]; then
  echo "[argos-runner][ERROR] Falta ARGOS_CONFIG_FILE=$ARGOS_CONFIG_FILE" >&2
  exit 3
fi

echo "[argos-runner] ARGOS_MODE=$ARGOS_MODE"
echo "[argos-runner] APP_DIR=$ARGOS_APP_DIR"
echo "[argos-runner] START_CMD=$ARGOS_START_CMD"
echo "[argos-runner] LOG_DIR=$ARGOS_LOG_DIR"

if [[ -d "$ARGOS_VENV_DIR" && -f "$ARGOS_VENV_DIR/bin/activate" ]]; then
  # shellcheck disable=SC1091
  source "$ARGOS_VENV_DIR/bin/activate"
  echo "[argos-runner] Python venv activado: $ARGOS_VENV_DIR"
else
  echo "[argos-runner][WARN] No se encontró venv en $ARGOS_VENV_DIR; usando entorno del sistema."
fi

exec bash -lc "$ARGOS_START_CMD"
