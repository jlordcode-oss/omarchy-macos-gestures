# Guía de Gestos de Trackpad estilo macOS para Omarchy Linux

Bienvenido a la guía completa de configuración, personalización, optimización de hardware y resolución de problemas de **macOS Gestures for Omarchy**.

Este documento detalla el comportamiento exacto de los gestos, su mapeo técnico, optimizaciones específicas para trackpads internos y externos (como el Apple Magic Trackpad), comandos CLI y soluciones a incidencias comunes.

---

## 📑 Tabla de Contenidos

1. [Filosofía y Arquitectura](#-filosofía-y-arquitectura)
2. [Mapeo Completo de Gestos](#-mapeo-completo-de-gestos)
   - [Gestos de 2 Dedos](#gestos-de-2-dedos)
   - [Modo Estándar (3 Dedos para Navegación)](#modo-estándar-mode-standard)
   - [Modo Arrastre (3 Dedos Drag + 4 Dedos Navegación)](#modo-arrastre-mode-drag3fg)
   - [Matriz Comparativa Omarchy vs macOS](#matriz-comparativa-omarchy-vs-macos)
3. [Componentes Visuales](#-componentes-visuales)
   - [Mission Control](#mission-control)
   - [App Exposé](#app-exposé)
   - [Launchpad y Mostrar Escritorio](#launchpad-y-mostrar-escritorio)
4. [Optimización y Consejos de Hardware](#-optimización-y-consejos-de-hardware)
   - [Apple Magic Trackpad 2 & 3 (USB / Bluetooth)](#apple-magic-trackpad-2--3)
   - [Trackpads de Portátiles (ThinkPad, Dell XPS, ASUS, Framework)](#trackpads-de-portátiles)
   - [Sensibilidad, Inercia y Factores de Escala](#sensibilidad-inercia-y-factores-de-escala)
   - [Ergonomía y Prevención de Fatiga (RSI)](#ergonomía-y-prevención-de-fatiga-rsi)
5. [Gestión CLI e Integración IPC](#-gestión-cli-e-integración-ipc)
   - [Referencia de Comandos CLI](#referencia-de-comandos-cli)
   - [Integración con Quickshell IPC](#integración-con-quickshell-ipc)
   - [Atajos de Teclado Complementarios](#atajos-de-teclado-complementarios)
6. [Diagnóstico y Resolución de Problemas (Troubleshooting)](#-diagnóstico-y-resolución-de-problemas-troubleshooting)
   - [Comprobación de Detección de Gestos en Hyprland](#1-comprobación-de-detección-de-gestos-en-hyprland)
   - [Permisos de Usuario en Grupos de Entrada (`input`)](#2-permisos-de-usuario-en-grupos-de-entrada-input)
   - [Conflictos con Daemons Externos (touchegg, libinput-gestures)](#3-conflictos-con-daemons-externos)
   - [El gesto de Mission Control no abre el overlay](#4-el-gesto-de-mission-control-no-abre-el-overlay)
   - [Desincronización tras actualizar Hyprland o Omarchy](#5-desincronización-tras-actualizar-hyprland-o-omarchy)

---

## 🧠 Filosofía y Arquitectura

En macOS, los gestos del trackpad no son simples atajos de teclado emulados: son **interacciones táctiles continuas con física inercial 1:1**. Cuando mueves los dedos, el espacio de trabajo se desplaza exactamente a la misma velocidad y distancia que tu mano.

Este plugin replica esa experiencia en **Omarchy Linux** integrando:
1. **Hyprland 0.56.2+ (`hl.gesture` y `CWorkspaceSwipeGesture`)**: Proporciona física continua fluida a nivel de compositor Wayland.
2. **Quickshell Quattro (`Overlay.qml`)**: Overlay renderizado por GPU mediante QtQuick con composición visual de ventanas, animaciones fluidas y búsqueda rápida.
3. **Controlador Reactivo de Configuración (`scripts/macos_gestures_manager.py`)**: Sincroniza dinámicamente las directivas de Hyprland Lua (`~/.config/hypr/macos_gestures.lua`) ante cualquier cambio de modo.

---

## 🖐️ Mapeo Completo de Gestos

El plugin ofrece dos perfiles operativos que replican con exactitud las dos configuraciones nativas de macOS:

```
+--------------------------------------------------------------------------+
|                              PERFILES DE USO                             |
+------------------------------------+-------------------------------------+
|      MODO STANDARD (Por defecto)   |       MODO DRAG3FG (Arrastre)       |
+------------------------------------+-------------------------------------+
| 3 Dedos:                           | 3 Dedos:                            |
|   - Swipe Horizontal -> Espacios   |   - Arrastre de Ventanas y Selección|
|   - Swipe Arriba     -> M. Control |                                     |
|   - Swipe Abajo      -> App Exposé |                                     |
|                                    | 4 Dedos:                            |
| 4 Dedos:                           |   - Swipe Horizontal -> Espacios    |
|   - Pellizco Dentro  -> Launchpad  |   - Swipe Arriba     -> M. Control  |
|   - Pellizco Fuera   -> Escritorio |   - Swipe Abajo      -> App Exposé  |
|                                    |   - Pellizco Dentro  -> Launchpad   |
|                                    |   - Pellizco Fuera   -> Escritorio  |
+------------------------------------+-------------------------------------+
```

### Gestos de 2 Dedos

Comunes a ambos perfiles:

* **Desplazamiento con dos dedos**: Desplazamiento natural (*Natural Scrolling*). El contenido sigue la dirección física de tus dedos.
* **Toque / Clic con dos dedos**: Clic secundario (clic derecho) instantáneo.
* **Pellizcar con dos dedos**: Zoom continuo en aplicaciones compatibles con el protocolo Wayland `zwp_pointer_gestures_v1` (navegadores Chromium/Firefox, visores de documentos e imágenes).

---

### Modo Estándar (`mode standard`)

Ideal si prefieres cambiar de escritorio y abrir Mission Control con la máxima agilidad usando 3 dedos.

| Gesto | Dirección / Movimiento | Acción Ejecutada |
| :--- | :--- | :--- |
| **3 Dedos** | Deslizar Izquierda / Derecha | Transición 1:1 entre espacios de trabajo (Spaces). Si sueltas a medio camino, regresa elásticamente al espacio de origen. |
| **3 Dedos** | Deslizar hacia Arriba | Abre **Mission Control** con vista panorámica de todas las ventanas. |
| **3 Dedos** | Deslizar hacia Abajo | Abre **App Exposé** mostrando únicamente las ventanas de la aplicación activa. |
| **4 Dedos** | Pellizco hacia adentro | Abre el lanzador de aplicaciones **Launchpad** (`omarchy.dock apps`). |
| **4 Dedos** | Separar hacia afuera (Spread) | **Mostrar Escritorio** (oculta temporalmente las ventanas activas). |

Para activar este modo:
```bash
omarchy-macos-gestures mode standard
```

---

### Modo Arrastre (`mode drag3fg`)

Modo preferido por diseñadores, programadores y usuarios avanzados de Mac. En macOS, esta opción se encuentra en *Accesibilidad > Control del puntero > Opciones del trackpad > Arrastre con tres dedos*.

Al activarlo en Omarchy:
- **Arrastre con 3 dedos**: Permite mover ventanas flotantes o en mosaico, seleccionar bloques de texto y arrastrar archivos sin necesidad de presionar físicamente el trackpad ni mantener pulsado el clic.
- **Transición automática**: Para evitar colisiones de gestos, todas las funciones de navegación (Espacios, Mission Control y App Exposé) pasan limpiamente a **4 dedos**.

| Gesto | Dirección / Movimiento | Acción Ejecutada |
| :--- | :--- | :--- |
| **3 Dedos** | Tocar y mover | **Arrastre nativo** (`drag_3fg = 1`). Mueve la ventana bajo el cursor o selecciona texto. |
| **4 Dedos** | Deslizar Izquierda / Derecha | Transición 1:1 entre espacios de trabajo (Spaces). |
| **4 Dedos** | Deslizar hacia Arriba | Abre **Mission Control**. |
| **4 Dedos** | Deslizar hacia Abajo | Abre **App Exposé**. |
| **4 Dedos** | Pellizco hacia adentro | Abre **Launchpad**. |
| **4 Dedos** | Separar hacia afuera | **Mostrar Escritorio**. |

Para activar este modo:
```bash
omarchy-macos-gestures mode drag3fg
```

---

### Matriz Comparativa Omarchy vs macOS

| Gesto | macOS Original | Omarchy Implementation | Tecnología Subyacente |
| :--- | :--- | :--- | :--- |
| **Cambio de Espacio** | 3/4 dedos horizontal | Transición suave de Workspaces | Hyprland `hl.gesture` + `CWorkspaceSwipeGesture` |
| **Mission Control** | 3/4 dedos arriba | Overlay Panorámico de Ventanas | Quickshell `Overlay.qml` sobre Wayland LayerShell |
| **App Exposé** | 3/4 dedos abajo | Mosaico de ventanas de la app activa | Filtrado por `window.class` en Quickshell |
| **Launchpad** | 4 dedos pellizco dentro | Cuadrícula de aplicaciones | `omarchy.dock apps` |
| **Show Desktop** | 4 dedos pellizco fuera | Espacio especial escritorio | Alternancia de Workspace especial Hyprland |
| **Three-Finger Drag** | Accesibilidad macOS | Arrastre nativo libinput | `input.touchpad.drag_3fg = 1` |
| **Natural Scroll** | Habilitado por defecto | Habilitado por defecto | `input.touchpad.natural_scroll = true` |

---

## 🖥️ Componentes Visuales

### Mission Control

El overlay de Mission Control (`Overlay.qml`) se despliega instantáneamente cubriendo la pantalla con un fondo translúcido (*scrim blur*):

1. **Barra Superior de Espacios**: Muestra todos los escritorios activos, resaltando el espacio actual y permitiendo saltar a cualquiera con un clic.
2. **Distribución Inteligente de Ventanas**: Todas las ventanas abiertas se distribuyen en una cuadrícula proporcional respetando su relación de aspecto.
3. **Búsqueda Instantánea con Teclado**: Al abrirse, el foco se sitúa automáticamente en el campo de búsqueda. Basta con escribir el nombre de la app (ej. `code`, `firefox`, `terminal`) para filtrar las ventanas en tiempo real.
4. **Navegación por Teclado y Ratón**:
   - Pulsa `Tab` o las teclas de dirección `←` `↑` `→` `↓` para navegar entre ventanas.
   - Pulsa `Enter` o haz clic sobre una ventana para enfocarla y cerrar el overlay.
   - Pulsa `Escape` o haz clic en el fondo vacío para cancelar sin cambiar de ventana.

### App Exposé

Al deslizar hacia abajo con 3 (o 4) dedos, el overlay se abre en modo restringido:
- Filtra y presenta **únicamente las ventanas pertenecientes a la aplicación en primer plano**.
- Resulta ideal cuando tienes múltiples ventanas de navegador, varias terminales abiertas o diferentes proyectos de IDE y deseas seleccionar uno de ellos sin la distracción de otras aplicaciones.

### Launchpad y Mostrar Escritorio

- **Launchpad**: Se integra con el dock de Omarchy para abrir la parrilla a pantalla completa de aplicaciones instaladas con buscador y categorías.
- **Mostrar Escritorio**: Oculta inmediatamente las ventanas para acceder a los widgets del fondo de escritorio o despejar la vista.

---

## ⚙️ Optimización y Consejos de Hardware

### Apple Magic Trackpad 2 & 3

El Magic Trackpad de Apple ofrece la superficie táctil de mayor calidad para gestos en Linux.

#### Conexión por Cable (USB-C / Lightning)
- Funciona de forma inmediata con tasa de sondeo de 1000 Hz.
- Soporte nativo para 5 puntos de contacto simultáneos.

#### Conexión por Bluetooth
1. Empareja el dispositivo mediante `bluetoothctl` o el panel de Bluetooth de Omarchy.
2. Comprueba que el kernel carga el módulo `hid_apple`:
   ```bash
   lsmod | grep hid_apple
   ```
3. Para optimizar la latencia del cursor y evitar suspensiones por ahorro de energía Bluetooth, puedes crear el archivo `/etc/bluetooth/input.conf`:
   ```ini
   [General]
   IdleTimeout=0
   ```

---

### Trackpads de Portátiles

Los portátiles modernos (Lenovo ThinkPad, Dell XPS, ASUS ZenBook, Framework, HP Spectre) integran trackpads compatibles con I2C-HID / Precision Touchpad:

- **Detección de contactos**: Asegúrate de que tu hardware soporta al menos 4 puntos táctiles simultáneos ejecutando:
  ```bash
  libinput list-devices | grep -A 10 "Touchpad"
  ```
  Debe figurar `Capacities: gesture`.

- **Rechazo de Palma (*Palm Rejection*)**: Hyprland gestiona el rechazo de palma a través de libinput. Si rozas involuntariamente el trackpad al escribir, comprueba que la opción `disable_while_typing` está habilitada en la configuración de Hyprland.

---

### Sensibilidad, Inercia y Factores de Escala

La configuración generada en `~/.config/hypr/macos_gestures.lua` incluye ajustes calibrados para imitar la inercia de macOS:

```lua
hl.config({
  input = {
    touchpad = {
      natural_scroll = true,
      clickfinger_behavior = true,
      drag_3fg = 0,             -- 1 en modo drag3fg
      scroll_factor = 0.40,     -- Calibrado para coincidir con macOS
    },
  },
})
```

- **Ajustar la velocidad del scroll**: Si sientes que el desplazamiento es muy rápido o lento en tu hardware, puedes modificar `scrollFactor` en `~/.config/omarchy/macos-gestures.json` (valores recomendados: entre `0.30` y `0.55`) y ejecutar:
  ```bash
  omarchy-macos-gestures sync
  ```

---

### Ergonomía y Prevención de Fatiga (RSI)

El arrastre tradicional en trackpads de PC requiere presionar con fuerza con un dedo mientras se desliza con otro. Tras horas de trabajo continuo, esto puede provocar molestias en la muñeca o en la articulación del pulgar (túnel carpiano o tendinitis).

> [!TIP]
> Activar el **Modo Arrastre con Tres Dedos** (`omarchy-macos-gestures mode drag3fg`) elimina por completo la necesidad de hacer fuerza sobre la superficie: basta con posar 3 dedos suavemente y deslizar para mover ventanas o seleccionar texto con precisión milimétrica.

---

## 💻 Gestión CLI e Integración IPC

### Referencia de Comandos CLI

El ejecutable `omarchy-macos-gestures` reside en `~/.local/bin/` y en el repositorio del proyecto:

```bash
# Ver el estado detallado del plugin y del compositor
omarchy-macos-gestures status

# Salida en JSON para scripts, barras de estado o extensiones
omarchy-macos-gestures status --json

# Conmutar entre los perfiles de gestos
omarchy-macos-gestures mode standard
omarchy-macos-gestures mode drag3fg

# Configurar desplazamiento natural
omarchy-macos-gestures natural-scroll on
omarchy-macos-gestures natural-scroll off
omarchy-macos-gestures natural-scroll toggle

# Disparar acciones directamente desde terminal o scripts
omarchy-macos-gestures mission-control
omarchy-macos-gestures app-expose
omarchy-macos-gestures launchpad
omarchy-macos-gestures show-desktop

# Habilitar o deshabilitar temporalmente los gestos
omarchy-macos-gestures enable
omarchy-macos-gestures disable
omarchy-macos-gestures toggle

# Forzar la regeneración y recarga de la configuración en Hyprland
omarchy-macos-gestures sync
```

---

### Integración con Quickshell IPC

El servicio en segundo plano (`Service.qml`) registra el canal IPC `io.github.devmercenario.macos-gestures`. Puedes interactuar con él desde cualquier script o herramienta de automatización:

```bash
# Consultar estado del servicio
omarchy-shell io.github.devmercenario.macos-gestures status

# Cambiar modo vía IPC
omarchy-shell io.github.devmercenario.macos-gestures setMode drag3fg
omarchy-shell io.github.devmercenario.macos-gestures setMode standard

# Abrir Mission Control
omarchy-shell io.github.devmercenario.macos-gestures missionControl

# Abrir App Exposé
omarchy-shell io.github.devmercenario.macos-gestures appExpose

# Mostrar Escritorio
omarchy-shell io.github.devmercenario.macos-gestures showDesktop
```

---

### Atajos de Teclado Complementarios

Para máxima productividad, puedes vincular Mission Control y App Exposé a atajos de teclado en tu configuración de Hyprland (`~/.config/hypr/hyprland.lua` o `bindings.lua`):

```lua
-- Atajo estilo macOS para Mission Control: SUPER + Flecha Arriba o SUPER + Tab
hl.bind("SUPER", "Up", function()
  hl.exec_cmd("omarchy-macos-gestures mission-control")
end)

-- Atajo estilo macOS para App Exposé: SUPER + Flecha Abajo
hl.bind("SUPER", "Down", function()
  hl.exec_cmd("omarchy-macos-gestures app-expose")
end)
```

---

## 🔧 Diagnóstico y Resolución de Problemas (Troubleshooting)

### 1. Comprobación de Detección de Gestos en Hyprland

Si los gestos no parecen responder:
1. Comprueba si hay errores de sintaxis en Hyprland:
   ```bash
   hyprctl configerrors
   ```
   Debe devolver `ok` o ninguna línea de error.
2. Verifica que el archivo de gestos está siendo importado:
   Comprueba que en `~/.config/hypr/hyprland.lua` existe la línea:
   ```lua
   pcall(require, "macos_gestures")
   ```
3. Si la línea no estuviera presente, ejecuta:
   ```bash
   omarchy-macos-gestures sync
   ```

---

### 2. Permisos de Usuario en Grupos de Entrada (`input`)

En algunas distribuciones Linux, el usuario necesita pertenecer al grupo `input` para permitir a las herramientas de diagnóstico leer los eventos multitáctiles del kernel:

```bash
sudo usermod -a -G input $USER
```
*(Es necesario cerrar sesión y volver a entrar para aplicar los cambios de grupo).*

---

### 3. Conflictos con Daemons Externos

Si anteriormente tenías instaladas herramientas de gestos para X11 o Wayland genérico (tales como `libinput-gestures`, `touchegg` o `fusuma`), **deben desactivarse**:
Dichos programas capturan los eventos de libinput en segundo plano y los traducen en pulsaciones de teclas simuladas, interfiriendo directamente con el seguimiento continuo 1:1 de Hyprland.

```bash
# Detener y deshabilitar servicios conflictivos
systemctl --user stop libinput-gestures touchegg 2>/dev/null || true
systemctl --user disable libinput-gestures touchegg 2>/dev/null || true
```

---

### 4. El gesto de Mission Control no abre el overlay

1. Verifica que Quickshell está ejecutándose activamente:
   ```bash
   pgrep -a quickshell
   ```
2. Prueba invocar el overlay manualmente desde la terminal:
   ```bash
   omarchy-macos-gestures mission-control
   ```
3. Si el overlay no aparece, valida el estado del plugin en Omarchy:
   ```bash
   omarchy plugin validate ~/.config/omarchy/plugins/io.github.devmercenario.macos-gestures
   ```
   Asegúrate de que la salida muestre `Plugin is valid.`.

---

### 5. Desincronización tras actualizar Hyprland o Omarchy

Si tras una actualización del sistema los gestos parecen no cargarse:
```bash
omarchy-macos-gestures sync
```
Este comando reconstruye de forma atómica `~/.config/hypr/macos_gestures.lua` a partir de tu configuración guardada en `~/.config/omarchy/macos-gestures.json` y ejecuta `hyprctl reload` de inmediato.

---

## 📌 Resumen de Atajos Rápidos

| Operación | Comando Terminal |
| :--- | :--- |
| **Comprobar estado** | `omarchy-macos-gestures status` |
| **Modo Estándar (3 dedos nav)** | `omarchy-macos-gestures mode standard` |
| **Modo Arrastre (3 dedos drag)** | `omarchy-macos-gestures mode drag3fg` |
| **Abrir Mission Control** | `omarchy-macos-gestures mission-control` |
| **Abrir App Exposé** | `omarchy-macos-gestures app-expose` |
| **Regenerar y Recargar** | `omarchy-macos-gestures sync` |
| **Validar instalación** | `./tests/run` |
