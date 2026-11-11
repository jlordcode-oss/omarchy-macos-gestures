# Tech Context: macOS Gestures in Omarchy

## Stack Tecnológico y Entorno
- **Sistema Operativo**: Omarchy Linux (Arch Linux x86_64, Kernel Linux 7.2.15-1-omarchy)
- **Servidor Gráfico / Compositor**: Hyprland v0.56.2 (Aquamarine 0.15.1, Hyprutils 0.14.2, Hyprlang 0.6.8)
- **Shell de Escritorio**: Quickshell (Qt 6.12 QML, QtQuick) en Omarchy Quattro
- **Motor de Entrada**: libinput (hardware detectado: `dll0945:00-06cb:cde6-touchpad`)
- **Lenguajes**: QML (Qt 6), Lua 5.5 (Hyprland scripting), Bash, Python 3

## Ubicaciones Clave de Archivos
- Repositorio del Plugin: `/home/jlord/Projects/apps/omarchy-macos-gestures/`
- Instalación de Plugins de Usuario: `~/.config/omarchy/plugins/io.github.devmercenario.macos-gestures/`
- Configuración de Hyprland:
  - `~/.config/hypr/hyprland.lua` (punto de entrada principal)
  - `~/.config/hypr/input.lua` (configuración de entrada existente)
  - `~/.config/hypr/macos_gestures.lua` (módulo generado por el plugin)
- Configuración del Plugin: `~/.config/omarchy/macos-gestures.json`

## Variables y Comandos
- Identificador del Plugin: `io.github.devmercenario.macos-gestures`
- Endpoint IPC Quickshell: `omarchy-shell io.github.devmercenario.macos-gestures <method>`
- Comando de Validación: `omarchy plugin validate <dir>`
- Validación de Hyprland: `hyprctl reload && hyprctl configerrors`
