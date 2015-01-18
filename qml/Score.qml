import QtQuick 2.4
import "../misc/Style.js" as Style

Item {
    property bool m_roundWinner
    property int m_score
    height: 0.70*app.touchSize
    width: 0.9*app.touchSize
    property int m_index: 0
    transform: Rotation {
                id: rot
                origin.x: scoreChanger.width/2;
                origin.y: scoreChanger.height/2;
                axis.x: 0; axis.y: 1; axis.z:0
                angle: 180
            }
    DefaultText {
        id: roundNumber
        anchors {
            top: parent.top
            topMargin: -0.03*app.touchSize
            left: parent.left
            right: parent.right
            bottom: parent.verticalCenter
        }
        color: "#888888"
        font.pixelSize: 0.6*app.textSmall
        text: m_index+1
    }
    TextInput {
        id: scoreChanger
        anchors {
            left: parent.left
            right: parent.right
            top: parent.verticalCenter
            topMargin: -0.13*app.touchSize
            bottom: parent.bottom
        }
        font.family: fontLoader.name
        font.weight: Font.Light
        font.pixelSize: app.textMedium*0.7
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        readOnly: !playerHandler.canEdit
        color: Style.color_blue_dark
        text: m_score.toString()
        validator: IntValidator {}
        onAccepted: {
            modelData.value = parseInt(text)
        }
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }
    FontLoader {
        id: fontLoader
        source: "../misc/Roboto-Light.ttf"
    }
    Rectangle {
        anchors.right: parent.right
        height: parent.height
        width: 1
        color: "#DDDDDD"
    }
    Rectangle {
        anchors.right: parent.left
        height: parent.height
        width: 1
        color: "#DDDDDD"
    }
}
