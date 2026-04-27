#!/usr/bin/env bash
# =============================================================================
#  ARGOS — Instalador para Raspberry Pi OS Bookworm (Pi 5)
# =============================================================================
#  Uso:
#    sudo bash deploy/install.sh
#
#  Qué hace:
#    1. Actualiza el sistema (apt-get)
#    2. Instala dependencias nativas (build-essential, i2c-tools, OpenCV libs)
#    3. Habilita I2C y SPI via raspi-config
#    4. Crea el entorno virtual Python (.venv)
#    5. Instala dependencias Python (requirements_pi.txt + argos_app)
#    6. Copia argos.yaml de ejemplo si no existe
#    7. Descarga mediamtx (servidor RTSP)
#    8. Instala ffmpeg
#    9. Configura hotspot WiFi "ARGOS-KAIROS" via nmcli
#   10. Instala y habilita servicios systemd (argos-hub, argos-main)
#   11. Verifica la instalación
# =============================================================================

set -euo pipefail

# ── Colores ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✔ ${*}${NC}"; }
warn() { echo -e "${YELLOW}⚠ ${*}${NC}"; }
err()  { echo -e "${RED}✘ ${*}${NC}" >&2; exit 1; }

# ── Rutas ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOFTWARE_DIR="${PROJECT_ROOT}/software"
VENV_DIR="${SOFTWARE_DIR}/.venv"
CONFIG_DST="${SOFTWARE_DIR}/config/argos.yaml"
CONFIG_EXAMPLE="${SOFTWARE_DIR}/config/argos.example.yaml"

ARGOS_USER="${SUDO_USER:-$(whoami)}"
ARGOS_HOME=$(eval echo "~${ARGOS_USER}")

# ── Hotspot ───────────────────────────────────────────────────────────────────
HOTSPOT_SSID="ARGOS-KAIROS"
HOTSPOT_PASSWORD="argos2026"
HOTSPOT_IP="192.168.4.1/24"
HOTSPOT_CON="argos-hotspot"
HOTSPOT_IFACE="wlan0"

# ── mediamtx ──────────────────────────────────────────────────────────────────
MEDIAMTX_VERSION="v1.9.3"
MEDIAMTX_ARCH="arm64"
MEDIAMTX_TAR="mediamtx_${MEDIAMTX_VERSION}_linux_${MEDIAMTX_ARCH}.tar.gz"
MEDIAMTX_URL="https://github.com/bluenviron/mediamtx/releases/download/${MEDIAMTX_VERSION}/${MEDIAMTX_TAR}"
MEDIAMTX_BIN="${ARGOS_HOME}/mediamtx"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║      ARGOS — Instalador Raspberry Pi 5           ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

[[ $EUID -ne 0 ]] && err "Ejecuta con sudo: sudo bash deploy/install.sh"

# =============================================================================
# Paso 1 — Sistema
# =============================================================================
echo "▸ [1/11] Actualizando sistema..."
apt-get update -qq
apt-get upgrade -y -qq
ok "Sistema actualizado"

# =============================================================================
# Paso 2 — Dependencias nativas
# =============================================================================
echo "▸ [2/11] Instalando dependencias nativas..."
apt-get install -y -qq \
    build-essential python3-dev python3-pip python3-venv \
    i2c-tools libi2c-dev \
    libgpiod2 gpiod \
    libhdf5-dev libhdf5-serial-dev \
    libatlas-base-dev liblapack-dev libblas-dev \
    libopenjp2-7 libtiff5 libavcodec-dev libavformat-dev libswscale-dev \
    ffmpeg curl wget git
ok "Dependencias nativas instaladas"

# =============================================================================
# Paso 3 — Interfaces de hardware
# =============================================================================
echo "▸ [3/11] Habilitando I2C y SPI..."
raspi-config nonint do_i2c 0
raspi-config nonint do_spi 0
usermod -aG i2c,spi,gpio,video,dialout "${ARGOS_USER}" 2>/dev/null || true
ok "I2C y SPI habilitados"

# =============================================================================
# Paso 4 — Entorno virtual Python
# =============================================================================
echo "▸ [4/11] Creando entorno virtual Python..."
sudo -u "${ARGOS_USER}" python3 -m venv "${VENV_DIR}"
ok "Entorno virtual en ${VENV_DIR}"

# =============================================================================
# Paso 5 — Dependencias Python
# =============================================================================
echo "▸ [5/11] Instalando dependencias Python..."
REQUIREMENTS="${SCRIPT_DIR}/requirements_pi.txt"
sudo -u "${ARGOS_USER}" "${VENV_DIR}/bin/pip" install --upgrade pip -q
sudo -u "${ARGOS_USER}" "${VENV_DIR}/bin/pip" install -r "${REQUIREMENTS}" -q
# Install the argos_app package in editable mode
sudo -u "${ARGOS_USER}" "${VENV_DIR}/bin/pip" install -e "${SOFTWARE_DIR}" -q
ok "Dependencias Python instaladas"

# =============================================================================
# Paso 6 — Configuración YAML
# =============================================================================
echo "▸ [6/11] Configurando argos.yaml..."
mkdir -p "${SOFTWARE_DIR}/config"
if [[ ! -f "${CONFIG_DST}" ]]; then
    if [[ -f "${CONFIG_EXAMPLE}" ]]; then
        cp "${CONFIG_EXAMPLE}" "${CONFIG_DST}"
        ok "argos.yaml copiado desde ejemplo"
    else
        warn "No se encontró argos.example.yaml — crea ${CONFIG_DST} manualmente"
    fi
else
    ok "argos.yaml ya existe — no se sobreescribe"
fi

# =============================================================================
# Paso 7 — mediamtx (servidor RTSP)
# =============================================================================
echo "▸ [7/11] Instalando mediamtx ${MEDIAMTX_VERSION}..."
if [[ ! -f "${MEDIAMTX_BIN}" ]]; then
    TMP_TAR="/tmp/${MEDIAMTX_TAR}"
    wget -q --show-progress "${MEDIAMTX_URL}" -O "${TMP_TAR}" || \
        { warn "No se pudo descargar mediamtx — omitiendo."; }
    if [[ -f "${TMP_TAR}" ]]; then
        tar -xzf "${TMP_TAR}" -C "${ARGOS_HOME}" mediamtx 2>/dev/null || \
        tar -xzf "${TMP_TAR}" -C /tmp && cp /tmp/mediamtx "${MEDIAMTX_BIN}"
        chown "${ARGOS_USER}:${ARGOS_USER}" "${MEDIAMTX_BIN}"
        chmod +x "${MEDIAMTX_BIN}"
        rm -f "${TMP_TAR}"
        ok "mediamtx instalado en ${MEDIAMTX_BIN}"
    fi
else
    ok "mediamtx ya instalado"
fi

# =============================================================================
# Paso 8 — ffmpeg (ya instalado en paso 2, verificación)
# =============================================================================
echo "▸ [8/11] Verificando ffmpeg..."
command -v ffmpeg &>/dev/null && ok "ffmpeg disponible" || warn "ffmpeg no encontrado"

# =============================================================================
# Paso 9 — Hotspot WiFi via nmcli
# =============================================================================
echo "▸ [9/11] Configurando hotspot WiFi '${HOTSPOT_SSID}'..."

# Asegura que NetworkManager gestione wlan0
if ! systemctl is-active --quiet NetworkManager; then
    systemctl enable NetworkManager
    systemctl start NetworkManager
    sleep 2
fi

# Crea la conexión solo si no existe
if nmcli -t -f NAME con show | grep -q "^${HOTSPOT_CON}$"; then
    ok "Conexión '${HOTSPOT_CON}' ya existe"
else
    nmcli con add \
        type       wifi \
        ifname     "${HOTSPOT_IFACE}" \
        con-name   "${HOTSPOT_CON}" \
        autoconnect yes \
        ssid       "${HOTSPOT_SSID}" \
        -- \
        wifi.mode                        ap \
        wifi-sec.key-mgmt               wpa-psk \
        wifi-sec.psk                    "${HOTSPOT_PASSWORD}" \
        ipv4.method                     shared \
        ipv4.addresses                  "${HOTSPOT_IP}" \
        connection.autoconnect-priority  10
    ok "Conexión '${HOTSPOT_CON}' creada"
fi

# Activa el hotspot
nmcli con up "${HOTSPOT_CON}" && ok "Hotspot '${HOTSPOT_SSID}' activo" || \
    warn "No se pudo activar el hotspot ahora — se activará al reiniciar"

# =============================================================================
# Paso 10 — Servicios systemd
# =============================================================================
echo "▸ [10/11] Instalando servicios systemd..."

generate_service() {
    local svc="$1"; local desc="$2"; local exec_start="$3"
    cat > "/etc/systemd/system/${svc}.service" <<EOF
[Unit]
Description=${desc}
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${ARGOS_USER}
WorkingDirectory=${PROJECT_ROOT}
ExecStart=${exec_start}
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
SyslogIdentifier=${svc}

[Install]
WantedBy=multi-user.target
EOF
}

generate_service \
    "argos-hub" \
    "ARGOS Sensor Hub (asyncio)" \
    "${VENV_DIR}/bin/argos-hub --mode simulated"

generate_service \
    "argos-main" \
    "ARGOS Robot Main (hardware)" \
    "${VENV_DIR}/bin/argos-main"

systemctl daemon-reload
systemctl enable argos-hub.service
systemctl enable argos-main.service
ok "Servicios argos-hub y argos-main instalados y habilitados"

# =============================================================================
# Paso 11 — Verificación
# =============================================================================
echo "▸ [11/11] Verificando instalación..."
ERRORS=0

"${VENV_DIR}/bin/python" -c "import argos_app" 2>/dev/null \
    && ok "argos_app importable" || { warn "argos_app no importable"; ERRORS=$((ERRORS+1)); }

[[ -f "${CONFIG_DST}" ]] \
    && ok "argos.yaml presente" || { warn "argos.yaml FALTANTE"; ERRORS=$((ERRORS+1)); }

[[ -f "${MEDIAMTX_BIN}" ]] \
    && ok "mediamtx presente" || warn "mediamtx no encontrado (opcional)"

if [[ $ERRORS -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✔  Instalación completada con éxito             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
else
    echo ""
    warn "Instalación completada con ${ERRORS} advertencia(s). Revisa los mensajes ⚠ arriba."
fi

echo ""
echo "  Próximos pasos:"
echo "    sudo reboot                          # aplica grupos de usuario e interfaces"
echo "    argos-hub --mode simulated           # prueba el hub sin hardware"
echo "    sudo systemctl status argos-hub      # estado del servicio"
echo "    journalctl -u argos-hub -f           # logs en tiempo real"
echo ""
echo "  Red WiFi hotspot: SSID='${HOTSPOT_SSID}'  pass='${HOTSPOT_PASSWORD}'"
echo "  Dashboard:        http://argos.local:8888"
echo ""
