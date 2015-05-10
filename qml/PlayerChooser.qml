import QtQuick 2.0
import QtQuick.Window 2.1
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Item {
    id: base
    state: "normal"

    RoundButton {
        id: play
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: 0.35*app.touchSize
            topMargin: 0.2*app.touchSize
        }
        onClicked: if (playerHandler.updatePlayers() === true) {
                       mainView.state = "scoreBoard"
                       playerHandler.doneOnce = true
                   } else {
                       popup.showPopup("Please Choose Players First")
                   }
        Image {
            anchors {
                centerIn: parent
                horizontalCenterOffset: 0.1*width
            }
            width: 0.6*parent.width
            height: 0.6*parent.height
            smooth: true
            source: "../images/play_button.svg"
        }
    }
    RoundButton {
        id: add
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 0.35*app.touchSize
            topMargin: 0.2*app.touchSize
        }
        DefaultText {
            anchors.fill: parent
            text: "+"
            font.pixelSize: 1.5*app.textLarge
            color: "white"
            font.family: "Arial"
        }
        onClicked: {
            base.state = "addPlayer"
            playerInput.m_textInput.forceActiveFocus()
        }
    }
    DefaultText {
        id: gameTitle
        text: playerHandler.doneOnce ? "Edit Players:" : "Choose Players:"
        lineHeight: 0.85
        anchors {
            left: add.right
            right: play.left
            leftMargin: 0.18*app.touchSize
            rightMargin: 0.18*app.touchSize
            top: add.top
        }
        height: 0.8*app.touchSize
        font.pixelSize: 0.85*app.textMedium
        color: "#333333"
    }
    DefaultText {
        anchors.centerIn: parent
        text: "No Stored\nPlayers"
        font.pixelSize: app.textMedium
        color: "#888888"
        visible: grid.model.length === 0
    }
    GridView {
        id: grid
        clip: true
        pressDelay: 20
        anchors {
            top: play.bottom
            bottom: footer.top
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 0.3*app.touchSize
            topMargin: 0.2*app.touchSize
        }
        property int m_item_per_row:
            Math.floor(0.8*app.width/cellWidth) !== 0
            ? Math.floor(0.8*app.width/cellWidth)
            : 1
        width: m_item_per_row < model.length
               ? m_item_per_row*cellWidth
               : model.length*cellWidth
        cellHeight: 0.9*app.touchSize
        cellWidth: playerHandler.doneOnce ? 2.65*app.touchSize+0.9*app.touchSize+0.15*app.touchSize : 2.65*app.touchSize
        model: playerHandler.storedPlayers
        delegate: Component {
            Item {
                id: delegate
                width: grid.cellWidth
                height: grid.cellHeight

                NewButton {
                    id: bigButton
                    width: playerHandler.doneOnce ? grid.cellWidth-removeButton.height-0.15*app.touchSize : grid.cellWidth-0.1*app.touchSize
                    height: grid.cellHeight-0.1*app.touchSize
                    anchors {
                        left: parent.left
                        leftMargin: 0.05*app.touchSize
                        verticalCenter: parent.verticalCenter
                    }
                    m_highlightColor: Style.color_orange_dark
                    m_selected: modelData.onGame
                    onClicked: if (modelData.onGame) {
                                   modelData.onGame = false
                                   playerHandler.removeIndex(modelData.qmlIndex, modelData.name)
                               } else {
                                   modelData.onGame = true
                                   playerHandler.setIndex(modelData.name)
                               }
                    m_buttonText: modelData.name
                    m_highlight: true
                }
                NewButton {
                    id: removeButton
                    anchors {
                        left: bigButton.right
                        leftMargin: 0.05*app.touchSize
                        verticalCenter: parent.verticalCenter
                    }
                    height: grid.cellHeight-0.1*app.touchSize
                    width: height
                    m_text.font.pixelSize: 1.3*app.textLarge
                    m_buttonText: "\u00D7"
                    m_text.color: "white"
                    m_bg.color: Style.color_blue_light
                    visible: playerHandler.doneOnce
                    onClicked: {
                        unstoreDialog.m_name = modelData.name;
                        unstoreDialog.state = "visible"
                    }
                }
            }
        }
    }
    /***********************************************************************
     * Footer
     */
    Item {
        id: footer
        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: 0.6*app.touchSize
            right: parent.right
            rightMargin: 0.6*app.touchSize
            bottomMargin: 0.4*app.touchSize
        }
        height: childrenRect.height
    }
    /***********************************************************************
     * Add player
     */
    MouseArea {
        id: blocker
        anchors.fill: parent
        visible: false
    }

    DropShadow {
        id: shadow
        anchors.fill: rounded
        fast: false
        horizontalOffset: 0
        verticalOffset: 0
        radius: 0.2*app.touchSize
        spread: 0.05
        samples: 24
        color: Qt.rgba(0,0,0,0.2)
        source: rounded
        transparentBorder: true
    }
    Rectangle {
        id: rounded
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
        border.width: 1
        border.color: "#888888"
        visible: true
        color: "white"

        RoundButton {
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 0.13*app.touchSize
                rightMargin: 0.13*app.touchSize
            }
            m_radius: 0.1*app.touchSize
            m_buttonText: "\u00D7"
            m_text.font.bold: false
            m_text.font.pixelSize: 1.1*app.textMedium
            width: 0.55*app.touchSize
            height: 0.55*app.touchSize
            onClicked: {
                Qt.inputMethod.hide()
                base.state = "normal"
            }
        }
        DefaultText {
            id: addPlayer
            text: "New Player:"
            anchors {
                top: parent.top
                topMargin: -0.1*app.touchSize
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: 0.9*app.textMedium
            color: "#333333"
            width: 3.9*app.touchSize
            height: 1.2*app.touchSize
        }
        Column {
            anchors {
                top: addPlayer.bottom
                horizontalCenter: addPlayer.horizontalCenter
            }
            height: childrenRect.height
            width: childrenRect.width
            Input {
                id: playerInput
                anchors.horizontalCenter: parent.horizontalCenter
                width: 2.8*app.touchSize
                height: 0.7*app.touchSize
                m_idleColor: "black"
                m_textColor: "#333333"
                m_title: "Name"
                inputValidator: RegExpValidator {}
                onInputValidated: {
                    playerHandler.storePlayer(input, rememberBox.m_checked);
                    m_textInput.text = "";
                    Qt.inputMethod.hide()
                    base.state = "normal"
                }
            }
            Item {
                width: 3.2*app.touchSize
                height: 1.5*app.touchSize
                anchors.horizontalCenter: parent.horizontalCenter
                MyCheckBox {
                    id: rememberBox
                    m_text: "Remember Player"
                    m_color: "#333333"
                    anchors {
                        centerIn: parent
                    }
                    width: 2.8*app.touchSize
                    height: 0.7*app.touchSize
                    m_textItem.font.pixelSize: app.textSmall
                    m_checked: playerHandler.rememberPlayers
                    onClicked: if (!playerHandler.rememberPlayers) {
                                   playerHandler.rememberPlayers = true
                               } else {
                                   playerHandler.rememberPlayers = false
                               }
                }
            }
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
    /***************************************************************************
     * States
     */
    states: [
        State {
            name: "addPlayer"
            PropertyChanges { target: rounded; visible: true}
            PropertyChanges { target: shadow; visible: true}
            PropertyChanges { target: mainView; focus: false}
            PropertyChanges { target: playerInput; focus: true}
            PropertyChanges { target: disabler; visible: true}
            PropertyChanges { target: blocker; visible: true}
        },
        State {
            name: "normal"
            PropertyChanges { target: rounded; visible: false}
            PropertyChanges { target: shadow; visible: false}
            PropertyChanges { target: mainView; focus: true}
            PropertyChanges { target: playerInput; focus: false}
            PropertyChanges { target: disabler; visible: false}
            PropertyChanges { target: blocker; visible: false}
        }
    ]
}
