# Project Brief: macOS Gestures for Omarchy

## Misión
Investigar la viabilidad técnica, planificar la arquitectura y desarrollar un plugin nativo de Omarchy 4 (Quattro) que implemente con precisión la experiencia de gestos de trackpad de macOS en Linux (Omarchy / Hyprland 0.56 / Quickshell).

## Alcance
1. **Investigación exhaustiva**:
   - Viabilidad de cada gesto clásico de macOS (Spaces 1:1, Mission Control, App Exposé, Launchpad, Mostrar Escritorio, Arrastre con 3 dedos, Desplazamiento natural, etc.).
   - Análisis de capacidades del compositor Wayland Hyprland 0.56 (`CTrackpadGestures`, `hl.gesture`, `drag_3fg`, `CWorkspaceSwipeGesture`, `CLuaFunctionGesture`).
   - Mapeo de eventos libinput/Aquamarine a acciones del escritorio Omarchy.
2. **Planning de Implementación**:
   - Matriz de gestos y resolución de conflictos (Modo 3 dedos vs 4 dedos con 3-finger drag).
   - Arquitectura desacoplada: Plugin Quickshell (Servicio + Overlay) + Módulo Hyprland Lua + CLI de control.
   - Hitos de desarrollo, pruebas y despliegue.
3. **Desarrollo del Plugin de Omarchy (`io.github.devmercenario.macos-gestures`)**:
   - Manifest validado (`manifest.json` schemaVersion 1).
   - Overlay de Mission Control nativo (`Overlay.qml`) con vista general interactiva de ventanas organizadas por workspace, búsqueda en vivo y cambio de foco.
   - Servicio IPC en segundo plano (`Service.qml`) con target `io.github.devmercenario.macos-gestures`.
   - Generación dinámica y sincronización del módulo Hyprland `~/.config/hypr/macos_gestures.lua`.
   - CLI de administración y script de instalación/desinstalación.
   - Pruebas automatizadas y validación oficial `omarchy plugin validate`.

## Criterios de Éxito
- Cobertura completa de los gestos principales de macOS sin fricción ni conflictos.
- Soporte 1:1 para swipe de workspaces nativo.
- Mission Control interactivo y fluido con animación y búsqueda.
- Launchpad integrado con `omarchy.dock apps`.
- Configuración persistente con cambio en caliente entre modo estándar y modo 3-finger drag.
- Cumplimiento estricto del estándar de calidad de plugins de Omarchy Quattro.
