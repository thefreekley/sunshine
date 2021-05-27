import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T

Item{
    property string imageSource: "value"
    property string troggle: "off"
    id:root

    width: 36
    height: 80
    Rectangle {
       id: rectangleSmallButonMusic
        anchors.centerIn: parent
        width: 20
        height: 63
        radius: 10
        color: "#9b4068"


        Rectangle{
            id:smallRound
            x: 8
            y: 20

            width:5
            height: 5
            radius: 2.5
            color: (troggle=="on") ? "#ffd400" : "#00000000"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 43

        }


        Image {
            id: imageRoundButton
            width: 22
            height: 65
            source: imageSource
            anchors.centerIn: parent
        }




        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                smallButtoMusicnUp.start()
                smallRound.color = "white"

            }
            onExited: {
                smallButtonMusicDown.start()
                smallRound.color = (troggle=="on") ? "#ffd400" : "#00000000"

            }

        }
        NumberAnimation
        {
            id: smallButtoMusicnUp
            target: imageRoundButton
            property: "height"
            to: 70;
            duration: 50
        }
        NumberAnimation
        {
            id: smallButtonMusicDown
            target: imageRoundButton
            property: "height"
            to: 65;
            duration:  50
        }

    }
}
