import QtQuick
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Item {
    // Wayland cursor fix
    MouseArea { anchors.fill: parent; cursorShape: Qt.ArrowCursor; z: -1 }

    id: root
    width: Screen.width
    height: Screen.height
    readonly property real s: Screen.height / 768

    property bool isQuickshell: typeof sddm === "undefined" || sddm.hostName === undefined
    property int  userIndex:    (typeof userModel    !== "undefined" && userModel.lastIndex    >= 0) ? userModel.lastIndex    : 0
    property int  sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property string errorMsg:   ""
    property real ui:           0

    // ── Colors: Stylix build-time defaults, overridden at runtime by Noctalia ──
    property color colBase:     "@BASE00@"
    property color colMantle:   "@BASE01@"
    property color colSurface0: "@BASE02@"
    property color colSurface1: "@BASE03@"
    property color colOverlay0: "@BASE04@"
    property color colText:     "@BASE05@"
    property color colSubtext0: "@BASE06@"
    property color colLavender: "@BASE07@"
    property color colRed:      "@BASE08@"
    property color colBlue:     "@BASE0D@"
    property color colMauve:    "@BASE0E@"

    function loadNoctaliaColors() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "file:///var/cache/sddm-theme/noctalia-colors.json", false)
        try {
            xhr.send()
            if (xhr.responseText && xhr.responseText.length > 2) {
                var p = JSON.parse(xhr.responseText)
                if (p.base)     colBase     = p.base
                if (p.mantle)   colMantle   = p.mantle
                if (p.surface0) colSurface0 = p.surface0
                if (p.surface1) colSurface1 = p.surface1
                if (p.overlay0) colOverlay0 = p.overlay0
                if (p.text)     colText     = p.text
                if (p.subtext0) colSubtext0 = p.subtext0
                if (p.lavender) colLavender = p.lavender
                if (p.red)      colRed      = p.red
                if (p.blue)     colBlue     = p.blue
                if (p.mauve)    colMauve    = p.mauve
            }
        } catch(e) {
            // no runtime colors file — Stylix build-time colors remain active
        }
    }

    // Helper model proxies
    ListView {
        id: sessionHelper
        model: typeof sessionModel !== "undefined" ? sessionModel : null
        currentIndex: root.sessionIndex
        opacity: 0; width: 1; height: 1; z: -100
        delegate: Item { property string sName: model.name || "" }
    }
    ListView {
        id: userHelper
        model: typeof userModel !== "undefined" ? userModel : null
        currentIndex: root.userIndex
        opacity: 0; width: 1; height: 1; z: -100
        delegate: Item {
            property string uName:  model.realName || model.name || ""
            property string uLogin: model.name || ""
        }
    }

    // Init
    Component.onCompleted: {
        loadNoctaliaColors()
        fadeIn.start()
        if (typeof keyboard !== "undefined") keyboard.numLock = true
    }
    NumberAnimation {
        id: fadeIn; target: root; property: "ui"
        from: 0; to: 1; duration: 1400; easing.type: Easing.OutCubic
    }
    Timer { interval: 300; running: true; onTriggered: passwordInput.forceActiveFocus() }

    Connections {
        target: typeof sddm !== "undefined" ? sddm : null
        function onLoginFailed() {
            root.errorMsg = "ACCESS DENIED"
            passwordInput.text = ""
            shakeAnim.start()
            errorClearTimer.start()
        }
    }
    Timer { id: errorClearTimer; interval: 3000; onTriggered: root.errorMsg = "" }

    function doLogin() {
        if (root.isQuickshell) return
        var uname = (userHelper.currentItem && userHelper.currentItem.uLogin !== "")
                    ? userHelper.currentItem.uLogin
                    : (typeof userModel !== "undefined" ? userModel.lastUser : "")
        sddm.login(uname, passwordInput.text, root.sessionIndex)
    }

    // ── Background ────────────────────────────────────────────────────────────
    Rectangle { anchors.fill: parent; color: root.colBase; z: -1000 }

    Loader { anchors.fill: parent; z: -900; source: "BackgroundVideo.qml" }

    RadialGradient {
        anchors.fill: parent; z: -700; opacity: 0.5
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#c0000000" }
        }
    }

    Rectangle {
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 240 * s; z: -600; opacity: 0.7
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#ee000000" }
        }
    }

    // ── Particles ─────────────────────────────────────────────────────────────
    Repeater {
        model: 22
        delegate: Item {
            id: ptcl
            property real startX:  Math.random() * root.width
            property real drift:   (Math.random() - 0.5) * 140
            property real dur:     7500 + Math.random() * 9000
            property real sz:      (3 + Math.random() * 5) * s
            property real delayMs: Math.random() * 10000
            property real rot:     Math.random() * 360

            x: startX; y: -20; width: sz; height: sz * 0.55; opacity: 0; z: -500

            Rectangle {
                anchors.fill: parent; radius: width * 0.5; rotation: ptcl.rot
                color: Qt.rgba(root.colMauve.r, root.colMauve.g, root.colMauve.b, 0.5)
            }
            SequentialAnimation {
                running: true; loops: Animation.Infinite
                PauseAnimation { duration: ptcl.delayMs }
                ParallelAnimation {
                    NumberAnimation { target: ptcl; property: "y"; from: -20; to: root.height + 20; duration: ptcl.dur; easing.type: Easing.InOutSine }
                    NumberAnimation { target: ptcl; property: "x"; from: ptcl.startX; to: ptcl.startX + ptcl.drift; duration: ptcl.dur; easing.type: Easing.InOutSine }
                    SequentialAnimation {
                        NumberAnimation { target: ptcl; property: "opacity"; to: 0.65; duration: 900 }
                        PauseAnimation { duration: ptcl.dur - 1800 }
                        NumberAnimation { target: ptcl; property: "opacity"; to: 0; duration: 900 }
                    }
                    NumberAnimation { target: ptcl; property: "rotation"; from: ptcl.rot; to: ptcl.rot + 540; duration: ptcl.dur }
                }
            }
        }
    }

    // ── Clock — top left (Enfield layout) ─────────────────────────────────────
    Column {
        anchors { top: parent.top; left: parent.left; topMargin: 56 * s; leftMargin: 64 * s }
        spacing: 8 * s
        opacity: root.ui

        Text {
            id: clockText
            text: Qt.formatTime(new Date(), "HH:mm")
            color: root.colText
            font.family: "JetBrainsMono Nerd Font Mono"
            font.pixelSize: 80 * s; font.weight: Font.Light
            layer.enabled: true
            layer.effect: DropShadow { color: "#60000000"; radius: 18 * s; samples: 25; verticalOffset: 4 * s; transparentBorder: true }
            Timer { interval: 1000; running: true; repeat: true; onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm") }
        }

        Row {
            spacing: 10 * s
            Rectangle {
                width: 6 * s; height: 6 * s; radius: 3 * s; color: root.colMauve
                anchors.verticalCenter: parent.verticalCenter
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.25; duration: 1800; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0;  duration: 1800; easing.type: Easing.InOutSine }
                }
            }
            Text {
                id: dateText
                text: Qt.formatDate(new Date(), "dddd, MMMM d").toUpperCase()
                color: root.colMauve
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 12 * s; font.letterSpacing: 3 * s; font.weight: Font.Light
                anchors.verticalCenter: parent.verticalCenter
                Timer { interval: 60000; running: true; repeat: true; onTriggered: dateText.text = Qt.formatDate(new Date(), "dddd, MMMM d").toUpperCase() }
            }
        }
    }

    // ── Login panel — bottom center (Material You Dark style) ─────────────────
    Column {
        id: loginPanel
        anchors { bottom: parent.bottom; bottomMargin: 96 * s; horizontalCenter: parent.horizontalCenter }
        spacing: 0
        width: 320
        opacity: root.ui

        transform: Translate { id: shakeTranslate }
        SequentialAnimation {
            id: shakeAnim
            NumberAnimation { target: shakeTranslate; property: "x"; to:  16; duration: 55 }
            NumberAnimation { target: shakeTranslate; property: "x"; to: -14; duration: 55 }
            NumberAnimation { target: shakeTranslate; property: "x"; to:  10; duration: 55 }
            NumberAnimation { target: shakeTranslate; property: "x"; to:  -6; duration: 55 }
            NumberAnimation { target: shakeTranslate; property: "x"; to:   0; duration: 55 }
        }

        Rectangle {
            width: parent.width
            height: cardCol.implicitHeight + 16
            radius: 14
            color: Qt.rgba(root.colMantle.r, root.colMantle.g, root.colMantle.b, 0.88)

            Rectangle {
                anchors.fill: parent; radius: parent.radius; color: "transparent"
                border.color: Qt.rgba(root.colMauve.r, root.colMauve.g, root.colMauve.b, 0.18)
                border.width: 1
            }

            Column {
                id: cardCol
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
                spacing: 7

                // Header
                Row {
                    spacing: 7
                    Rectangle {
                        width: 6; height: 6; radius: 3
                        color: root.colMauve; opacity: 0.55
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "SYSTEM  ·  UNLOCK"
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 9; font.bold: true; font.letterSpacing: 1
                        color: root.colOverlay0
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Password pill
                Rectangle {
                    width: parent.width; height: 36; radius: 18
                    color: root.colSurface0
                    border.color: root.errorMsg !== ""
                                  ? root.colRed
                                  : (passwordInput.activeFocus ? root.colMauve : "transparent")
                    border.width: (passwordInput.activeFocus || root.errorMsg !== "") ? 2 : 0
                    Behavior on border.color { ColorAnimation { duration: 200 } }

                    TextInput {
                        id: passwordInput
                        anchors { fill: parent; leftMargin: 20; rightMargin: 20 }
                        font.family: "JetBrainsMono Nerd Font Mono"
                        font.pixelSize: 15; font.letterSpacing: 4
                        color: root.colText
                        echoMode: TextInput.Password; passwordCharacter: "•"
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        clip: true; focus: true
                        cursorVisible: false; cursorDelegate: Item { width: 0; height: 0 }
                        selectionColor: Qt.rgba(root.colMauve.r, root.colMauve.g, root.colMauve.b, 0.35)

                        property bool wasClicked: false
                        onActiveFocusChanged: if (!activeFocus && text.length === 0) wasClicked = false
                        onTextEdited: root.errorMsg = ""
                        Keys.onReturnPressed: root.doLogin()
                        Keys.onEnterPressed:  root.doLogin()

                        Text {
                            anchors.centerIn: parent
                            text: root.errorMsg !== "" ? root.errorMsg : "PASSWORD REQUIRED"
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.5
                            color: root.errorMsg !== "" ? root.colRed : root.colOverlay0
                            opacity: (passwordInput.text === "" && (!passwordInput.activeFocus || !passwordInput.wasClicked)) ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                            Behavior on color   { ColorAnimation  { duration: 150 } }
                        }

                        Rectangle {
                            id: blinkCursor
                            width: 2; height: 16; color: root.colMauve
                            anchors.verticalCenter: parent.verticalCenter
                            x: passwordInput.cursorRectangle.x
                            visible: passwordInput.activeFocus && (passwordInput.text.length > 0 || passwordInput.wasClicked) && root.errorMsg === ""
                            SequentialAnimation {
                                loops: Animation.Infinite; running: blinkCursor.visible
                                NumberAnimation { target: blinkCursor; property: "opacity"; from: 1; to: 0; duration: 450; easing.type: Easing.InOutQuad }
                                NumberAnimation { target: blinkCursor; property: "opacity"; from: 0; to: 1; duration: 450; easing.type: Easing.InOutQuad }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.IBeamCursor
                            onClicked: { passwordInput.wasClicked = true; passwordInput.forceActiveFocus() }
                        }
                    }
                }

                // User pill + Unlock pill row
                Row {
                    width: parent.width; spacing: 10

                    Rectangle {
                        id: userPill
                        width: userPillText.implicitWidth + 20
                        height: 22; radius: 11
                        color: userMa.pressed     ? root.colBase
                             : userMa.containsMouse ? root.colSurface1
                             : root.colSurface0
                        Behavior on color { ColorAnimation { duration: 150 } }
                        scale: userMa.pressed ? 0.93 : (userMa.containsMouse ? 1.03 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

                        Text {
                            id: userPillText; anchors.centerIn: parent
                            text: ((userHelper.currentItem && userHelper.currentItem.uName)
                                   ? userHelper.currentItem.uName
                                   : (typeof userModel !== "undefined" ? userModel.lastUser : "USER")).toUpperCase()
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 9; font.bold: true; font.letterSpacing: 1
                            color: root.colSubtext0
                        }

                        MouseArea {
                            id: userMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (typeof userModel !== "undefined" && userModel.rowCount() > 1)
                                    root.userIndex = (root.userIndex + 1) % userModel.rowCount()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width - userPill.width - 10
                        height: 22; radius: 11
                        color: Qt.rgba(root.colMauve.r, root.colMauve.g, root.colMauve.b,
                                       loginMa.pressed ? 0.55 : (loginMa.containsMouse ? 0.40 : 0.22))
                        Behavior on color { ColorAnimation { duration: 150 } }
                        scale: loginMa.pressed ? 0.93 : (loginMa.containsMouse ? 1.03 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

                        Row {
                            anchors.centerIn: parent; spacing: 5
                            Text {
                                text: "UNLOCK"
                                font.family: "JetBrainsMono Nerd Font Mono"
                                font.pixelSize: 9; font.bold: true; font.letterSpacing: 1.5
                                color: root.colText; anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: "›"
                                font.family: "JetBrainsMono Nerd Font Mono"; font.pixelSize: 14
                                color: root.colText; anchors.verticalCenter: parent.verticalCenter
                                transform: Translate {
                                    x: loginMa.containsMouse ? 3 : 0
                                    Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                                }
                            }
                        }

                        MouseArea {
                            id: loginMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: root.doLogin()
                        }
                    }
                }
            }
        }
    }

    // ── Bottom bar — session + power ──────────────────────────────────────────
    Item {
        anchors { bottom: parent.bottom; bottomMargin: 32 * s; left: parent.left; right: parent.right; leftMargin: 48 * s; rightMargin: 48 * s }
        height: 28 * s
        opacity: root.ui * 0.85

        Item {
            visible: !root.isQuickshell
            anchors { left: parent.left; verticalCenter: parent.verticalCenter }
            width: sessionRow.implicitWidth; height: sessionRow.implicitHeight

            Row {
                id: sessionRow; spacing: 8 * s
                opacity: sessionMa.containsMouse ? 1.0 : 0.65
                scale:   sessionMa.containsMouse ? 1.05 : 1.0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Behavior on scale   { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                transform: Translate { id: sTrans }

                Rectangle {
                    width: 5 * s; height: 5 * s; radius: 2.5 * s; color: root.colMauve; opacity: 0.55
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: sessionLabel
                    text: (sessionHelper.currentItem && sessionHelper.currentItem.sName)
                          ? sessionHelper.currentItem.sName : "Session"
                    color: root.colSubtext0
                    font.family: "JetBrainsMono Nerd Font Mono"; font.pixelSize: 11 * s; font.letterSpacing: 1 * s
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: sessionMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (typeof sessionModel !== "undefined" && sessionModel.rowCount() > 0)
                        sSlide.start()
                }
            }
            SequentialAnimation {
                id: sSlide
                ParallelAnimation {
                    NumberAnimation { target: sessionLabel; property: "opacity"; to: 0;      duration: 120 }
                    NumberAnimation { target: sTrans;       property: "x";       to: 10 * s; duration: 120 }
                }
                ScriptAction { script: root.sessionIndex = (root.sessionIndex + 1) % sessionModel.rowCount() }
                ParallelAnimation {
                    NumberAnimation { target: sessionLabel; property: "opacity"; to: 0.65; duration: 180 }
                    NumberAnimation { target: sTrans;       property: "x";       to: 0;    duration: 180 }
                }
            }
        }

        Row {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            spacing: 28 * s
            Repeater {
                model: [ { label: "REBOOT", act: 0 }, { label: "SHUTDOWN", act: 1 } ]
                delegate: Text {
                    property var d: modelData
                    text: d.label
                    color: root.colSubtext0
                    font.family: "JetBrainsMono Nerd Font Mono"; font.pixelSize: 11 * s; font.letterSpacing: 1.5 * s
                    opacity: pMa.containsMouse ? 1.0 : 0.5
                    scale:   pMa.containsMouse ? 1.1 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    Behavior on scale   { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                    MouseArea {
                        id: pMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!root.isQuickshell) {
                                if (d.act === 0) sddm.reboot()
                                else             sddm.powerOff()
                            }
                        }
                    }
                }
            }
        }
    }
}
