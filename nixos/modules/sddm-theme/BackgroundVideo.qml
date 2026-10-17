import QtQuick
import QtQuick.Window
import QtMultimedia
import Qt.labs.folderlistmodel

Item {
    anchors.fill: parent

    FolderListModel {
        id: bgFolder
        folder: Qt.resolvedUrl("backgrounds/")
        nameFilters: ["*.mp4", "*.webm"]
        showDirs: false
    }

    property bool playing: false

    function tryPlay() {
        if (!playing && bgFolder.count > 0) {
            var idx = Math.floor(Math.random() * bgFolder.count)
            player.source = bgFolder.get(idx, "fileURL")
            player.play()
            playing = true
        }
    }

    // Give the FolderListModel a moment to populate from the nix store path
    Timer { interval: 80; running: true; onTriggered: tryPlay() }
    Connections { target: bgFolder; function onCountChanged() { tryPlay() } }

    MediaPlayer {
        id: player
        videoOutput: videoOut
        loops: MediaPlayer.Infinite
    }

    VideoOutput {
        id: videoOut
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }
}
