# Active Context: macOS Gestures in Omarchy

## Sprint Actual
Diagnóstico exhaustivo y resolución de disparadores de gestos en hardware (Hyprland 0.56.2 + Omarchy 4 Quattro).

## Foco Inmediato
- Diagnóstico mediante ingeniería inversa del binario `/usr/bin/Hyprland` y llamadas D-Bus/IPC de Quickshell.
- Corregida la especificación de `action` en Lua (debe ser tabla `{ finish = function() ... end }` y no función pura).
- Corregida la dirección de gestos pinch: `pinchin` y `pinchout` en vez de `pinch`.
- Implementado `disable_inhibit = true` para evitar que ventanas activas supriman gestos de trackpad.
- Actualizados los dispatchers en Lua para `Hyprland.dispatch` (`hl.dsp.focus` y `hl.dsp.workspace.toggle_special()`).
- Eliminadas duplicaciones en `~/.config/hypr/hyprland.lua` y añadido busteo de caché de `package.loaded`.
- Suite de pruebas validada al 100% y cambios subidos a GitHub.

## Estado Actual
- **Estado**: FIN
- **Repositorio Público**: https://github.com/jlordcode-oss/omarchy-macos-gestures
- **Bloqueos**: Ninguno. Todos los gestos (3 dedos horizontal, 3 dedos arriba, 3 dedos abajo, 4 dedos pellizco hacia dentro y 4 dedos pellizco hacia fuera) configurados y operativos.
