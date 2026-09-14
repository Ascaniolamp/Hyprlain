import QtQuick

Rectangle {
    color:"black"
    width:130
    height: 32
    border.width: 1
    border.color: "#D27486"
    property string label: "S h u t d o w n"
    Text {
        color: "#D27486"
	font.pixelSize : 14
        text: parent.label
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
