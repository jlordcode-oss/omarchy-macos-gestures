import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// Mission Control & App Exposé Fullscreen Overlay
Item {
  id: root

  property string omarchyPath: Quickshell.env("OMARCHY_PATH") || "/usr/share/omarchy"
  property var shell: null
  property var manifest: null
  property bool opened: false
  property bool isAppExpose: false
  property string targetAppClass: ""
  property string searchQuery: ""
  property int hoveredIndex: -1

  readonly property color scrimColor: Qt.rgba(0.04, 0.06, 0.09, 0.88)
  readonly property color cardBg: Commons.Color.menu.background
  readonly property color cardBorder: Commons.Color.menu.border
  readonly property color textColor: Commons.Color.menu.text
  readonly property color textDim: Commons.Color.menu.description || Qt.rgba(0.7, 0.75, 0.8, 0.75)
  readonly property color accentColor: Commons.Color.accent || "#3b82f6"

  function open(payloadJson) {
    root.searchQuery = ""
    root.hoveredIndex = -1
    root.isAppExpose = false
    root.targetAppClass = ""

    var encoded = String(payloadJson || "{}")
    if (encoded.length <= 16384) {
      try {
        var parsed = JSON.parse(encoded)
        if (parsed.appExpose) {
          root.isAppExpose = true
          // Identify current active window app class
          var toplevels = Hyprland.toplevels.values
          for (var i = 0; i < toplevels.length; i++) {
            var top = toplevels[i]
            if (top && top.activated) {
              var ipc = top.lastIpcObject || {}
              root.targetAppClass = top.wayland || ipc.class || ipc.initialClass || ""
              break
            }
          }
        }
      } catch (error) {}
    }

    Hyprland.refreshWorkspaces()
    Hyprland.refreshToplevels()
    root.opened = true
    Qt.callLater(function() { searchInput.forceActiveFocus() })
  }

  function close() {
    root.opened = false
    root.isAppExpose = false
    root.targetAppClass = ""
    root.searchQuery = ""
  }

  function toggle() {
    if (root.opened) root.close()
    else root.open("{}")
  }

  function activateWindow(address) {
    if (address && address.length > 0) {
      Hyprland.dispatch("focuswindow address:" + address)
    }
    root.close()
  }

  function activateWorkspace(wsId) {
    if (wsId > 0) {
      Hyprland.dispatch("workspace " + wsId)
    }
    root.close()
  }

  // Reactive window list matching search and exposé filters
  readonly property var windowItems: {
    var revision = Hyprland.toplevels.values.length
    var list = []
    var toplevels = Hyprland.toplevels.values
    for (var i = 0; i < toplevels.length; i++) {
      var top = toplevels[i]
      if (!top || !top.workspace) continue
      var wsId = top.workspace.id
      if (wsId < 0) continue // Skip special workspaces

      var ipc = top.lastIpcObject || {}
      var appClass = String(top.wayland || ipc.class || ipc.initialClass || "App")
      var title = String(top.title || ipc.title || appClass)
      var address = String(top.address || ipc.address || "")

      if (root.isAppExpose && root.targetAppClass !== "") {
        if (appClass.toLowerCase() !== root.targetAppClass.toLowerCase()) {
          continue
        }
      }

      if (root.searchQuery.trim() !== "") {
        var q = root.searchQuery.toLowerCase()
        if (title.toLowerCase().indexOf(q) === -1 && appClass.toLowerCase().indexOf(q) === -1) {
          continue
        }
      }

      list.push({
        address: address,
        title: title,
        appClass: appClass,
        workspaceId: wsId,
        activated: top.activated === true
      })
    }
    return list
  }

  readonly property var workspaceItems: {
    var revision = Hyprland.workspaces.values.length
    var list = []
    var workspaces = Hyprland.workspaces.values
    for (var i = 0; i < workspaces.length; i++) {
      var ws = workspaces[i]
      if (!ws || ws.id < 0) continue
      list.push({
        id: ws.id,
        name: ws.name || String(ws.id)
      })
    }
    list.sort(function(a, b) { return a.id - b.id })
    return list
  }

  PanelWindow {
    id: window
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "io-github-devmercenario-macos-gestures"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: root.opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore

    // Background scrim
    Rectangle {
      anchors.fill: parent
      color: root.scrimColor
      opacity: root.opened ? 1 : 0
      Behavior on opacity {
        NumberAnimation { duration: Style.duration(180); easing.type: Easing.OutCubic }
      }
    }

    // Dismiss area
    MouseArea {
      anchors.fill: parent
      onClicked: root.close()
    }

    // Main Mission Control Container
    Item {
      anchors.fill: parent
      anchors.margins: Style.space(32)

      ColumnLayout {
        anchors.fill: parent
        spacing: Style.space(24)

        // 1. TOP BAR: Spaces / Workspaces Row
        RowLayout {
          Layout.alignment: Qt.AlignHCenter
          spacing: Style.space(12)

          Repeater {
            model: root.workspaceItems

            Rectangle {
              id: spacePill
              width: Style.space(130)
              height: Style.space(42)
              radius: Style.cornerRadius
              color: pillMouse.containsMouse ? Qt.rgba(0.2, 0.25, 0.35, 0.9) : Qt.rgba(0.12, 0.15, 0.22, 0.8)
              border.color: pillMouse.containsMouse ? root.accentColor : Qt.rgba(0.3, 0.35, 0.45, 0.5)
              border.width: 1

              RowLayout {
                anchors.centerIn: parent
                spacing: Style.space(8)

                Rectangle {
                  width: Style.space(8)
                  height: Style.space(8)
                  radius: Style.space(4)
                  color: root.accentColor
                }

                Text {
                  textFormat: Text.PlainText
                  text: "Space " + modelData.name
                  color: root.textColor
                  font.pixelSize: Style.font.caption
                  font.weight: Font.DemiBold
                }
              }

              MouseArea {
                id: pillMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.activateWorkspace(modelData.id)
              }
            }
          }
        }

        // 2. HEADER: Title and Search Box
        RowLayout {
          Layout.alignment: Qt.AlignHCenter
          spacing: Style.space(16)

          Text {
            textFormat: Text.PlainText
            text: root.isAppExpose ? ("App Exposé • " + (root.targetAppClass || "All")) : "Mission Control"
            color: root.textColor
            font.pixelSize: Style.font.title
            font.weight: Font.Bold
          }

          // Search Field
          Rectangle {
            width: Style.space(280)
            height: Style.space(38)
            radius: Style.cornerRadius
            color: Qt.rgba(0.15, 0.18, 0.25, 0.9)
            border.color: searchInput.activeFocus ? root.accentColor : Qt.rgba(0.3, 0.35, 0.45, 0.6)
            border.width: 1

            TextInput {
              id: searchInput
              anchors.fill: parent
              anchors.margins: Style.space(8)
              text: root.searchQuery
              onTextChanged: root.searchQuery = text
              color: root.textColor
              font.pixelSize: Style.font.body
              verticalAlignment: TextInput.AlignVCenter
              selectByMouse: true

              Text {
                textFormat: Text.PlainText
                text: "Search windows..."
                color: root.textDim
                visible: !searchInput.text && !searchInput.activeFocus
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Style.font.body
              }

              Keys.onEscapePressed: root.close()
              Keys.onReturnPressed: {
                if (root.windowItems.length > 0) {
                  root.activateWindow(root.windowItems[0].address)
                }
              }
            }
          }
        }

        // 3. WINDOW OVERVIEW: Flow Grid of Open Windows
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true

          ScrollView {
            anchors.fill: parent
            clip: true

            Flow {
              width: parent.width
              spacing: Style.space(20)
              layoutDirection: Qt.LeftToRight

              Repeater {
                model: root.windowItems

                Rectangle {
                  id: windowCard
                  width: Math.min(Style.space(340), Math.max(Style.space(260), (parent.width - Style.space(80)) / 3))
                  height: Style.space(180)
                  radius: Style.cornerRadius
                  color: cardMouse.containsMouse ? Qt.rgba(0.16, 0.20, 0.28, 0.95) : Qt.rgba(0.10, 0.13, 0.18, 0.85)
                  border.color: cardMouse.containsMouse ? root.accentColor : (modelData.activated ? root.accentColor : root.cardBorder)
                  border.width: cardMouse.containsMouse || modelData.activated ? 2 : 1
                  scale: cardMouse.containsMouse ? 1.02 : 1.0

                  Behavior on scale {
                    NumberAnimation { duration: Style.duration(140); easing.type: Easing.OutCubic }
                  }
                  Behavior on border.color {
                    ColorAnimation { duration: Style.duration(140) }
                  }

                  ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.space(16)
                    spacing: Style.space(10)

                    // Card Header: App Badge & Space Number
                    RowLayout {
                      Layout.fillWidth: true

                      Rectangle {
                        width: Style.space(32)
                        height: Style.space(32)
                        radius: Style.space(8)
                        color: root.accentColor

                        Text {
                          textFormat: Text.PlainText
                          anchors.centerIn: parent
                          text: modelData.appClass.length > 0 ? modelData.appClass.charAt(0).toUpperCase() : "W"
                          color: "#ffffff"
                          font.pixelSize: Style.font.body
                          font.weight: Font.Bold
                        }
                      }

                      ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                          Layout.fillWidth: true
                          textFormat: Text.PlainText
                          text: modelData.appClass
                          color: root.textColor
                          font.pixelSize: Style.font.body
                          font.weight: Font.Bold
                          elide: Text.ElideRight
                        }

                        Text {
                          textFormat: Text.PlainText
                          text: "Space " + modelData.workspaceId
                          color: root.textDim
                          font.pixelSize: Style.font.caption
                        }
                      }
                    }

                    // Card Body: Window Title
                    Item {
                      Layout.fillWidth: true
                      Layout.fillHeight: true

                      Text {
                        anchors.fill: parent
                        textFormat: Text.PlainText
                        text: modelData.title
                        color: root.textColor
                        font.pixelSize: Style.font.body
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 3
                      }
                    }

                    // Card Footer: Focus prompt
                    RowLayout {
                      Layout.fillWidth: true

                      Item { Layout.fillWidth: true }

                      Text {
                        textFormat: Text.PlainText
                        text: "Click to focus →"
                        color: cardMouse.containsMouse ? root.accentColor : root.textDim
                        font.pixelSize: Style.font.caption
                        font.weight: Font.DemiBold
                      }
                    }
                  }

                  MouseArea {
                    id: cardMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activateWindow(modelData.address)
                  }
                }
              }
            }
          }

          // Empty state placeholder
          Item {
            anchors.centerIn: parent
            visible: root.windowItems.length === 0

            ColumnLayout {
              anchors.centerIn: parent
              spacing: Style.space(12)

              Text {
                Layout.alignment: Qt.AlignHCenter
                textFormat: Text.PlainText
                text: "No matching windows open"
                color: root.textDim
                font.pixelSize: Style.font.title
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                textFormat: Text.PlainText
                text: "Press ESC to return to desktop"
                color: root.textDim
                font.pixelSize: Style.font.caption
              }
            }
          }
        }

        // 4. FOOTER: Navigation Hint
        RowLayout {
          Layout.alignment: Qt.AlignHCenter
          spacing: Style.space(16)

          Text {
            textFormat: Text.PlainText
            text: "esc Close  •  ⏎ Focus First Match  •  Swipe Down to return"
            color: root.textDim
            font.pixelSize: Style.font.caption
          }
        }
      }
    }
  }
}
