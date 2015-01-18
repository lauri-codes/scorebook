import QtQuick 2.4
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Item {
    id: base
    height: 0.9*app.touchSize
    state: "closed"

    /***************************************************************************
     * Table
     */
    Item {
        id: clipper
        anchors {
            top: rounded.bottom
            topMargin: -0.05*app.touchSize
            bottom: parent.bottom
            bottomMargin: -0.05*app.touchSize
            left: parent.left
            right: parent.right
            rightMargin: 0.2*app.touchSize
            leftMargin: 0.2*app.touchSize
        }
        clip: true
        visible: false

        DropShadow {
            id: belowShadow
            anchors.fill: below
            fast: false
            horizontalOffset: 0
            verticalOffset: 0
            radius: 0.2*app.touchSize
            spread: 0.05
            samples: 24
            color: Qt.rgba(0,0,0,0.25)
            source: below
            transparentBorder: true
            visible: true
        }
        /***********************************************************************
         * Below
         */
        Rectangle {
            id: below
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: 1.9*app.touchSize
            border.width: 1
            border.color: "#777777"
            visible: true
            color: "#FFFFFF"

            Rectangle {
                anchors.fill: vertFlick
                color: "#F7F7F5"
                border {
                    color: "#DDDDDD"
                    width: 1
                }
            }
            Flickable {
                id: vertFlick
                clip: true
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: 0.23*app.touchSize
                    leftMargin: 0.2*app.touchSize
                    rightMargin: 0.2*app.touchSize
                }
                height: 0.75*app.touchSize // Cant anchor bottom to flickable parent...
                boundsBehavior: Flickable.DragOverBounds
                flickableDirection: Flickable.HorizontalFlick
                contentWidth: scores.width
                contentHeight: scores.height // Doesn't work if set to childrenRect.height

                Item {
                    id: scores
                    width: childrenRect.width
                    height: childrenRect.height
                    transform: Rotation {
                        id: rot2
                        origin.x: scores.width/2;
                        origin.y: scores.height/2;
                        axis.x: 0; axis.y: 1; axis.z:0
                        angle: 180
                    }
                    ListView {
                        orientation: ListView.Horizontal
                        width: childrenRect.width
                        height: childrenRect.height
                        model: modelData.scores
                        delegate: Score {
                            m_index: index
                            m_score: modelData.value
                        }
                    }
                }
            }
            Grid {
                columns: 3
                rows: 2
                rowSpacing: 0.02*app.touchSize
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    top: vertFlick.bottom
                    topMargin: 0.05*app.touchSize
                    bottomMargin: 0.1*app.touchSize
                }
                DefaultText {
                    font.pixelSize: 0.6*app.textSmall
                    color: "#888888"
                    text: "max:"
                    width: 1/3*below.width
                    height: 0.25*app.touchSize
                }
                DefaultText {
                    font.pixelSize: 0.6*app.textSmall
                    color: "#888888"
                    text: "mean:"
                    width: 1/3*below.width
                    height: 0.25*app.touchSize
                }
                DefaultText {
                    font.pixelSize: 0.6*app.textSmall
                    color: "#888888"
                    text: "min:"
                    width: 1/3*below.width
                    height: 0.25*app.touchSize
                }
                DefaultText {
                    font.pixelSize: 0.8*app.textMedium
                    color: "#333333"
                    text: modelData.max
                    width: 1/3*below.width
                    height: 0.8*app.textMedium
                }
                DefaultText {
                    font.pixelSize: 0.8*app.textMedium
                    color: "#333333"
                    text: modelData.average.toFixed(1)
                    width: 1/3*below.width
                    height: 0.8*app.textMedium
                }
                DefaultText {
                    font.pixelSize: 0.8*app.textMedium
                    color: "#333333"
                    text: modelData.min
                    width: 1/3*below.width
                    height: 0.8*app.textMedium
                }
            }
        }
    }
    /***************************************************************************
     * Header
     */
    DropShadow {
        id: shadow
        anchors.fill: rounded
        fast: false
        horizontalOffset: 0
        verticalOffset: 0
        radius: 0.2*app.touchSize
        spread: 0.05
        samples: 24
        color: Qt.rgba(0,0,0,0.25)
        source: rounded
        transparentBorder: true
        scale: openArea.pressed ? 1-(0.2*app.touchSize)/width : 1
    }
    Rectangle {
        id: rounded
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        height: 0.9*app.touchSize
        border.width: 1
        border.color: "#888888"
        visible: true
        color: "white"
        scale: openArea.pressed ? 1-(0.2*app.touchSize)/width : 1

        Rectangle {
            id: colorBar
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                margins: 1
            }
            width: 0.37*app.touchSize
            color: modelData.roundNumber === playerHandler.roundNumber ? Style.color_blue_light : Style.color_orange

            DefaultText {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -0.012*app.touchSize
                color: "white"
                rotation: -90
                text: modelData.pseudoRank
                font.pixelSize: 0.34*app.touchSize
            }
        }

        DefaultText {
            id: playerName
            text: modelData.name
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: colorBar.right
                leftMargin: 0.2*app.touchSize
            }
            font.pixelSize: 0.85*app.textMedium
            color: "#333333"
            width: 2*app.touchSize
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
        }
        DefaultText {
            id: score
            text: modelData.totalScore
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: scoreAdder.left
                rightMargin: 0.2*app.touchSize
            }
            font.pixelSize: 0.85*app.textMedium
            color: "#333333"
            width: 1.1*app.touchSize
        }
        Input {
            id: scoreAdder
            m_deleteOnFocusLost: false
            m_textColor: "#333333"
            m_fontSize: 0.75*app.textMedium
            onInputValidated: {
                modelData.addScore(input)
                m_textInput.text = ""
            }
            m_textInput.inputMethodHints: Qt.ImhFormattedNumbersOnly
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 0.2*app.touchSize
            }
            height: 0.55*app.touchSize
            width: 0.9*app.touchSize
        }
        MouseArea {
            id: openArea
            anchors {
                left: parent.left
                right: score.right
                top: parent.top
                bottom: parent.bottom
            }
            onClicked: base.state === "closed" ? base.state = "open" : base.state = "closed"
        }
        MouseArea {
            id: insertArea
            anchors {
                left: score.right
                leftMargin: -0.2*app.touchSize
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            onPressed: scoreAdder.m_textInput.forceActiveFocus()
        }
    }
    /***************************************************************************
     * States
     */
    states: [
        State {
            name: "closed"
            PropertyChanges { target: base; height: rounded.height}
        },
        State {
            name: "open"
            PropertyChanges { target: base; height: rounded.height+below.height-0.1*app.touchSize}
        }
    ]
    /***************************************************************************
     * Transitions
     */
    transitions: [
      Transition {
          onRunningChanged: if (running) {
                                clipper.visible = true
                            }

          from: "closed"; to: "open"
          NumberAnimation {
              id: openAnimation
              target: base
              property: "height"
              duration: 200
              easing.type: Easing.InOutQuad
          }
      },
        Transition {
            onRunningChanged: if (!running) {
                                  clipper.visible = false
                              }
            from: "open"; to: "closed"
            NumberAnimation {
                id: closeAnimation
                target: base
                property: "height"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
