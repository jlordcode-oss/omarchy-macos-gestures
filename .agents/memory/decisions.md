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
