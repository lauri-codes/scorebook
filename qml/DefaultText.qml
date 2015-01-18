import QtQuick 2.4

Text {
    font.family: fontLoader.name
    font.weight: Font.Light
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: app.textMedium*0.9
    wrapMode: Text.WordWrap

    FontLoader {
        id: fontLoader
        source: "../misc/Roboto-Light.ttf"
    }
}
