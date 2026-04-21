#!/bin/bash
# ==============================================================================
# ARGOS HUB — Script de control maestro
# ==============================================================================
# Este script te permite iniciar, detener y revisar el estado de todo el sistema
# ARGOS (backend en Python + frontend web en Node.js) desde un solo lugar.
# ==============================================================================

# Directorios absolutos para evitar problemas al correr desde systemd
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$PROJECT_DIR/logs"

# Archivos PID
BACKEND_PID_FILE="/tmp/argos_backend.pid"
FRONTEND_PID_FILE="/tmp/argos_frontend.pid"

# Asegurar que existe la carpeta de logs
mkdir -p "$LOG_DIR"

# Colores para la consola
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo_green() { echo -e "${GREEN}$1${NC}"; }
echo_yellow() { echo -e "${YELLOW}$1${NC}"; }
echo_red() { echo -e "${RED}$1${NC}"; }

# ---------------------------------------------------------
# FUNCIONES DE ARRANQUE
# ---------------------------------------------------------
start_backend() {
    if [ -f "$BACKEND_PID_FILE" ] && kill -0 $(cat "$BACKEND_PID_FILE") 2>/dev/null; then
        echo_yellow "El Backend (ARGOS Python) ya está en ejecución (PID: $(cat "$BACKEND_PID_FILE"))"
    else
        echo "Iniciando Backend (ARGOS)..."
        cd "$PROJECT_DIR/software" || exit 1
        
        # Activar entorno virtual si existe
        if [ -d ".venv" ]; then
            source .venv/bin/activate
        else
            echo_yellow "Advertencia: No se encontró entorno virtual (.venv). Ejecutando con python global."
        fi

        # Ejecutar en segundo plano con nohup
        nohup argos --mode hardware --config config/argos.yaml > "$LOG_DIR/backend.log" 2>&1 &
        local pid=$!
        echo $pid > "$BACKEND_PID_FILE"
        echo_green "Backend iniciado con éxito (PID: $pid)"
    fi
}

start_frontend() {
    if [ -f "$FRONTEND_PID_FILE" ] && kill -0 $(cat "$FRONTEND_PID_FILE") 2>/dev/null; then
        echo_yellow "El Frontend (Lovable-UI) ya está en ejecución (PID: $(cat "$FRONTEND_PID_FILE"))"
    else
        echo "Iniciando Frontend (Lovable-UI)..."
        cd "$PROJECT_DIR/Lovable-UI" || exit 1
        
        # Ejecutar en segundo plano. "-- --host" expone la app web en la red local
        nohup npm run dev -- --host > "$LOG_DIR/frontend.log" 2>&1 &
        local pid=$!
        echo $pid > "$FRONTEND_PID_FILE"
        echo_green "Frontend iniciado con éxito (PID: $pid). Disponible en la red."
    fi
}

start_all() {
    echo "====================================="
    echo " INICIANDO SISTEMA ARGOS COMPLETO"
    echo "====================================="
    start_backend
    start_frontend
    echo "====================================="
    echo_green "Sistema corriendo en segundo plano."
    echo "Para ver los logs en tiempo real, usa:"
    echo "  tail -f logs/backend.log"
    echo "  tail -f logs/frontend.log"
}

# ---------------------------------------------------------
# FUNCIONES DE DETENCIÓN
# ---------------------------------------------------------
stop_process() {
    local pid_file=$1
    local name=$2
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Deteniendo $name (PID: $pid)..."
            # Detenemos proceso padre
            kill "$pid" 2>/dev/null
            sleep 1
            # Matamos procesos hijos (importante para npm run dev -> vite)
            pkill -P "$pid" 2>/dev/null
            rm -f "$pid_file"
            echo_green "$name detenido."
        else
            rm -f "$pid_file"
        fi
    else
        echo_yellow "$name no está en ejecución."
    fi
}

stop_all() {
    echo "====================================="
    echo " DETENIENDO SISTEMA ARGOS"
    echo "====================================="
    stop_process "$BACKEND_PID_FILE" "Backend"
    stop_process "$FRONTEND_PID_FILE" "Frontend"
    
    # Seguro adicional (matar remanentes)
    pkill -f "argos --mode" 2>/dev/null
    pkill -f "vite" 2>/dev/null
    echo_green "Sistema completamente detenido."
}

# ---------------------------------------------------------
# FUNCIÓN DE ESTADO
# ---------------------------------------------------------
status_all() {
    echo "====================================="
    echo " ESTADO DEL SISTEMA ARGOS"
    echo "====================================="
    if [ -f "$BACKEND_PID_FILE" ] && kill -0 $(cat "$BACKEND_PID_FILE") 2>/dev/null; then
        echo_green "[✔] Backend (Python) está CORRIENDO (PID: $(cat "$BACKEND_PID_FILE"))"
    else
        echo_red "[✖] Backend (Python) está DETENIDO"
    fi

    if [ -f "$FRONTEND_PID_FILE" ] && kill -0 $(cat "$FRONTEND_PID_FILE") 2>/dev/null; then
        echo_green "[✔] Frontend (Web)   está CORRIENDO (PID: $(cat "$FRONTEND_PID_FILE"))"
    else
        echo_red "[✖] Frontend (Web)   está DETENIDO"
    fi
}

# ---------------------------------------------------------
# INSTALACIÓN EN ARRANQUE (SYSTEMD)
# ---------------------------------------------------------
install_service() {
    echo "Configurando ARGOS para ejecutarse en el arranque de la Raspberry Pi..."
    local service_file="/etc/systemd/system/argos-hub.service"
    
    local USER_NAME=$(whoami)
    if [ "$USER_NAME" == "root" ]; then
        USER_NAME=$SUDO_USER
    fi

    sudo bash -c "cat > $service_file" <<EOL
[Unit]
Description=ARGOS Hub - Sistema de control de cuevas
After=network.target

[Service]
Type=forking
User=$USER_NAME
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/argos-hub.sh start
ExecStop=$PROJECT_DIR/argos-hub.sh stop
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

    sudo systemctl daemon-reload
    sudo systemctl enable argos-hub.service
    echo_green "Servicio instalado y activado."
    echo "ARGOS iniciará automáticamente cuando conectes la Raspberry Pi a la corriente."
    echo "Puedes gestionar el servicio con: sudo systemctl status argos-hub"
}

# ---------------------------------------------------------
# ROUTER DE COMANDOS
# ---------------------------------------------------------
case "$1" in
    start)
        start_all
        ;;
    stop)
        stop_all
        ;;
    restart)
        stop_all
        sleep 2
        start_all
        ;;
    status)
        status_all
        ;;
    install)
        install_service
        ;;
    *)
        echo "Uso: ./argos-hub.sh {start|stop|restart|status|install}"
        echo ""
        echo "Comandos:"
        echo "  start   - Inicia todo el sistema en segundo plano"
        echo "  stop    - Detiene todo el sistema"
        echo "  restart - Reinicia el sistema"
        echo "  status  - Muestra si los componentes están corriendo"
        echo "  install - Configura el sistema para iniciar solo al conectar la Pi"
        exit 1
        ;;
esac
exit 0
