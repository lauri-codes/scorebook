import QtQuick 2.4
import "../misc/Style.js" as Style

Rectangle {
    id: input
    height: 1.6*m_fontSize
    color: "transparent"
    property alias m_textInput: nameArea
    property bool m_deleteOnFocusLost: true
    property string m_activeColor: Style.color_blue_light
    property string m_idleColor: "black"
    property string m_textColor: "white"
    property string m_title: ""
    property real m_fontSize: app.textMedium*0.9
    property bool m_showContainer: true
    signal inputValidated(variant input)
    property variant inputValidator: IntValidator {}

    Item {
        id: androidTextInput
        visible: m_showContainer
        anchors.fill: parent
        property string m_color: m_idleColor

        Rectangle {
            id: bottomLine
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: parent.m_color
            height: 2
        }
        Rectangle {
            id: leftLine
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: parent.m_color
            width: 2
            height: 5
        }
        Rectangle {
            id: rightLine
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: parent.m_color
            width: 2
            height: 5
        }
    }
    TextInput {
        id: nameArea
        objectName: "input"
        clip: true
        onActiveFocusChanged: if (activeFocus ) {
                            androidTextInput.m_color = m_activeColor
                        } else {
                            androidTextInput.m_color = m_idleColor
                            if (input.m_deleteOnFocusLost) {
                                text = ""
                            }
                        }
        font.family: fontLoader.name
        font.weight: Font.Light
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: parent.height
        validator: input.inputValidator
        readOnly: false
        text: ""
        selectionColor: "#34bae5"
        font.pixelSize: m_fontSize
        color: m_textColor
        selectByMouse: true
        onAccepted: {
            if ( (displayText !== "")) {
                input.inputValidated(text);
            }
        }
        DefaultText {
            anchors.fill: parent
            text: m_title
            visible: !nameArea.focus
            font.pixelSize: app.textMedium*0.85
            opacity: 0.5
        }
    }
    FontLoader {
        id: fontLoader
        source: "../misc/Roboto-Light.ttf"
    }
    Rectangle {
        anchors.fill: nameArea
        color: Qt.rgba(0,0,0,0.07)
    }
}
