import QtQuick 2.4
import QtQuick.Window 2.1
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Item {
    id: mainView
    anchors.fill: parent
    state: "playerChooser"
    property bool m_acceptBack: true
    focus: true
    Keys.onReleased: {
        // Handle back-key
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
            event.accepted = true
            if (quitDialog.state === "visible") {
                quitDialog.state = "hidden"
            } else if (restartDialog.state === "visible") {
                restartDialog.state = "hidden"
            } else if (unstoreDialog.state === "visible") {
                unstoreDialog.state = "hidden"
            } else if (menu.state === "open") {
                menu.state = "closed"
            } else if (playerChooser.state === "addPlayer") {
                playerChooser.state = "normal"
            } else {
                quitDialog.state = "visible"
            }
        }
        // Open menu
        if (event.key === Qt.Key_F1 || event.key === Qt.Key_Menu) {
            event.accepted = true
            Qt.inputMethod.hide()
            menu.state = menu.state === "open" ? "closed" : "open"
        }
    }
    Item {
        id: swipeAnchor
        anchors.fill: parent
    }
    // Radial Gradient
    Item {
        anchors.fill: parent
        RadialGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.5; color: "#999999" }
            }
        }
    }
    GameBoard {
        id: gameBoard
        visible: mainView.state === "scoreBoard"
    }
    /***************************************************************************
     * Player Chooser
     */
    PlayerChooser {
        id: playerChooser
        anchors {
            fill: parent
        }
    }

    /***************************************************************************
     * Menu
     */
    Menu {
        id: menu
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: 4.15*app.touchSize
        height: childrenRect.height
    }
    Prompt {
        id: quitDialog
        onYes: Qt.quit()
        onNo: state = "hidden"
        m_text: "Are you sure you want to exit the application?"
    }
    Prompt {
        id: unstoreDialog
        property string m_name: ""
        onYes: {playerHandler.unstorePlayer(m_name); state = "hidden"}
        onNo: state = "hidden"
        m_text: "Are you sure you want to remove all information related to player "+m_name+"?"
    }
    Prompt {
        id: restartDialog
        onYes: {playerHandler.restart(); state = "hidden"}
        onNo: state = "hidden"
        m_text: "Are you sure you want to restart the game with current players?"
    }
    /***************************************************************************
     * Toast
     */
    Toast {
        id: popup
        objectName: "toast"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0.5*app.touchSize
    }
    /***************************************************************************
     * States
     */
    states: [
        State {
            name: "playerChooser"
            PropertyChanges { target: playerChooser; visible: true}
        },
        State {
            name: "scoreBoard"
            PropertyChanges { target: playerChooser; visible: false}
        }
    ]
}
