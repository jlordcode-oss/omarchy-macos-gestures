# Product Context: macOS Gestures in Omarchy

## Por qué existe este proyecto
Los usuarios procedentes de macOS valoran enormemente la fluidez y memoria muscular de sus gestos en el trackpad (Mission Control, cambio de escritorios, Launchpad, arrastre con 3 dedos). En Linux y entornos basados en Hyprland / Omarchy, estas funcionalidades suelen estar fragmentadas, incompletas o requerir complejas configuraciones manuales.

## Experiencia de Usuario Objetivo
- **Naturalidad y Física Fluida**: Los gestos deben responder al desplazamiento de los dedos (swipes 1:1) con la misma sensación de inercia y rebote que en macOS.
- **Sin Bloqueos ni Latencia**: Hyprland procesa los gestos a nivel compositor sin pasar por emulación X11 ni capas lentas.
- **Mission Control Visual**: Un gesto de 3 o 4 dedos hacia arriba abre una cuadrícula panorámica de todas las ventanas abiertas en todos los workspaces, permitiendo seleccionar con clic o teclado.
- **Launchpad Inmediato**: Un pellizco de 4 dedos hacia adentro despliega la parrilla de aplicaciones con búsqueda instantánea.
- **Arrastre de 3 Dedos (Three-finger drag)**: Los usuarios que dependen del arrastre con tres dedos para mover ventanas y seleccionar texto pueden activarlo sin que colisione con los gestos de navegación (los cuales conmutan automáticamente a 4 dedos, exactamente como en macOS).
- **Control Centralizado**: Un menú y comandos CLI sencillos (`omarchy-macos-gestures status`, `enable`, `mode standard|drag3fg`) para ajustar el comportamiento sin editar código.
