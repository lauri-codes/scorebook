import QtQuick 2.0
import "../misc/Style.js" as Style

Item {
    id: plot
    width: parent.width
    height: 1.8*app.touchSize
    property string m_title: modelData.name
    property string m_ytitle: "Count"
    property string m_xtitle: "Value"
    property real m_ymax: playerHandler.yMax
    property real m_ymin: 0
    property real m_xmin: playerHandler.xMin
    property real m_xmax: playerHandler.xMax
    property real m_xmid: (m_xmax+m_xmin)/2
    property real m_ymid: (m_ymax+m_ymin)/2

    /***************************************************************************
      * Graph
      */
    Item {
        id: graph
        anchors {
            top: title.bottom
            right: parent.right
            left: yAxis.right
            bottom: xAxis.top
            rightMargin: 0.4*app.touchSize
        }
        height: parent.height-title.height

        ListView {
            id: listView
            anchors.fill: parent
            model: modelData.histogram
            delegate: bar
            highlightMoveVelocity: 1000
            orientation: ListView.Horizontal
            interactive: false
        }
        Component {
            id: bar
            Item {
                anchors.bottom: parent.bottom
                width: graph.width/listView.model.length
                height: modelData.value/plot.m_ymax*parent.height
                Rectangle {
                    anchors {
                        fill: parent
                        rightMargin: 0
                        leftMargin: -1
                        bottomMargin: -1
                    }
                    border.width: 1
                    border.color: "white"
                    color: Style.color_blue_light
                    anchors.bottom: parent.bottom
                    width: parent.width/listView.model.length
                    height: modelData.value/plot.m_ymax*parent.height
                }
            }
        }
    }
    /***************************************************************************
     * Title
     */
    DefaultText {
        id: title
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: m_title
        color: "white"
        height: 0.4*app.touchSize
        font.pixelSize: 0.8*app.textSmall
    }
    /***************************************************************************
     * yAxis
     */
    Item {
        id: yAxis
        anchors {
            left: parent.left
            top: graph.top
            bottom: graph.bottom
        }
        width: 0.5*app.touchSize
        Rectangle {
            id: vert
            width: 2
            anchors {
                right: parent.right
                bottom: parent.bottom
                top: parent.top
            }
            color: "white"
        }
        DefaultText {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -0.07*app.touchSize
            text: m_ytitle
            rotation: -90
            color: "white"
            font.pixelSize: 0.6*app.textSmall
        }
        DefaultText {
            anchors.right: parent.right
            anchors.rightMargin: 0.08*app.touchSize
            anchors.verticalCenter: parent.bottom
            text: m_ymin.toString()
            color: "white"
            font.pixelSize: 0.5*app.textSmall
        }
//        DefaultText {
//            anchors.right: parent.right
//            anchors.rightMargin: 0.08*app.touchSize
//            anchors.verticalCenter: parent.verticalCenter
//            text: m_ymid.toString()
//            color: "white"
//            font.pixelSize: 0.5*app.textSmall
//        }
        DefaultText {
            anchors.right: parent.right
            anchors.rightMargin: 0.05*app.touchSize
            anchors.verticalCenter: parent.top
            text: m_ymax.toString()
            color: "white"
            font.pixelSize: 0.5*app.textSmall
        }
    }
    /***************************************************************************
     * xAxis
     */
    Item {
        id: xAxis
        anchors {
            left: graph.left
            right: graph.right
            bottom: parent.bottom
        }
        height: 0.5*app.touchSize

        Rectangle {
            height: 2
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
                leftMargin: -vert.width
            }
            color: "white"
        }
        DefaultText {
            anchors.centerIn: parent
            //anchors.verticalCenterOffset: 0.06*app.touchSize
            text: m_xtitle
            color: "white"
            font.pixelSize: 0.6*app.textSmall
        }
        DefaultText {
            anchors.horizontalCenter: parent.left
            anchors.top: parent.top
            anchors.topMargin: 0.06*app.touchSize
            text: m_xmin.toString()
            color: "white"
            font.pixelSize: 0.5*app.textSmall
        }
//        DefaultText {
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: parent.top
//            anchors.topMargin: 0.05*app.touchSize
//            text: m_xmid.toString()
//            color: "white"
//            font.pixelSize: 0.5*app.textSmall
//        }
        DefaultText {
            anchors.horizontalCenter: parent.right
            anchors.top: parent.top
            anchors.topMargin: 0.06*app.touchSize
            text: m_xmax.toString()
            color: "white"
            font.pixelSize: 0.5*app.textSmall
        }
    }
}
