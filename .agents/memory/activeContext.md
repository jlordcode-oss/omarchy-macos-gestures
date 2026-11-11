# Active Context: macOS Gestures in Omarchy

## Sprint Actual
Investigación profunda, planning de arquitectura y desarrollo del plugin completo `io.github.devmercenario.macos-gestures` para Omarchy.

## Foco Inmediato
1. Completar la documentación formal de investigación y planning técnico.
2. Implementar `Service.qml` con el manejador IPC, generación reactiva de `macos_gestures.lua` y control de estado.
3. Implementar `Overlay.qml` (Mission Control visual completo con lista de ventanas, previsualización, búsqueda y foco).
4. Implementar el script CLI `bin/omarchy-macos-gestures` para control de usuario.
5. Crear tests de verificación y enlace en `~/.config/omarchy/plugins/`.
6. Enlazar el módulo en `~/.config/hypr/hyprland.lua` y validar con `hyprctl configerrors`.

## Estado Actual
- **Estado**: BUILD
- **Bloqueos**: Ninguno. Hardware y software compatibles al 100%.
