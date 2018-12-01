import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11
import Qt.labs.settings 1.0
import Qt.labs.platform 1.0 as LabsPlatform
import player 1.0

import "codes.js" as LanguageCodes

Window {
    id: mainWindow
    title: titleLabel.text
    visible: true
    width: 720
    height: 480
    property int virtualHeight: Screen.height * appearance.scaleFactor
    property int virtualWidth: Screen.width * appearance.scaleFactor

    property bool onTop: false

    function getAppearanceValueForTheme(themeName, name) {
        if (themeName == "YouTube") {
            return youTubeAppearance[name]
        } else if (themeName == "Niconico") {
            return nicoNicoAppearance[name]
        }
    }

    Translator {
        id: translate
    }

    Settings {
        id: backendSettings
        category: "Backend"
        property string backend: "mpv"
    }

    Settings {
        id: appearance
        category: "Appearance"
        property bool titleOnlyOnFullscreen: true
        property bool clickToPause: true
        property bool useMpvSubs: false
        property string themeName: "YouTube"
        property string fontName: "Roboto"
        property double scaleFactor: 1.0
    }

    Settings {
        id: youTubeAppearance
        category: "Appearance"
        property string mainBackground: "#9C000000"
        property string progressBackgroundColor: "#3CFFFFFF"
        property string progressCachedColor: "white"
        property string buttonColor: "white"
        property string progressSliderColor: "red"
        property string chapterMarkerColor: "#fc0"
        property string volumeSliderBackground: "white"
    }

    Settings {
        id: nicoNicoAppearance
        category: "Appearance"
        property string mainBackground: "#9C000000"
        property string progressBackgroundColor: "#444"
        property string progressCachedColor: "white"
        property string buttonColor: "white"
        property string progressSliderColor: "#007cff"
        property string chapterMarkerColor: "#fc0"
        property string volumeSliderBackground: "#0077cff"
    }

    Settings {
        id: i18n
        category: "I18N"
        property string language: "english"
    }

    Settings {
        id: fun
        category: "Fun"
        property bool nyanCat: false
    }

    Settings {
        id: keybinds
        category: "Keybinds"
        property string playPause: "K"
        property string forward10: "L"
        property string rewind10: "J"
        property string forward5: "Right"
        property string rewind5: "Left"
        property string openFile: "Ctrl+O"
        property string openURI: "Ctrl+Shift+O"
        property string quit: "Ctrl+Q"
        property string fullscreen: "F"
        property string tracks: "Ctrl+T"
        property string statsForNerds: "I"
        property string forwardFrame: "."
        property string backwardFrame: ","
        property string cycleSub: "Alt+S"
        property string cycleSubBackwards: "Alt+Shift+S"
        property string cycleAudio: "A"
        property string cycleVideo: "V"
        property string cycleVideoAspect: "Shift+A"
        property string screenshot: "S"
        property string screenshotWithoutSubtitles: "Shift+S"
        property string fullScreenshot: "Ctrl+S"
        property string nyanCat: "Ctrl+N"
        property string decreaseSpeedByPointOne: "["
        property string increaseSpeedByPointOne: "]"
        property string halveSpeed: "{"
        property string doubleSpeed: "}"
        property string increaseVolume: "*"
        property string decreaseVolume: "/"
        property string mute: "m"
        property string increaseScale: "Ctrl+Shift+="
        property string resetScale: "Ctrl+Shift+0"
        property string decreaseScale: "Ctrl+Shift+-"
        property string customKeybind0: ""
        property string customKeybind0Command: ""
        property string customKeybind1: ""
        property string customKeybind1Command: ""
        property string customKeybind2: ""
        property string customKeybind2Command: ""
        property string customKeybind3: ""
        property string customKeybind3Command: ""
        property string customKeybind4: ""
        property string customKeybind4Command: ""
        property string customKeybind5: ""
        property string customKeybind5Command: ""
        property string customKeybind6: ""
        property string customKeybind6Command: ""
        property string customKeybind7: ""
        property string customKeybind7Command: ""
        property string customKeybind8: ""
        property string customKeybind8Command: ""
        property string customKeybind9: ""
        property string customKeybind9Command: ""
    }

    property int lastScreenVisibility

    function toggleFullscreen() {
        if (mainWindow.visibility != Window.FullScreen) {
            lastScreenVisibility = mainWindow.visibility
            mainWindow.visibility = Window.FullScreen
        } else {
            mainWindow.visibility = lastScreenVisibility
        }
    }

    Utils {
        id: utils
    }

    PlayerBackend {
        id: player
        anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 1

        Action {
            onTriggered: {
                appearance.scaleFactor += 0.1
            }
            shortcut: keybinds.increaseScale
        }
        Action {
            onTriggered: {
                appearance.scaleFactor = 1
            }
            shortcut: keybinds.resetScale
        }
        Action {
            onTriggered: {
                appearance.scaleFactor -= 0.1
            }
            shortcut: keybinds.decreaseScale
        }

        function startPlayer() {
            var args = Qt.application.arguments
            var len = Qt.application.arguments.length
            var argNo = 0

            if (!appearance.useMpvSubs) {
                player.setOption("sub-ass-override", "force")
                player.setOption("sub-ass", "off")
                player.setOption("sub-border-size", "0")
                player.setOption("sub-color", "0.0/0.0/0.0/0.0")
                player.setOption("sub-border-color", "0.0/0.0/0.0/0.0")
                player.setOption("sub-back-color", "0.0/0.0/0.0/0.0")
            }

            if (len > 1) {
                for (argNo = 1; argNo < len; argNo++) {
                    var argument = args[argNo]
                    if (argument.indexOf("KittehPlayer") !== -1) {
                        continue
                    }
                    if (argument.startsWith("--")) {
                        argument = argument.substr(2)
                        if (argument.length > 0) {
                            var splitArg = argument.split(/=(.+)/)
                            if (splitArg[0] == "screen"
                                    || splitArg[0] == "fs-screen") {
                                for (var i = 0, len = Qt.application.screens.length; i < len; i++) {
                                    var screen = Qt.application.screens[i]
                                    console.log("Screen Name: " + screen["name"]
                                                + " Screen Number: " + String(
                                                    i))
                                    if (screen["name"] == splitArg[1] || String(
                                                i) == splitArg[1]) {
                                        console.log("Switching to screen: " + screen["name"])
                                        mainWindow.screen = screen
                                        mainWindow.width = mainWindow.screen.width / 2
                                        mainWindow.height = mainWindow.screen.height / 2
                                        mainWindow.x = mainWindow.screen.virtualX
                                                + mainWindow.width / 2
                                        mainWindow.y = mainWindow.screen.virtualY
                                                + mainWindow.height / 2
                                        if (splitArg[0] == "fs-screen") {
                                            toggleFullscreen()
                                        }
                                        continue
                                    }
                                }
                                continue
                            }
                            if (splitArg[0] == "fullscreen") {
                                toggleFullscreen()
                                continue
                            }
                            if (splitArg[1] == undefined
                                    || splitArg[1].length == 0) {
                                splitArg[1] = "yes"
                            }
                            player.setOption(splitArg[0], splitArg[1])
                        }
                    } else {
                        player.playerCommand(Enums.Commands.AppendFile,
                                             argument)
                    }
                }
            }
        }
    }

    Item {
        id: controlsOverlay
        anchors.centerIn: player
        height: player.height
        width: player.width
        property bool controlsShowing: true
        z: 2

        function hideControls(force) {
            if (!menuBar.anythingOpen() || force) {
                controlsShowing = false
                mouseAreaPlayer.cursorShape = Qt.BlankCursor
            }
        }

        function showControls() {
            if (!controlsShowing) {
                controlsShowing = true
                mouseAreaPlayer.cursorShape = Qt.ArrowCursor
            }
        }

        MouseArea {
            id: mouseAreaBar

            width: parent.width
            height: (controlsBar.controls.height * 2) + controlsBar.progress.height
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            hoverEnabled: true
            onEntered: {
                mouseAreaPlayerTimer.stop()
            }
        }

        MouseArea {
            id: mouseAreaPlayer
            z: 1000
            focus: true
            width: parent.width
            anchors.bottom: mouseAreaBar.top
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: titleBar.bottom
            anchors.topMargin: 0
            hoverEnabled: true
            onDoubleClicked: {
                player.playerCommand(Enums.Commands.TogglePlayPause)
                toggleFullscreen()
            }
            Action {
                onTriggered: {
                    if (mainWindow.visibility == Window.FullScreen) {
                        toggleFullscreen()
                    }
                }
                shortcut: "Esc"
            }
            onClicked: {
                if (appearance.clickToPause) {
                    player.playerCommand(Enums.Commands.TogglePlayPause)
                }
            }
            Timer {
                id: mouseAreaPlayerTimer
                interval: 1000
                running: true
                repeat: false
                onTriggered: {
                    controlsOverlay.hideControls()
                }
            }
            onPositionChanged: {
                controlsOverlay.showControls()
                mouseAreaPlayerTimer.restart()
            }
        }

        MainMenu {
            id: menuBar
            visible: controlsOverlay.controlsShowing
        }

        Rectangle {
            id: titleBar
            height: menuBar.height
            anchors.right: parent.right
            anchors.left: menuBar.right
            anchors.top: parent.top
            visible: controlsOverlay.controlsShowing

            color: getAppearanceValueForTheme(appearance.themeName,
                                              "mainBackground")

            Text {
                id: titleLabel
                objectName: "titleLabel"
                text: translate.getTranslation("TITLE", i18n.language)
                color: "white"
                width: parent.width
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.top: parent.top
                font.family: appearance.fontName
                font.pixelSize: menuBar.height - (anchors.bottomMargin + anchors.topMargin)
                font.bold: true
                opacity: 1
                visible: controlsOverlay.controlsShowing
                         && ((!appearance.titleOnlyOnFullscreen)
                             || (mainWindow.visibility == Window.FullScreen))
                Connections {
                    target: player
                    enabled: true
                    onTitleChanged: function (title) {
                        titleLabel.text = title
                    }
                }
            }
        }

        ControlsBar {
            id: controlsBar
        }
    }
}
