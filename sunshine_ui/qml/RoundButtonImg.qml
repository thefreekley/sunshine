import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15

Item {
   id: root
   property string color: "off"
   property string imageSource: "value"
   property int x_value: 0
   property int y_value: 0

   signal clicked()
    anchors.centerIn: parent

    Rectangle {
        id: roundButtonImage
        y:root.y_value
        x:root.x_value
        width: 50
        height: 50
        color: (root.color=="off") ? "#00000000" : "white"
        border.color: "#ffffff"
        border.width: 3
        radius: 25
        Image {
            id: imageRoundButton
            width: 20
            height: 20
            source: imageSource
            anchors.centerIn: parent
        }

        ColorOverlay {
            id: colorOverlayRoundImage
            anchors.fill: imageRoundButton
            source: imageRoundButton
            color: (root.color=="on") ? "#9a4268" : "white"
        }


        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                root.clicked()
            }



            onEntered: {

                colorOverlayRoundImage.color = (color=="off") ? "#9a4268" : "white"
                roundButtonImage.color = (color=="on") ? "#00000000" : "white"


            }
            onExited: {
                colorOverlayRoundImage.color = (color=="on") ? "#9a4268" : "white"
                roundButtonImage.color = (color=="off") ? "#00000000" : "white"


            }
        }






    }

}
