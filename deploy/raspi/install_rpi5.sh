#!/bin/bash
# ==============================================================================
# ARGOS — Instalador Automatizado para Raspberry Pi 5
# ==============================================================================
# Este script instalará y configurará todas las dependencias del sistema, 
# activará las interfaces de hardware (I2C/SPI) y configurará los entornos
# de Python (Backend) y Bun/Node.js (Frontend) necesarios para ARGOS.
# ==============================================================================

set -e # Detener la ejecución si ocurre algún error crítico

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colores para salida en consola
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo_step() { echo -e "\n${CYAN}>>> $1${NC}"; }
echo_success() { echo -e "${GREEN}✔ $1${NC}"; }
echo_warn() { echo -e "${YELLOW}⚠ $1${NC}"; }

echo_step "Fase 1: Preparación del Sistema (Requiere permisos de sudo)"
# ---------------------------------------------------------
sudo apt-get update -y
sudo apt-get upgrade -y

echo_step "Instalando paquetes básicos de sistema y compilación..."
sudo apt-get install -y \
    python3-venv python3-pip python3-dev \
    git curl build-essential wget unzip

echo_step "Instalando herramientas de Hardware (I2C/SPI/Serial)..."
sudo apt-get install -y \
    i2c-tools libi2c-dev

echo_step "Instalando dependencias para Visión Computacional (OpenCV)..."
sudo apt-get install -y \
    libgl1-mesa-glx libglib2.0-0 libcamera-dev

echo_success "Paquetes de sistema instalados correctamente."


echo_step "Fase 2: Configuración de Hardware de la Raspberry Pi"
# ---------------------------------------------------------
# Habilitar I2C y SPI usando la utilidad non-interactive de raspi-config
if command -v raspi-config > /dev/null; then
    echo "Habilitando interfaz I2C..."
    sudo raspi-config nonint do_i2c 0
    echo "Habilitando interfaz SPI..."
    sudo raspi-config nonint do_spi 0
    echo_success "Interfaces I2C y SPI habilitadas."
else
    echo_warn "No se encontró raspi-config. Debes habilitar I2C y SPI manualmente."
fi

# Agregar el usuario actual a grupos necesarios (dialout para UART/USB LiDAR, i2c para sensores)
USER_NAME=$(whoami)
if [ "$USER_NAME" == "root" ] && [ -n "$SUDO_USER" ]; then
    USER_NAME=$SUDO_USER
fi

echo "Asegurando permisos de hardware para el usuario: $USER_NAME"
sudo usermod -a -G i2c,dialout,video $USER_NAME || true
echo_success "Permisos de usuario configurados."


echo_step "Fase 3: Configuración del Entorno Python (Backend ARGOS)"
# ---------------------------------------------------------
cd "$PROJECT_DIR/software"

if [ ! -d ".venv" ]; then
    echo "Creando entorno virtual de Python..."
    python3 -m venv .venv
else
    echo "Entorno virtual ya existente."
fi

# Activar e instalar
source .venv/bin/activate
echo "Actualizando pip..."
pip install --upgrade pip

echo "Instalando dependencias desde requirements.txt..."
pip install -r requirements.txt

echo "Instalando el paquete argos_app en modo desarrollo..."
pip install -e .

# Configurar archivo YAML si no existe
if [ ! -f "config/argos.yaml" ] && [ -f "config/argos.example.yaml" ]; then
    echo "Creando archivo de configuración inicial (argos.yaml)..."
    cp config/argos.example.yaml config/argos.yaml
fi
deactivate
echo_success "Entorno Python configurado con éxito."


echo_step "Fase 4: Configuración del Entorno Frontend (Lovable-UI)"
# ---------------------------------------------------------
cd "$PROJECT_DIR/Lovable-UI"

# Instalar Bun si no está presente
if ! command -v bun &> /dev/null; then
    echo "Bun no encontrado. Instalando Bun (Gestor ultrarrápido para JS)..."
    curl -fsSL https://bun.sh/install | bash
    # Añadir al path temporalmente para esta sesión
    export PATH="$HOME/.bun/bin:$PATH"
fi

if command -v bun &> /dev/null; then
    echo "Instalando dependencias de Node.js con Bun..."
    bun install
    echo_success "Dependencias del frontend instaladas con éxito."
else
    echo_warn "No se pudo instalar Bun. Por favor instala las dependencias de Lovable-UI manualmente con npm."
fi


echo_step "Fase 5: Configuración de Permisos Finales"
# ---------------------------------------------------------
cd "$PROJECT_DIR"
if [ -f "argos-hub.sh" ]; then
    chmod +x argos-hub.sh
    echo_success "Permisos de ejecución otorgados a argos-hub.sh."
fi

echo_step "¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
echo -e "\n${GREEN}El ecosistema de ARGOS está listo para operar en tu Raspberry Pi 5.${NC}"
echo -e "Es recomendable que ${YELLOW}reinicies la Raspberry Pi${NC} para que los cambios de I2C/SPI y grupos de usuarios surtan efecto."
echo -e "\nSi deseas que ARGOS se ejecute automáticamente al arrancar, corre:"
echo -e "  ${CYAN}./argos-hub.sh install${NC}\n"
