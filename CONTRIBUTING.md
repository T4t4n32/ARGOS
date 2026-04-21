# Guía de Contribución para ARGOS

¡Gracias por tu interés en contribuir al proyecto ARGOS! Como iniciativa del equipo CALIBOTS KAIROS, valoramos profundamente las contribuciones que mejoren la estabilidad, la seguridad y la precisión de nuestro sistema de monitoreo autónomo.

Esta guía establece el estándar profesional y el flujo de trabajo requerido para colaborar en este repositorio.

## 1. Principios Fundamentales

Toda contribución al proyecto ARGOS debe alinearse con nuestros principios básicos de ingeniería:
- **Seguridad Operativa:** Ningún cambio en hardware o software debe comprometer la seguridad física del prototipo ni de sus operadores.
- **Integridad de la Evidencia:** Todo desarrollo o validación debe sustentarse en datos verificables y pruebas documentadas.
- **Arquitectura Modular:** El código debe respetar la separación de responsabilidades definida en el sistema (sensores, comunicación, visión, decisión).

## 2. Flujo de Trabajo (Git Workflow)

Utilizamos un modelo de ramas estructurado para mantener limpio el historial del repositorio.

### Nomenclatura de Ramas
- `feature/<nombre>`: Para nuevas funcionalidades (ej. `feature/lora-telemetry`).
- `fix/<nombre>`: Para corrección de errores (ej. `fix/vl53l0x-timeout`).
- `docs/<nombre>`: Para actualizaciones en la documentación técnica o académica.
- `hardware/<nombre>`: Para modificaciones en esquemas, BOM o diseños 3D.
- `refactor/<nombre>`: Para optimización de código sin cambio de funcionalidades.

### Estilo de Commits
Se recomienda seguir la convención de *Conventional Commits*. Los mensajes deben ser descriptivos:
- `feat: implementa codificador JSON para alertas LoRa`
- `fix: corrige lógica de reintentos en el bus I2C para BME280`
- `docs: actualiza el diagrama de arquitectura del sistema`

## 3. Proceso de Pull Request (PR)

Para asegurar la calidad y estabilidad, cada Pull Request será sometido a revisión. Un PR ideal debe incluir:

1. **Descripción clara:** Especificar qué problema resuelve y cómo se implementó la solución.
2. **Evidencia de Pruebas:** Todo cambio funcional debe acompañarse de evidencia real. Las suposiciones sin sustento no son válidas.
   - *Evidencias válidas:* Logs de consola, archivos CSV/JSON resultantes, fotos del montaje, capturas de métricas.
3. **Checklist de Calidad:**
   - [ ] El código ha sido probado y ejecuta correctamente en modo simulado o en hardware.
   - [ ] No rompe la secuencia de arranque principal.
   - [ ] No incluye información sensible (credenciales, rutas locales absolutas, `.env`).
   - [ ] La configuración utiliza `argos.yaml` (sin *hardcoding* de pines o variables dinámicas).
   - [ ] La documentación relacionada fue actualizada.

## 4. Estructura del Repositorio

Para mantener el orden, asegúrate de colocar tus aportes en el directorio correspondiente:
- **`software/src/argos_app/`**: Código fuente principal de la aplicación Python.
- **`firmware/`**: Código embebido (C/C++) para los módulos microcontrolados (LoRa Tx/Rx).
- **`hardware/`**: Lista de materiales (BOM), diagramas de conexión y especificaciones.
- **`docs/`**: Documentación técnica, académica y plantillas operativas.
- **`Lovable-UI/`**: Frontend y dashboard web.
- **`tests/`**: Suite de pruebas unitarias y de integración.

## 5. Cambios Críticos

Ciertas áreas del proyecto requieren una revisión más exhaustiva por parte de los administradores y mentores debido a sus implicaciones directas en la seguridad o funcionalidad del núcleo:
- Sistemas de alimentación y distribución de energía.
- Control directo de motores y actuadores (señales PWM, puentes H).
- Modificaciones en los umbrales de seguridad y el motor de decisiones.
- Protocolos de bajo nivel en las comunicaciones LoRa.

Agradecemos tu esfuerzo por mantener altos estándares de calidad, seguridad y documentación en ARGOS.