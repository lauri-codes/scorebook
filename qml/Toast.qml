import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
    id: toast
    objectName: "toast"
    visible: false
    width: toastText.paintedWidth*1.2
    height: toastText.paintedHeight*1.2
    property string m_text: ""

    RectangularGlow {
        id: shadow
        anchors.fill: toast
        glowRadius: app.touchSize*0.2
        spread: 0.0
        color: "black"
        cornerRadius: 0
        opacity: 0.3
    }
    Rectangle {

        anchors.fill: parent
        color: "#333333"

        SequentialAnimation {
            id: toastAnimation
            NumberAnimation {
                target: toast
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
            PauseAnimation { duration: m_text.length*60 }
            NumberAnimation {
                target: toast
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
            onStopped: toast.visible = false
        }
        DefaultText {
            id: toastText
            anchors.fill: parent
            anchors.margins: 0.1*toast.height
            text: m_text
            font.pixelSize: app.textSmall
            color: "white"
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: toast.visible = false
    }
    function showPopup(text) {
        m_text = text;
        toastAnimation.restart()
        visible = true;
    }
}
