#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_PLUGIN_DIR="$HOME/.config/omarchy/plugins/io.github.devmercenario.macos-gestures"
TARGET_BIN_DIR="$HOME/.local/bin"

echo "==> Validando plugin antes de instalar..."
"$REPO_DIR/tests/run"

echo "==> Instalando plugin en $TARGET_PLUGIN_DIR..."
mkdir -p "$TARGET_PLUGIN_DIR" "$TARGET_PLUGIN_DIR/scripts" "$TARGET_PLUGIN_DIR/bin" "$TARGET_BIN_DIR"

# Copy QML, manifest, and scripts (No symlinks inside plugin dir as required by Omarchy security model)
cp "$REPO_DIR/manifest.json" "$TARGET_PLUGIN_DIR/"
cp "$REPO_DIR/Service.qml" "$TARGET_PLUGIN_DIR/"
cp "$REPO_DIR/Overlay.qml" "$TARGET_PLUGIN_DIR/"
cp "$REPO_DIR/preview.svg" "$TARGET_PLUGIN_DIR/"
cp -r "$REPO_DIR/scripts/"* "$TARGET_PLUGIN_DIR/scripts/"
cp -r "$REPO_DIR/bin/"* "$TARGET_PLUGIN_DIR/bin/"
chmod +x "$TARGET_PLUGIN_DIR/scripts/"* "$TARGET_PLUGIN_DIR/bin/"*

# Symlink CLI tool to ~/.local/bin
ln -sf "$TARGET_PLUGIN_DIR/bin/omarchy-macos-gestures" "$TARGET_BIN_DIR/omarchy-macos-gestures"

echo "==> Validando plugin instalado..."
if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate "$TARGET_PLUGIN_DIR"
fi

echo "==> Habilitando plugin en Omarchy shell..."
if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin enable io.github.devmercenario.macos-gestures || true
fi

echo "==> Sincronizando gestos de macOS con Hyprland..."
python3 "$TARGET_PLUGIN_DIR/scripts/macos_gestures_manager.py" sync

echo "==> Verificando sintaxis de configuración de Hyprland..."
if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload
  ERRORS="$(hyprctl configerrors || true)"
  if [[ -n "$ERRORS" && "$ERRORS" != "ok" ]]; then
    echo "[warning] Advertencias de configuración en Hyprland:"
    echo "$ERRORS"
  else
    echo "✓ Hyprland reloaded sin errores."
  fi
fi

echo "==> ¡macOS Gestures instalado y habilitado con éxito!"
echo "    Usa 'omarchy-macos-gestures status' para verificar el estado."
