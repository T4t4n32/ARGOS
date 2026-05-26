# Manual de Operación: ARGOS Hub (`argos-hub.sh`)

## 1. ¿Qué es ARGOS Hub?

`argos-hub.sh` es el script maestro de control diseñado específicamente para la Raspberry Pi del proyecto ARGOS. Su propósito es simplificar la orquestación del sistema completo.

En lugar de tener que abrir múltiples terminales para activar entornos virtuales, iniciar el código en Python (sensores/LoRa) y luego iniciar el servidor web de Node.js (Lovable-UI), este script unifica todo bajo un solo panel de comandos.

## 2. Permisos Iniciales

Si acabas de clonar el repositorio o el archivo no te permite ejecutarse, asegúrate de otorgarle permisos de ejecución:

```bash
chmod +x argos-hub.sh
```

## 3. Comandos de Operación Manual

Ejecuta el script desde la raíz del proyecto (`/home/tu_usuario/.../ARGOS/`).

| Comando | Acción | Descripción |
| :--- | :--- | :--- |
| `./argos-hub.sh start` | **Iniciar** | Arranca el Backend (Python) y el Frontend (Web) en segundo plano. |
| `./argos-hub.sh stop` | **Detener** | Cierra todos los procesos de forma limpia y libera los puertos (Vite, Python). |
| `./argos-hub.sh restart` | **Reiniciar** | Ejecuta un `stop` seguido de un `start`. Útil si cambiaste código. |
| `./argos-hub.sh status` | **Estado** | Muestra de forma visual `[✔]` o `[✖]` si los subsistemas están corriendo. |

## 4. Gestión de Registros (Logs)

Al usar `./argos-hub.sh start`, los procesos se van al fondo (background). Esto significa que tu terminal queda libre para que sigas trabajando.

Toda la información que normalmente saldría en pantalla (errores, lecturas de sensores, IPs del servidor web) se guarda automáticamente en la carpeta `logs/`.

**Para ver qué está pasando en tiempo real:**

- **Logs de los sensores y LoRa (Backend Python):**
  ```bash
  tail -f logs/backend.log
  ```
  
- **Logs de la interfaz web y Node.js (Frontend Vite):**
  ```bash
  tail -f logs/frontend.log
  ```

*(Presiona `Ctrl + C` para salir de la vista del log; esto NO detendrá el sistema).*

## 5. Automatización: Arranque con la Raspberry Pi

Una vez que las pruebas en laboratorio estén terminadas y quieras llevar el prototipo a su validación final, no tendrás una pantalla ni teclado conectados al robot. El sistema debe arrancar solo.

Para configurar esto, ejecuta:

```bash
./argos-hub.sh install
```

### ¿Qué hace exactamente este comando?
1. Crea un archivo oficial de servicio en `/etc/systemd/system/argos-hub.service`.
2. Le dice a la Raspberry Pi que, al recibir corriente y cargar el sistema, debe ejecutar `./argos-hub.sh start`.
3. Activa un vigilante: Si por un error crítico de I2C o memoria el script en Python falla y se cierra, *systemd* lo detectará e intentará revivir todo el sistema pasados 10 segundos.

**Comandos útiles de systemd:**
- Ver el estado del servicio automático: `sudo systemctl status argos-hub`
- Desactivar el auto-arranque: `sudo systemctl disable argos-hub`

## 6. Solución de Problemas Frecuentes (Troubleshooting)

**Problema:** Ejecuto `start` pero el Frontend marca `[✖]` en `status`.
**Causa probable:** El puerto `5173` (usado por Vite) se quedó bloqueado por una ejecución anterior mal cerrada.
**Solución:** Ejecuta `./argos-hub.sh stop` para limpiar los procesos. Si persiste, el script tiene un seguro interno: matará remanentes con `pkill -f "vite"`.

**Problema:** El log del backend dice "No module named argos_app".
**Causa probable:** El script no pudo encontrar la carpeta `.venv`. Asegúrate de haber ejecutado `python3 -m venv .venv` dentro de la carpeta `software/` y de haber instalado los requerimientos con `pip install .` como dicta el `README.md`.

**Problema:** Al hacer `install` me pide contraseña.
**Solución:** Es el comportamiento esperado. Crear servicios de auto-arranque modifica el sistema operativo (en `/etc/systemd/`), por lo que el script usa `sudo` internamente y requiere privilegios de administrador.
