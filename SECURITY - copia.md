# Política de Seguridad — ARGOS

La seguridad es el pilar innegociable del proyecto ARGOS. Al tratarse de un ecosistema que integra electrónica de hardware, sistemas mecánicos, baterías y software de telemetría, esta política abarca de manera integral tanto la seguridad física e industrial como las mejores prácticas en el desarrollo de software.

## 1. Seguridad Física y Operativa

ARGOS es un prototipo de ingeniería con fines educativos y de investigación. **Bajo ninguna circunstancia pretende reemplazar los protocolos profesionales, normativas certificadas o herramientas industriales para operaciones de rescate y exploración en cuevas reales.**

### Directrices Obligatorias
- **Entornos de Prueba Controlados:** Todas las validaciones físicas, pruebas de recorrido y lecturas de sensores deben realizarse de forma exclusiva en escenarios simulados y supervisados. El despliegue del prototipo V1 en sistemas de cuevas reales no está autorizado.
- **Gestión de Energía e Integridad de Baterías:** Las operaciones que involucren baterías de polímero de litio (LiPo/Li-ion) y el control de actuadores deben ejecutarse respetando especificaciones eléctricas. Se requiere supervisión térmica y la capacidad de realizar desconexiones de emergencia del chasis.
- **Transparencia en la Lectura de Sensores:** El sensor MQ-135, integrado en el módulo de calidad de aire, actúa como un **indicador cualitativo (proxy)** para la detección de gases nocivos. **No posee la capacidad de medir concentraciones de oxígeno** y no debe utilizarse como instrumento de certificación respiratoria. Las lecturas de seguridad generadas por el sistema son experimentales.

## 2. Seguridad de Software y Repositorio

### Reporte de Vulnerabilidades y Fallos Críticos
Si identificas un fallo de software, vulnerabilidad de datos o un problema de lógica de control que comprometa la integridad del sistema o del hardware (ej. saturación de motores, ciclos de reinicio de la Raspberry Pi):

**Por favor, no crees un *Issue* público de forma inmediata.**

Notifica directamente a los mentores técnicos del equipo CALIBOTS KAIROS a través de canales privados. El equipo evaluará la severidad del reporte, detendrá las operaciones en campo si es pertinente, e implementará una corrección que se documentará formalmente en el `CHANGELOG.md`.

### Gestión de Información Confidencial
- Queda prohibida la publicación de credenciales, claves de cifrado, archivos `.env` o tokens de bases de datos. El uso del archivo `.gitignore` configurado en la raíz es estricto.
- Se debe asegurar que los registros (logs) públicos subidos al repositorio como evidencia no incluyan PII (Información de Identificación Personal) o detalles privados operativos del entorno de desarrollo.

## 3. Protocolo de Respuesta a Incidentes
En caso de registrarse un comportamiento anómalo que ponga en riesgo la integridad del prototipo o sus operadores:
1. **Corte de Energía:** Desconectar inmediatamente las fuentes de alimentación del sistema.
2. **Aseguramiento:** Evacuar el área de prueba o asegurar el hardware afectado.
3. **Registro de Bitácora:** Documentar el contexto del fallo (logs de consola, lectura de temperatura, fotografías).
4. **Análisis Forense:** Analizar los datos junto a los mentores y resolver el fallo en el repositorio antes de reanudar operaciones.