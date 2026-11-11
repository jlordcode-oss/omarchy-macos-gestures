# Progress: macOS Gestures in Omarchy

## Hitos
- [x] **Investigación de Viabilidad y Capacidades**:
  - [x] Verificación de hardware de touchpad (`dll0945:00-06cb:cde6-touchpad`) y eventos libinput/Aquamarine.
  - [x] Análisis de símbolos y capacidades de Hyprland 0.56 (`hl.gesture`, `CWorkspaceSwipeGesture`, `CSpecialWorkspaceGesture`, `CLuaFunctionGesture`, `drag_3fg`).
  - [x] Identificación de puntos de integración en Omarchy (Quickshell, `omarchy.dock apps`, `notifications.showHistory`).
- [x] **Planning de Arquitectura**:
  - [x] Matriz de equivalencia de gestos macOS.
  - [x] Especificación de perfiles `standard` y `drag3fg`.
  - [x] Especificación de interfaz IPC y CLI.
- [x] **Desarrollo del Plugin (`io.github.devmercenario.macos-gestures`)**:
  - [x] Scaffolding inicial con `new_plugin.py` y validación de manifest.
  - [x] Implementación de `Service.qml` (orquestación, generación de config Lua, IPC).
  - [x] Implementación de `Overlay.qml` (Mission Control visual completo con miniaturas de ventanas).
  - [x] Generador de `macos_gestures.lua` para Hyprland con soporte `standard` y `drag3fg`.
  - [x] Implementación de la utilidad CLI `bin/omarchy-macos-gestures`.
  - [x] Integración segura en `~/.config/hypr/hyprland.lua`.
- [x] **Validación y QA**:
  - [x] Ejecución de suite de tests `./tests/run` (100% OK).
  - [x] Validación con `omarchy plugin validate` (0 errores).
  - [x] Validación de configuración de Hyprland con `hyprctl configerrors` (0 errores).
  - [x] Despliegue e instalación en `~/.config/omarchy/plugins/io.github.devmercenario.macos-gestures` y verificación de IPC activo (`running`).
- [x] **Documentación y Publicación en GitHub**:
  - [x] Redacción de guía exhaustiva en `docs/GESTURES_GUIDE.md` con tuning de hardware y troubleshooting.
  - [x] Actualización de `README.md` con enlaces arquitectónicos y guía de uso.
  - [x] Creación del repositorio público en GitHub: `https://github.com/jlordcode-oss/omarchy-macos-gestures`.
  - [x] Push de rama `main` y sincronización con origin.
