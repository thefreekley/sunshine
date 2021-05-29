import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T

Item {
    id: root
    property bool troggle: false
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
        color: (root.troggle==false) ? "#c60100" : "white"

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
            color: (root.troggle==true) ? "#9a4268" : "white"
        }


        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                root.clicked()
                root.troggle = (root.troggle == true) ? false : true
            }



            onEntered: {
                save.opacity = 0.6
                colorOverlayRoundImage.color = (troggle==false) ? "#c60100" : "white"
                roundButtonImage.color = (troggle==true) ? "#c60100" : "white"


            }
            onExited: {
                colorOverlayRoundImage.color = (troggle==true) ? "#c60100" : "white"
                roundButtonImage.color = (troggle==false) ? "#c60100" : "white"


            }
        }






    }

}
