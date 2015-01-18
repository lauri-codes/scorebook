import QtQuick 2.4
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Item {
    id: button
    height: app.touchSize*0.7
    width: 2*app.touchSize
    scale: buttonArea.pressed ? 0.92 : 1
    property alias m_text: text
    property bool m_blackBackground: false
    property bool m_pressed: buttonArea.pressed
    property bool m_highlight: true
    property string m_buttonText: ""
    signal clicked()

    DropShadow {
        id: shadow
        anchors.fill: parent
        fast: false
        horizontalOffset: 0
        verticalOffset: 0
        radius: 0.1*app.touchSize
        spread: 0.05
        samples: 24
        color: Qt.rgba(0,0,0,0.20)
        source: rounded
        transparentBorder: true
    }
    Rectangle {
        id: rounded
        anchors.fill: parent
        border.width: m_blackBackground ? 2 : 0
        border.color: "#444444"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#333333" }
            GradientStop { position: 0.45; color: "#333333" }
            GradientStop { position: 0.55; color: "#000000" }
            GradientStop { position: 1.0; color: "#000000" }
        }
        visible: true
    }
    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: 0.1
        visible: if (m_highlight) {
                     buttonArea.pressed
                 } else {
                     false
                 }
    }
    Text {
        id: text
        font.family: fontLoader.name
        font.weight: Font.Light
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 0.1*app.touchSize
            rightMargin: 0.1*app.touchSize
        }
        horizontalAlignment: Text.AlignHCenter
        text: button.m_buttonText
        font.pixelSize: app.textMedium*0.9
        elide: Text.ElideRight
        color: "#ffffff"
    }
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        onClicked: button.clicked()
    }
    FontLoader {
        id: fontLoader
        source: "../misc/Roboto-Light.ttf"
    }
}
