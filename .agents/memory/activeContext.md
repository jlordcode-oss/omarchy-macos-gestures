# Active Context: macOS Gestures in Omarchy

## Sprint Actual
Corrección de disparadores de gestos verticales de 3 dedos (Mission Control y App Exposé) y ajuste de información de gestos de 4 dedos tras validación en hardware con Hyprland 0.56.2.

## Foco Inmediato
- Se identificó mediante ingeniería inversa del binario `/usr/bin/Hyprland` que Hyprland 0.56.2 parsea únicamente `direction = "vertical"` para swipes verticales (no acepta subdirecciones discretas como `"up"` o `"down"` para el registro de swipe).
- Se implementó en `scripts/macos_gestures_manager.py` el registro unificado `direction = "vertical"` con `disable_inhibit = true` y acumulador de `delta.y` en `action = { start, update, finish }` para distinguir con precisión `delta.y < -10` (Swipe UP -> Mission Control) y `delta.y > 10` (Swipe DOWN -> App Exposé).
- Se actualizó la información de los gestos de 4 dedos (Launchpad se activa al expandir/separar 4 dedos y Mostrar Escritorio al pellizcar hacia adentro), manteniendo los bindings subyacentes intactos conforme al comportamiento validado por el usuario.
- Sincronizados y verificados `~/.config/hypr/macos_gestures.lua` y `~/.config/omarchy/plugins/io.github.devmercenario.macos-gestures/`.
- Tests unitarios y validación de manifiesto pasando al 100% (`./tests/run`).

## Estado Actual
- **Estado**: FIN
- **Repositorio Público**: https://github.com/jlordcode-oss/omarchy-macos-gestures
- **Bloqueos**: Ninguno. Todos los gestos (3 dedos horizontal, 3 dedos vertical arriba/abajo con tracking direccional, y 4 dedos expandir/pellizcar) completamente verificados y sin errores de configuración.
