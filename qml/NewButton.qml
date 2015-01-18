import QtQuick 2.4
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Item {
    id: button
    height: app.touchSize*0.7
    width: 2*app.touchSize
    scale: buttonArea.pressed ? 0.92 : 1
    property bool m_selected: false
    property alias m_text: text
    property alias m_bg: rounded
    property bool m_blackBackground: false
    property bool m_highlight: false
    property string m_highlightColor: Style.color_blue_light
    property bool m_pressed: buttonArea.pressed
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
        visible: true
        color: "white"
    }
    Rectangle {
        anchors.fill: parent
        color: m_highlightColor
        opacity: 1
        visible: if (m_highlight) {
                     if (buttonArea.pressed){
                         true
                     } else if (m_selected) {
                         true
                     } else {
                         false
                     }
                 } else {
                     false
                 }
    }
    Rectangle {
        id: border
        anchors.fill: parent
        border.width: 1
        border.color: "#888888"
        color: "transparent"
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
        font.pixelSize: app.textMedium*0.85
        elide: Text.ElideRight
        color: (m_selected || m_pressed) ? "white" : "#333333"
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
