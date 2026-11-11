import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// Background orchestration service for macOS trackpad gestures
Item {
  id: root
  visible: false

  property string omarchyPath: Quickshell.env("OMARCHY_PATH") || "/usr/share/omarchy"
  property var shell: null
  property var manifest: null

  readonly property string home: Quickshell.env("HOME") || ""
  readonly property string managerScript: {
    // Priority: user plugin dir, then local workspace dev repo
    var primary = root.home + "/.config/omarchy/plugins/io.github.devmercenario.macos-gestures/scripts/macos_gestures_manager.py"
    var fallback = root.home + "/Projects/apps/omarchy-macos-gestures/scripts/macos_gestures_manager.py"
    return primary
  }

  function runManager(args) {
    var cmd = ["python3", root.managerScript]
    for (var i = 0; i < args.length; i++) {
      cmd.push(String(args[i]))
    }
    managerProc.command = cmd
    managerProc.running = true
  }

  Process {
    id: managerProc
    running: false
  }

  Process {
    id: dockAppsProc
    running: false
    command: ["omarchy-shell", "omarchy.dock", "apps"]
  }

  IpcHandler {
    target: "io.github.devmercenario.macos-gestures"

    function status(): string {
      return "running"
    }

    function enable(): string {
      root.runManager(["enable"])
      return "enabled"
    }

    function disable(): string {
      root.runManager(["disable"])
      return "disabled"
    }

    function toggle(): string {
      root.runManager(["toggle"])
      return "toggled"
    }

    function setMode(mode: string): string {
      if (mode === "drag3fg" || mode === "standard") {
        root.runManager(["mode", mode])
        return mode
      }
      return "invalid-mode"
    }

    function sync(): string {
      root.runManager(["sync"])
      return "synced"
    }

    function missionControl(): string {
      if (root.shell) {
        root.shell.summon("io.github.devmercenario.macos-gestures", "{}")
      }
      return "opened"
    }

    function appExpose(): string {
      if (root.shell) {
        root.shell.summon("io.github.devmercenario.macos-gestures", JSON.stringify({ appExpose: true }))
      }
      return "opened"
    }

    function launchpad(): string {
      dockAppsProc.running = true
      return "launchpad"
    }

    function showDesktop(): string {
      Hyprland.dispatch("togglespecialworkspace desktop")
      return "show-desktop"
    }
  }

  Component.onCompleted: {
    root.runManager(["sync"])
  }
}
