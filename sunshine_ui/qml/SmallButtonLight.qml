import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T

Item{
     property string imageSource: "value"
    property bool troggle: false
    id: root

    width: 80
    height: 20
    Rectangle {

        id: smallButtonLight
        property bool onHovered: false
        width: 85
        height: 20
        radius: 10
        color: "#00000000"

        Rectangle{
            id:smallRound
            width:5
            height: 5
            radius: 2.5
            color: (root.troggle==true) ? "#ff6860" : "#00000000"
             anchors.verticalCenter: parent.verticalCenter
             anchors.leftMargin: -20
        }

        Image {
            id: imageRoundButton
            width: 65
            height: 22
            source: imageSource
            anchors.centerIn: parent
        }
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                smallButtonUp.start()
                smallButtonLight.onHovered = true
                smallRound.color = "white"
            }
            onExited: {
                smallButtonDown.start()
                smallButtonLight.onHovered = false
                smallRound.color = (troggle==true) ? "#ffd400" : "#00000000"
            }
            onClicked: {
                lightButton1.troggle = false
                lightButton2.troggle = false
                lightButton3.troggle = false
                lightButton4.troggle = false
                if (wandLight.troggle == true)  root.troggle = true
            }

        }

        Timer {
                interval: 50
                repeat: true
                running: true
                onTriggered: {

                        if (!smallButtonLight.onHovered){
                        smallRound.color = (troggle==true) ? "#ffd400" : "#00000000"
                    }
                }
        }

        NumberAnimation
        {
            id: smallButtonUp
            target: imageRoundButton
            property: "width"
            to: 70;
            duration: 50
        }
        NumberAnimation
        {
            id: smallButtonDown
            target: imageRoundButton
            property: "width"
            to: 65;
            duration:  50
        }

    }
}
