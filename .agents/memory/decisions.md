# Architecture Decision Records (ADRs)

## ADR-001: Arquitectura Híbrida (Quickshell Service/Overlay + Módulo Hyprland Lua)
- **Contexto**: Hyprland 0.56 dispone de un motor de gestos en C++ expuesto mediante `hl.gesture` y directivas en Lua. A su vez, Omarchy utiliza Quickshell para sus barras, menús, dock y overlays.
- **Decisión**: Implementar una arquitectura híbrida donde el plugin de Quickshell (`Service.qml`) actúa como orquestador del estado y proveedor del overlay visual de Mission Control (`Overlay.qml`), mientras genera y sincroniza la configuración de bajo nivel en `~/.config/hypr/macos_gestures.lua`.
- **Justificación**: Proporciona el máximo rendimiento (cero latencia de hardware) y una interfaz de usuario integrada que respeta los temas y diseño de Omarchy.

## ADR-002: Manejo de Perfiles "Standard" vs "Drag3fg" (Resolución de Conflictos)
- **Contexto**: El gesto de "Three-finger drag" (arrastrar ventanas/selección con 3 dedos) intercepta los eventos de 3 dedos a nivel de libinput. Si está activo, el swipe de 3 dedos para cambiar escritorios o abrir Mission Control se ve interferido.
- **Decisión**: Replicar la solución de macOS:
  - En perfil `standard`: Swipes de 3 dedos para Workspaces y Mission Control; `drag_3fg = 0`.
  - En perfil `drag3fg`: `drag_3fg = 1` en touchpad; los swipes de Workspaces y Mission Control se elevan a 4 dedos.
- **Justificación**: Mantiene una ergonomía idéntica a la de macOS sin colisiones de entrada.

## ADR-003: Reutilización de Componentes del Ecosistema Omarchy
- **Contexto**: Omarchy ya cuenta con Launchpad (el `AppGrid` de `omarchy.dock apps`) y Centro de Notificaciones (`notifications.showHistory`).
- **Decisión**: Reutilizar directamente estos servicios existentes a través de IPC y comandos documentados en lugar de reinventar una cuadrícula de aplicaciones o centro de notificaciones duplicado.
- **Justificación**: Cumple estrictamente con la Regla Sagrada 1 (Reutilización sobre creación desde cero) y mantiene la coherencia del sistema operativo.


## ADR-004: Corrección de Enlaces de Gestos en Hyprland 0.56.2 y Omarchy 4
- **Contexto**: Tras las pruebas iniciales en hardware, sólo funcionaba el swipe horizontal de 3 dedos; el swipe vertical y los pellizcos no disparaban.
- **Hallazgos de Ingeniería Inversa en `/usr/bin/Hyprland`**:
  1. `CLuaFunctionGesture` requiere que el campo `action` sea una tabla conteniendo al menos una de las funciones `start`, `update`, `end` o `finish` (pasar una función pura como `action = function()` es rechazado por el parser C++).
  2. En libinput/Hyprland, el evento físico de pellizco sólo emite `PINCH_IN` (8) o `PINCH_OUT` (9); registrar un gesto con dirección genérica `pinch` (7) nunca entra en la condición de coincidencia en `CTrackpadGestures::gestureUpdate`.
  3. `disable_inhibit = true` es indispensable para evitar que ventanas activas inhiban los gestos de trackpad.
  4. Los comandos de dispatch en Hyprland 0.56 operan sobre el espacio de nombres Lua (`hl.dsp.focus` y `hl.dsp.workspace.toggle_special()`).
- **Decisión**:
  - Dividir los gestos de 4 dedos en `direction = "pinchin"` y `direction = "pinchout"` con `{ finish = function() ... end }`.
  - Configurar Mission Control y App Exposé con tablas `{ finish = function() ... end }` y `disable_inhibit = true`.
  - Asegurar la invalidación de caché de Lua en `hyprland.lua` (`package.loaded["hypr.macos_gestures"] = nil`) para recargas sin reinicio del compositor.
- **Justificación**: Garantiza la ejecución determinista de los 5 gestos de macOS con latencia cero en Hyprland.

## ADR-005: Unificación de Gestos Verticales en direction = "vertical" con Tracking Direccional
- **Contexto**: Pruebas de usuario en hardware físico revelaron que los swipes horizontales de 3 dedos y los gestos de 4 dedos funcionaban, pero los swipes verticales de 3 dedos (arriba para Mission Control y abajo para App Exposé) no disparaban.
- **Hallazgos de Ingeniería Inversa en `/usr/bin/Hyprland` (0.56.2)**:
  1. En `CTrackpadGestures::dirForString`, Hyprland sólo admite como direcciones de swipe `"horizontal"` (7) y `"vertical"` (6). Las cadenas `"up"` y `"down"` no existen en la tabla de direcciones de swipe de Hyprland o provocan shadowing/no disparan.
  2. Para swipes verticales, Hyprland evalúa si `abs(dy) >= abs(dx)` y `abs(dy) >= 5.0`. Al coincidir, busca en su lista de gestos uno cuya dirección coincida con `VERTICAL`.
  3. La tabla de retorno en `finish` entrega la dirección configurada del gesto (`VERTICAL`), por lo que no es posible distinguir UP de DOWN únicamente en `finish`.
- **Decisión**:
  - Unificar la captura de gestos verticales en una sola directiva `direction = "vertical"` con `disable_inhibit = true`.
  - Implementar callbacks `start`, `update` y `finish` en Lua: acumular el vector `delta.y` durante el swipe y en `finish` evaluar `vert_dy < -10` (Swipe UP -> Mission Control) y `vert_dy > 10` (Swipe DOWN -> App Exposé).
  - Mantener los bindings de 4 dedos (`pinchin` y `pinchout`) tal cual están y actualizar la documentación e información CLI para reflejar que la expansión (spread) abre Launchpad.
- **Justificación**: Proporciona detección fluida, robusta e inercial de ambos gestos verticales sin micro-bloqueos ni colisiones de configuración en Hyprland.
