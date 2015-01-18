import QtQuick 2.4
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Item {
    id: base
    state: "closed"
    transformOrigin: Item.Bottom
    visible: false

    DropShadow {
        id: shadow
        anchors.fill: bg
        fast: false
        horizontalOffset: 0
        verticalOffset: 0
        radius: 0.2*app.touchSize
        spread: 0.05
        samples: 24
        color: Qt.rgba(0,0,0,0.25)
        source: bg
        transparentBorder: true
    }
    Rectangle {
        id: bg
        height: childrenRect.height
        width: parent.width
        visible: true
        color: "#333333"

        Column {
            id: list
            width: parent.width
            height: childrenRect.height

            /****************************************************************************/
            // Edit Players
            Item {
                width: parent.width
                height: 0.8*app.touchSize
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        base.state = "closed"
                        if (playerHandler.doneOnce) {
                                   if (mainView.state === "scoreBoard") {
                                       mainView.state = "playerChooser"
                                   }
                               }
                    }
                    Rectangle {
                        anchors.fill: parent
                        color: Style.color_blue_light
                        opacity: 0.4
                        visible: parent.pressed
                    }
                }
                DefaultText {
                    anchors.fill: parent
                    text: "Edit Players"
                    color: "white"
                }

                Rectangle {
                    color: Qt.rgba(1,1,1,0.4)
                    height: 1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
            /****************************************************************************/
            // Edit Scores
            Item {
                id: tester
                width: parent.width
                height: 0.8*app.touchSize

                MyCheckBox {
                    id: editTick
                    m_text: "Score editing"
                    m_checked: playerHandler.canEdit
                    height: parent.height
                    anchors.centerIn: parent
                    width: 3.28*app.touchSize
                    m_darkBg: true
                    m_showPress: false
                    m_enabled: false
                }
                MouseArea {
                    id: scoreEditMouseArea
                    anchors.fill: parent
                    onClicked: if (!playerHandler.canEdit) {
                                   playerHandler.canEdit = true
                               } else {
                                   playerHandler.canEdit = false
                               }
                }
                Rectangle {
                    anchors.fill: parent
                    color: Style.color_blue_light
                    opacity: 0.4
                    visible: scoreEditMouseArea.pressed
                }
                Rectangle {
                    color: Qt.rgba(1,1,1,0.4)
                    height: 1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
            /****************************************************************************/
            // Exit Button
            Item {
                width: parent.width
                height: 0.8*app.touchSize
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        base.state = "closed"
                        quitDialog.state = "visible"
                    }
                    Rectangle {
                        anchors.fill: parent
                        color: Style.color_blue_light
                        opacity: 0.5
                        visible: parent.pressed
                    }
                }
                DefaultText {
                    anchors.fill: parent
                    text: "Quit"
                    color: "white"
                }
                Rectangle {
                    color: Qt.rgba(1,1,1,0.4)
                    height: 1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
        }
    }
    /***************************************************************************
     * States
     */
    states: [
        State {
            name: "closed"
            PropertyChanges { target: base; opacity: 0}
            PropertyChanges { target: base; scale: 0.9}
        },
        State {
            name: "open"
            PropertyChanges { target: base; opacity: 1}
            PropertyChanges { target: base; scale: 1}
        }
    ]
    /***************************************************************************
     * Transitions
     */
    transitions: [
        Transition {
            from: "closed"; to: "open"
            onRunningChanged: if (running) {
                                  base.visible = true
                              }
            NumberAnimation {
                id: openAnimation
                onStarted: {base.visible = true; console.log("Visible")}
                target: base
                property: "opacity"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                id: openScaleAnimation
                target: base
                property: "scale"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "open"; to: "closed"
            onRunningChanged: if (!running) {
                                  base.visible = false
                              }
            NumberAnimation {
                id: closeAnimation
                target: base
                property: "opacity"
                duration: 100
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                id: closeScaleAnimation
                target: base
                property: "scale"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
