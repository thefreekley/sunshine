import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15

Item {
   id: root
   property bool troggle: false
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
        color: (root.troggle==false) ? "#00000000" : "white"
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
            color: (root.troggle==true) ? "#9a4268" : "white"
        }

        function updateRoundImg(){

            save.opacity = 0.6
            if (root.troggle == true) root.troggle= false
            else root.troggle= true


            if(imageSource == "../images/icon/music.png"){
                labelNameMone.text = qsTr("Mode:music visualisation")
                wandLight.troggle = false
                iconMusic.troggle = true
                screenLight.troggle = false

                 smallButtonMusic1.troggle = (backend.musicModeNumber() == 1) ? true : false
                smallButtonMusic2.troggle = (backend.musicModeNumber() == 2) ? true : false
                smallButtonMusic3.troggle = (backend.musicModeNumber() == 3) ? true : false
                smallButtonMusic4.troggle = (backend.musicModeNumber() == 4) ? true : false
                smallButtonMusic5.troggle = (backend.musicModeNumber() == 5) ? true : false
                smallButtonMusic6.troggle = (backend.musicModeNumber() == 6) ? true : false
                smallButtonMusic7.troggle = (backend.musicModeNumber() == 7) ? true : false
                smallButtonMusic8.troggle = (backend.musicModeNumber() == 8) ? true : false



                 painLight.troggle = true
                lightButton1.troggle = false
                lightButton2.troggle = false
                lightButton3.troggle = false
                lightButton4.troggle = false

            }
            if(imageSource == "../images/icon/magic-wand.png"){
                labelNameMone.text = qsTr("Mode:light")
                iconMusic.troggle = false
                wandLight.troggle = true
                screenLight.troggle = false

                lightButton1.troggle =  (backend.lightModeNumber() == 1) ? true : false
                lightButton2.troggle =  (backend.lightModeNumber() == 2) ? true : false
                lightButton3.troggle =  (backend.lightModeNumber() == 3) ? true : false
                lightButton4.troggle =  (backend.lightModeNumber() == 4) ? true : false

                  painLight.troggle = false

                smallButtonMusic1.troggle = false
                smallButtonMusic2.troggle = false
                smallButtonMusic3.troggle = false
                smallButtonMusic4.troggle = false
                smallButtonMusic5.troggle = false
                smallButtonMusic6.troggle = false
                smallButtonMusic7.troggle = false
                smallButtonMusic8.troggle = false

//                    console.log(wandLight.troggle)
//                    console.log(iconOff.troggle)
//                    console.log(iconMusic.troggle)
//                    console.log(sleepLight.troggle)
//                    console.log(painLight.troggle)
            }
            if(imageSource == "../images/icon/paint.png"){
                 if (root.troggle && wandLight.troggle) labelNameMone.text = qsTr("Mode:paint")
                 if (!root.troggle && wandLight.troggle) labelNameMone.text = qsTr("Mode:light")

                 if(!wandLight){
                 if (smallButtonMusic1.troggle == true ||
                     smallButtonMusic2.troggle == true ||
                     smallButtonMusic3.troggle == true ||
                     smallButtonMusic4.troggle == true) root.troggle = true
                 else root.troggle = false
                }



                lightButton1.troggle = false
                lightButton2.troggle = false
                lightButton3.troggle = false
                lightButton4.troggle = false
            }
            if(imageSource == "../images/icon/screen.png"){


                labelNameMone.text = qsTr("Mode:screen")
                screenLight.troggle = true
                iconMusic.troggle = false
                wandLight.troggle = false
                painLight.troggle = false


                smallButtonMusic1.troggle = false
                smallButtonMusic2.troggle = false
                smallButtonMusic3.troggle = false
                smallButtonMusic4.troggle = false
                smallButtonMusic5.troggle = false
                smallButtonMusic6.troggle = false
                smallButtonMusic7.troggle = false
                smallButtonMusic8.troggle = false

                lightButton1.troggle = false
                lightButton2.troggle = false
                lightButton3.troggle = false
                lightButton4.troggle = false

            }

            aplicationWindow.callModeBackend()
        }
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onClicked: roundButtonImage.updateRoundImg(false)





            onEntered: {
                 roundButtonImage.onHovered = true
                colorOverlayRoundImage.color = (root.troggle==false) ? "#9a4268" : "white"
                roundButtonImage.color = (root.troggle==true) ? "#00000000" : "white"


            }
            onExited: {
                 roundButtonImage.onHovered = false
                colorOverlayRoundImage.color = (root.troggle==true) ? "#9a4268" : "white"
                roundButtonImage.color = (root.troggle==false) ? "#00000000" : "white"


            }
        }
        Timer {
                interval: 50
                repeat: true
                running: true
                onTriggered: {
                        if (!roundButtonImage.onHovered){
                            colorOverlayRoundImage.color = (root.troggle==true) ? "#9a4268" : "white"
                            roundButtonImage.color = (root.troggle==false) ? "#00000000" : "white"
                    }
                }
        }






    }

}
