#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
require_root
load_env
validate_hotspot_password
need_cmd nmcli

log "Preparando hotspot '$HOTSPOT_SSID' en interfaz $HOTSPOT_IFACE ..."
rfkill unblock wifi || true
nmcli radio wifi on || true
nmcli device set "$HOTSPOT_IFACE" managed yes || true

if nmcli -t -f NAME connection show | grep -Fxq "$HOTSPOT_CONN_NAME"; then
  log "Conexión existente encontrada: $HOTSPOT_CONN_NAME. Actualizando parámetros..."
  nmcli connection modify "$HOTSPOT_CONN_NAME"     802-11-wireless.ssid "$HOTSPOT_SSID"     802-11-wireless.mode ap     802-11-wireless.band bg     wifi-sec.key-mgmt wpa-psk     wifi-sec.psk "$HOTSPOT_PASSWORD"     ipv4.method shared     ipv4.addresses "$HOTSPOT_IP4"     ipv6.method ignore     connection.autoconnect yes     connection.autoconnect-priority 100
else
  log "Creando hotspot con NetworkManager..."
  nmcli device wifi hotspot     ifname "$HOTSPOT_IFACE"     con-name "$HOTSPOT_CONN_NAME"     ssid "$HOTSPOT_SSID"     password "$HOTSPOT_PASSWORD"
  nmcli connection modify "$HOTSPOT_CONN_NAME"     ipv4.method shared     ipv4.addresses "$HOTSPOT_IP4"     ipv6.method ignore     connection.autoconnect yes     connection.autoconnect-priority 100
fi

nmcli connection up "$HOTSPOT_CONN_NAME"
log "Hotspot activo. Conéctate a SSID: $HOTSPOT_SSID"
log "URL local: http://${HOTSPOT_IP4%/*}/"
