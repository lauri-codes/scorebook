import QtQuick 2.4
import QtGraphicalEffects 1.0
import "../misc/Style.js" as Style

Rectangle {
    id: root
    state: "hidden"
    anchors.fill: parent
    color: "transparent"
    property string m_text: "Text here"

    signal yes()
    signal no()

    MouseArea {
        anchors.fill: parent
    }
    DropShadow {
        id: shadow
        anchors.fill: rounded
        fast: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: 0.2*app.touchSize
        spread: 0.05
        samples: 24
        color: Qt.rgba(0,0,0,0.2)
        source: rounded
        transparentBorder: true

        Item {
            id: content
            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;
            }
            height: 0.6*parent.height

            DefaultText {
                id: dialogText
                anchors.fill: parent
                anchors.margins: 0.2*app.touchSize
                wrapMode: Text.WordWrap
                text: qsTr(m_text)
                color: "#333333"
                font.pixelSize: 0.8*app.textMedium
            }
        }
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0.25*app.touchSize
            height: 0.35*parent.height

            RoundButton {
                m_blackBackground: true
                height: 0.8*app.touchSize
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left;
                    right: parent.horizontalCenter
                    leftMargin: 0.5*app.touchSize
                    rightMargin: 0.35*app.touchSize
                }
                m_bgColor: Style.color_orange_dark
                m_buttonText: "Yes"
                onClicked: root.yes()
                m_text.font.pixelSize: 0.8*app.textMedium
            }
            RoundButton {
                m_blackBackground: true
                height: 0.8*app.touchSize
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right;
                    left: parent.horizontalCenter
                    rightMargin: 0.5*app.touchSize
                    leftMargin: 0.35*app.touchSize
                }
                m_bgColor: Style.color_orange_dark
                m_buttonText: "No"
                onClicked: root.no()
                m_text.font.pixelSize: 0.8*app.textMedium
            }
        }
    }
    Rectangle {
        id: rounded
        anchors.centerIn: parent
        width: 4.5*app.touchSize
        height: 3*app.touchSize
        border.width: 1
        border.color: "#888888"
        visible: false
        color: "white"
    }
    states: [
        State {
            name: "hidden"
            PropertyChanges { target: root; visible: false }
        },
        State {
            name: "visible"
            PropertyChanges { target: root; visible: true }
        }
    ]
}
