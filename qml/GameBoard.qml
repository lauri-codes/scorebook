import QtQuick 2.4
import "../misc/Style.js" as Style

Item {
    id: base
    anchors {
        fill: parent
    }
    RoundButton {
        id: refreshButton
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 0.35*app.touchSize
            topMargin: 0.2*app.touchSize
        }
        Image {
            anchors.fill: parent
            anchors.margins: 0.08*app.touchSize
            smooth: true
            source: "../images/refresh_symbol.svg"
        }
        onClicked: restartDialog.state = "visible"
    }
    RoundButton {
        id: menuButton
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: 0.35*app.touchSize
            topMargin: 0.2*app.touchSize
        }
        onClicked: {
            menu.state = menu.state === "open" ? "closed" : "open";
            Qt.inputMethod.hide()
        }
        Column {
            width: childrenRect.width
            height: childrenRect.height
            spacing: 0.06*app.touchSize
            anchors.centerIn: parent
            Rectangle {
                color: "white"
                width: 0.4*app.touchSize
                height: 0.06*app.touchSize
            }
            Rectangle {
                color: "white"
                width: 0.4*app.touchSize
                height: 0.06*app.touchSize
            }
            Rectangle {
                color: "white"
                width: 0.4*app.touchSize
                height: 0.06*app.touchSize
            }
        }
    }
    Flickable {
        id: flick1
        anchors {
            top: refreshButton.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 0.2*app.touchSize
            bottomMargin: 0.35*app.touchSize
            leftMargin: 0.35*app.touchSize
            rightMargin: 0.35*app.touchSize
        }
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        contentWidth: contentItem.childrenRect.width
        contentHeight: contentItem.childrenRect.height
        clip: true

        ListView {
            height: childrenRect.height
            width: childrenRect.width
            model: playerHandler.players
            delegate: PlayerCard {
                width: flick1.width
            }
            clip: false
        }
    }
    MouseArea {
        id: disabler
        anchors.fill: parent
        onPressed: {
            disabler.forceActiveFocus();
            mouse.accepted = false
        }
        onClicked: {
            disabler.forceActiveFocus();
            mouse.accepted = false
        }
        propagateComposedEvents: true
    }
}
