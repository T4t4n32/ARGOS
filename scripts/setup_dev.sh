#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  ARGOS — Setup de Entornos de Desarrollo
# ═══════════════════════════════════════════════════════════════════════════
#  Ejecutar desde la raíz del repositorio:
#    chmod +x scripts/setup_dev.sh && ./scripts/setup_dev.sh
#
#  Crea automáticamente:
#    1. Entorno virtual de Python (software/.venv) con dependencias
#    2. node_modules del frontend (Lovable-UI/)
# ═══════════════════════════════════════════════════════════════════════════

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
info() { echo -e "${CYAN}→  $1${NC}"; }
fail() { echo -e "${RED}❌ $1${NC}"; exit 1; }

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║       ARGOS — Setup de Entornos de Desarrollo    ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ─── 1. Python Backend ──────────────────────────────────────────────────────
info "Configurando entorno Python (software/.venv)..."

VENV_DIR="$ROOT_DIR/software/.venv"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    ok "Entorno virtual creado en software/.venv"
else
    ok "Entorno virtual ya existe en software/.venv"
fi

# Activar e instalar
source "$VENV_DIR/bin/activate"
info "Instalando dependencias de Python..."
pip install --upgrade pip -q
pip install -r "$ROOT_DIR/software/requirements.txt" -q 2>/dev/null || warn "Algunas dependencias de hardware no están disponibles (normal en x86)"
pip install websockets -q
ok "Dependencias de Python instaladas"
deactivate

# ─── 2. Frontend (Lovable-UI) ───────────────────────────────────────────────
info "Configurando frontend (Lovable-UI/)..."

LOVABLE_DIR="$ROOT_DIR/Lovable-UI"

if [ ! -d "$LOVABLE_DIR" ]; then
    fail "No se encontró la carpeta Lovable-UI/"
fi

# Detectar gestor de paquetes
if command -v bun &>/dev/null; then
    PKG_MGR="bun"
elif command -v npm &>/dev/null; then
    PKG_MGR="npm"
else
    fail "No se encontró npm ni bun. Instala Node.js primero."
fi

info "Usando $PKG_MGR para instalar node_modules..."
cd "$LOVABLE_DIR"

if [ "$PKG_MGR" = "bun" ]; then
    bun install --frozen-lockfile 2>/dev/null || bun install
else
    npm install
fi
ok "Dependencias de frontend instaladas ($PKG_MGR)"

# ─── Resumen ────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║                 ¡Setup completo!                  ║"
echo "╠══════════════════════════════════════════════════╣"
echo "║                                                    ║"
echo "║  Para probar ARGOS:                                ║"
echo "║                                                    ║"
echo "║  Terminal 1 (Backend simulador):                   ║"
echo "║    cd software                                     ║"
echo "║    source .venv/bin/activate                       ║"
echo "║    python src/base_station_server.py               ║"
echo "║                                                    ║"
echo "║  Terminal 2 (Frontend):                            ║"
echo "║    cd Lovable-UI                                   ║"
echo "║    $PKG_MGR run dev                                ║"
echo "║                                                    ║"
echo "║  Abrir: http://localhost:5173/dashboard            ║"
echo "║                                                    ║"
echo "╚══════════════════════════════════════════════════╝"
