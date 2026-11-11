# System Patterns: macOS Gestures Architecture

## Arquitectura del Sistema

```
[ Touchpad Hardware (libinput / Aquamarine) ]
                     │
                     ▼
             [ Hyprland 0.56 ]
  ├── CTrackpadGestures (hl.gesture)
  │    ├── CWorkspaceSwipeGesture (1:1 Horizontal Workspace Tracking)
  │    ├── CSpecialWorkspaceGesture (Show Desktop / Special Toggle)
  │    └── CLuaFunctionGesture (Callbacks Lua hacia Shell / IPC)
  │
  ├── Lua Config: ~/.config/hypr/macos_gestures.lua
  │    ├── Configuración de input.touchpad (natural_scroll, clickfinger, drag_3fg)
  │    └── Definición de gestos de 3 y 4 dedos
  │
  ▼
[ Omarchy Quattro Shell (Quickshell / Qt 6 QML) ]
  ├── io.github.devmercenario.macos-gestures
  │    ├── Service.qml (IpcHandler, estado, generador de config Lua)
  │    └── Overlay.qml (MissionControl.qml: OverlayWindow fullscreen, ventanas, preview)
  │
  ├── Integración con Primeros Grupos:
  │    ├── omarchy.dock apps (Launchpad)
  │    └── notifications.showHistory (Centro de Notificaciones)
  │
  ▼
[ CLI & Tooling ]
  └── bin/omarchy-macos-gestures (Gestión de modos, recarga, estado)
```

## Patrones de Diseño
1. **Separación de Responsabilidades**:
   - Hyprland maneja los eventos de hardware de bajo nivel y la física de arrastre/swiping.
   - Quickshell maneja la capa gráfica de alto nivel (Mission Control, Launchpad, feedback visual).
   - El plugin enlaza ambos mundos mediante `IpcHandler` e inyección de configuración Lua modular.
2. **Fail-Safe & Idempotencia**:
   - `hyprland.lua` incluye `pcall(require, "hypr.macos_gestures")`. Si el módulo no existe o está deshabilitado, Hyprland arranca normalmente sin ningún error.
   - El plugin puede generar y regenerar `macos_gestures.lua` atómicamente en cualquier momento.
3. **Manejo de Conflictos de Dedos**:
   - Dos perfiles operativos canónicos:
     - `standard`: 3 dedos para Workspaces y Mission Control; 4 dedos para Launchpad y Show Desktop; `drag_3fg = 0`.
     - `drag3fg`: 3 dedos para arrastrar (`drag_3fg = 1`); 4 dedos para Workspaces y Mission Control; 4 dedos pinch in/out para Launchpad y Show Desktop.
4. **Respeto a las Reglas de Movimiento y Estilo de Omarchy**:
   - Uso de `qs.Commons (Style.duration, Style.easeOut)`.
   - Uso de `qs.Ui (OverlayWindow, Button, etc.)`.
   - Soporte para textos planos seguros (`Text.PlainText`).
