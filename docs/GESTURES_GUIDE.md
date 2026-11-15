# Guía de Gestos de Espacios estilo macOS para Omarchy Linux

Bienvenido a la guía completa de configuración, personalización y optimización de hardware de **macOS Gestures for Omarchy**.

Este documento detalla el comportamiento exacto del desplazamiento lateral entre espacios (workspaces), la física inercial 1:1, los perfiles de arrastre con tres dedos, comandos CLI y opciones de configuración.

---

## 📑 Tabla de Contenidos

1. [Filosofía y Arquitectura](#-filosofía-y-arquitectura)
2. [Mapeo de Gestos](#-mapeo-de-gestos)
   - [Modo Estándar (3 Dedos para Navegación)](#modo-estándar-mode-standard)
   - [Modo Arrastre (3 Dedos Drag + 4 Dedos Navegación)](#modo-arrastre-mode-drag3fg)
   - [Gestos de 2 Dedos](#gestos-de-2-dedos)
3. [Optimización y Consejos de Hardware](#-optimización-y-consejos-de-hardware)
   - [Apple Magic Trackpad 2 & 3 (USB / Bluetooth)](#apple-magic-trackpad-2--3)
   - [Trackpads de Portátiles](#trackpads-de-portátiles)
   - [Sensibilidad y Factor de Desplazamiento](#sensibilidad-y-factor-de-desplazamiento)
4. [Gestión CLI e Integración IPC](#-gestión-cli-e-integración-ipc)
   - [Referencia de Comandos CLI](#referencia-de-comandos-cli)
   - [Integración con Quickshell IPC](#integración-con-quickshell-ipc)
5. [Diagnóstico y Validación](#-diagnóstico-y-validación)

---

## 🧠 Filosofía y Arquitectura

En macOS, el cambio de espacios de trabajo no es una simple animación artificial activada por teclado: es una **interacción táctil continua con física inercial 1:1**. Cuando deslizas los dedos sobre el trackpad, los espacios de trabajo se mueven en perfecta sincronía con la velocidad y distancia física de tu mano.

Este plugin implementa esta experiencia en **Omarchy Linux** integrando:
1. **Hyprland Native Gestures (`hl.gesture` y `CWorkspaceSwipeGesture`)**: Ejecuta el cálculo inercial directamente en el compositor Wayland.
2. **Servicio Quickshell Quattro (`Service.qml`)**: Servicio en segundo plano que gestiona perfiles, estado y comandos IPC.
3. **Controlador Reactivo de Configuración (`scripts/macos_gestures_manager.py`)**: Sincroniza dinámicamente las directivas de Hyprland Lua (`~/.config/hypr/macos_gestures.lua`).

---

## 🖐️ Mapeo de Gestos

El plugin ofrece dos perfiles operativos que replican la ergonomía de macOS:

```
+--------------------------------------------------------------------------+
|                              PERFILES DE USO                             |
+------------------------------------+-------------------------------------+
|      MODO STANDARD (Por defecto)   |       MODO DRAG3FG (Arrastre)       |
+------------------------------------+-------------------------------------+
| 3 Dedos:                           | 3 Dedos:                            |
|   - Swipe Horizontal -> Espacios   |   - Arrastre de Ventanas y Selección|
|                                    | 4 Dedos:                            |
|                                    |   - Swipe Horizontal -> Espacios    |
+------------------------------------+-------------------------------------+
```

### Modo Estándar (`mode standard`)
* **Deslizar 3 dedos horizontalmente (Izquierda / Derecha)**: Desplaza suavemente entre los escritorios / workspaces contiguos con seguimiento 1:1.

### Modo Arrastre (`mode drag3fg`)
* **Arrastrar con 3 dedos**: Mueve la ventana activa o selecciona texto de forma continua (Three-Finger Drag nativo de libinput en Hyprland).
* **Deslizar 4 dedos horizontalmente**: Desplaza suavemente entre los escritorios virtuales.

### Gestos de 2 Dedos
* **Desplazamiento con dos dedos**: Desplazamiento natural (*Natural Scrolling*). El contenido sigue la dirección física de tus dedos.
* **Toque / Clic con dos dedos**: Clic secundario (clic derecho) instantáneo.
* **Pellizcar con dos dedos**: Zoom continuo en aplicaciones compatibles con Wayland `zwp_pointer_gestures_v1`.

---

## ⚙️ Optimización y Consejos de Hardware

### Apple Magic Trackpad 2 & 3
El Magic Trackpad de Apple ofrece la superficie multitáctil más precisa:
* **Conexión USB-C o Lightning**: Latencia mínima (polling rate de 1000Hz).
* **Conexión Bluetooth**: Soporte nativo a través del módulo del kernel `hid-magicmouse`.

### Trackpads de Portátiles
En portátiles (ThinkPad, XPS, Framework, ASUS):
* Asegúrate de que el trackpad esté configurado con `clickfinger_behavior = true` para clic secundario intuitivo.

### Sensibilidad y Factor de Desplazamiento
Puedes ajustar el factor de scroll y la sensibilidad en `~/.config/omarchy/macos-gestures.json` modificando `scrollFactor` (por defecto `0.40`).

---

## 🛠️ Gestión CLI e Integración IPC

### Referencia de Comandos CLI

El ejecutable `omarchy-macos-gestures` está disponible en la terminal:

```bash
# Consultar el estado y modo activo
omarchy-macos-gestures status

# Salida en JSON para scripts
omarchy-macos-gestures status --json

# Activar modo estándar (3 dedos)
omarchy-macos-gestures mode standard

# Activar modo arrastre (3 dedos drag + 4 dedos swipe)
omarchy-macos-gestures mode drag3fg

# Alternar desplazamiento natural
omarchy-macos-gestures natural-scroll toggle

# Sincronizar configuración con Hyprland
omarchy-macos-gestures sync
```

### Integración con Quickshell IPC

Desde cualquier script o widget de Omarchy:

```bash
omarchy-shell io.github.devmercenario.macos-gestures status
omarchy-shell io.github.devmercenario.macos-gestures setMode standard
omarchy-shell io.github.devmercenario.macos-gestures sync
```

---

## 🔍 Diagnóstico y Validación

Para verificar que el plugin está activo y Hyprland lo reconoce:

1. Ejecuta `omarchy-macos-gestures status` para confirmar el estado `ENABLED`.
2. Ejecuta `hyprctl configerrors` para verificar que la configuración Lua se cargó sin errores.
3. Realiza un swipe horizontal con 3 dedos (o 4 dedos si estás en modo `drag3fg`) para cambiar de espacio.
