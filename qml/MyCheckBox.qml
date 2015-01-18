import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
    id: checkBox
    property bool m_checked: false
    property bool m_pressed: checkArea.pressed
    property bool m_enabled: true
    signal clicked()
    width: 3*app.touchSize
    height: app.touchSize
    property string m_text: "TICK"
    property string m_color: "white"
    property bool m_darkBg: false
    property bool m_showPress: true
    property alias m_textItem: textItem
    property alias m_mouseItem: checkArea

    DefaultText {
        id: textItem
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: check.left
        color: m_color
        text: m_text
        anchors.rightMargin: 0.1*app.touchSize
        horizontalAlignment: Text.AlignLeft
    }
    Image {
        id: check
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: height
        source: if (m_checked && m_pressed && m_showPress) {
                    m_darkBg ? "../images/checked_pressed_light.png" : "../images/checked_pressed.png"
                } else if (m_checked) {
                    m_darkBg ? "../images/checked_light.png" : "../images/checked.png"
                } else if (!m_checked && m_pressed && m_showPress) {
                    m_darkBg ? "../images/unchecked_pressed_light.png" : "../images/unchecked_pressed.png"
                } else if (!m_checked) {
                    m_darkBg ? "../images/unchecked_light.png" : "../images/unchecked.png"
                }
    }
    MouseArea {
        id: checkArea
        anchors.fill: parent
        onClicked: checkBox.clicked()
        enabled: m_enabled
    }
}
