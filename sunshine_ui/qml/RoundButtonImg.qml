import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15

Item {
   id: root
   property string troggle: "off"
   property string imageSource: "value"
   property int x_value: 0
   property int y_value: 0


    anchors.centerIn: parent

    Rectangle {
          property bool onHovered: false
        id: roundButtonImage
        y:root.y_value
        x:root.x_value
        width: 50
        height: 50
        color: (root.troggle=="off") ? "#00000000" : "white"
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
            color: (root.troggle=="on") ? "#9a4268" : "white"
        }


        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {

                if (root.troggle == "on") root.troggle= "off"
                else root.troggle= "on"

                if(imageSource == "../images/icon/music.png"){
                    wandLight.troggle = "off"
                    iconMusic.troggle = "on"

                     smallButtonMusic1.troggle = "on"
                     painLight.troggle = "on"
                    lightButton1.troggle = "off"
                    lightButton2.troggle = "off"
                    lightButton3.troggle = "off"
                    lightButton4.troggle = "off"

                }
                if(imageSource == "../images/icon/magic-wand.png"){
                    iconMusic.troggle = "off"
                    wandLight.troggle = "on"
                     lightButton1.troggle = "on"
                      painLight.troggle = "off"

                    smallButtonMusic1.troggle = "off"
                    smallButtonMusic2.troggle = "off"
                    smallButtonMusic3.troggle = "off"
                    smallButtonMusic4.troggle = "off"
                    smallButtonMusic5.troggle = "off"
                    smallButtonMusic6.troggle = "off"
                    smallButtonMusic7.troggle = "off"
                    smallButtonMusic8.troggle = "off"

//                    console.log(wandLight.troggle)
//                    console.log(iconOff.troggle)
//                    console.log(iconMusic.troggle)
//                    console.log(sleepLight.troggle)
//                    console.log(painLight.troggle)
                }
                if(imageSource == "../images/icon/paint.png"){
                    lightButton1.troggle = "off"
                    lightButton2.troggle = "off"
                    lightButton3.troggle = "off"
                    lightButton4.troggle = "off"
                }
            }





            onEntered: {
                 roundButtonImage.onHovered = true
                colorOverlayRoundImage.color = (root.troggle=="off") ? "#9a4268" : "white"
                roundButtonImage.color = (root.troggle=="on") ? "#00000000" : "white"


            }
            onExited: {
                 roundButtonImage.onHovered = false
                colorOverlayRoundImage.color = (root.troggle=="on") ? "#9a4268" : "white"
                roundButtonImage.color = (root.troggle=="off") ? "#00000000" : "white"


            }
        }
        Timer {
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                        if (!roundButtonImage.onHovered){
                            colorOverlayRoundImage.color = (root.troggle=="on") ? "#9a4268" : "white"
                            roundButtonImage.color = (root.troggle=="off") ? "#00000000" : "white"
                    }
                }
        }






    }

}
