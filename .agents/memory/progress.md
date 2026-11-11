# Progress: macOS Gestures in Omarchy

## Hitos
- [x] **Investigación de Viabilidad y Capacidades**:
  - [x] Verificación de hardware de touchpad (`dll0945:00-06cb:cde6-touchpad`) y eventos libinput.
  - [x] Análisis de símbolos y capacidades de Hyprland 0.56 (`hl.gesture`, `CWorkspaceSwipeGesture`, `CSpecialWorkspaceGesture`, `CLuaFunctionGesture`, `drag_3fg`).
  - [x] Identificación de puntos de integración en Omarchy (Quickshell, `omarchy.dock apps`, `notifications.showHistory`).
- [x] **Planning de Arquitectura**:
  - [x] Matriz de equivalencia de gestos macOS.
  - [x] Especificación de perfiles `standard` y `drag3fg`.
  - [x] Especificación de interfaz IPC y CLI.
- [ ] **Desarrollo del Plugin**:
  - [x] Scaffolding inicial con `new_plugin.py` y validación de manifest.
  - [ ] Implementación de `Service.qml` (orquestación, generación de config Lua, IPC).
  - [ ] Implementación de `Overlay.qml` (Mission Control visual completo con miniaturas de ventanas).
  - [ ] Generador de `macos_gestures.lua` para Hyprland.
  - [ ] Implementación de la utilidad CLI `bin/omarchy-macos-gestures`.
  - [ ] Integración en `~/.config/hypr/hyprland.lua`.
- [ ] **Validación y QA**:
  - [ ] Ejecución de suite de tests `./tests/run`.
  - [ ] Validación con `omarchy plugin validate`.
  - [ ] Validación de configuración de Hyprland con `hyprctl configerrors`.
  - [ ] Despliegue en `~/.config/omarchy/plugins/io.github.devmercenario.macos-gestures`.
