#!/usr/bin/env bash
set -euo pipefail

TARGET_PLUGIN_DIR="$HOME/.config/omarchy/plugins/io.github.devmercenario.macos-gestures"
TARGET_BIN="$HOME/.local/bin/omarchy-macos-gestures"
HYPR_LUA="$HOME/.config/hypr/macos_gestures.lua"

echo "==> Desinstalando macOS Gestures para Omarchy..."

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin disable io.github.devmercenario.macos-gestures || true
fi

# Clean up Hyprland Lua bindings
if [[ -f "$TARGET_PLUGIN_DIR/scripts/macos_gestures_manager.py" ]]; then
  python3 "$TARGET_PLUGIN_DIR/scripts/macos_gestures_manager.py" disable || true
fi

rm -f "$TARGET_BIN"
rm -f "$HYPR_LUA"
rm -rf "$TARGET_PLUGIN_DIR"

if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload || true
fi

echo "==> macOS Gestures ha sido desinstalado correctamente."
