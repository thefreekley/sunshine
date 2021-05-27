import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T
import QtQuick.Dialogs 1.0

Window {
    id: aplicationWindow
    width: 1160
    height: 650
    visible: true
    color: "#00000000"
    title: qsTr("Hello World")
    flags: Qt.FramelessWindowHint
    property int previousX
    property int previousY

    FontLoader {
        id: bebasRegularFont
        source: "../font/BebasNeue Regular.ttf"
    }


    Rectangle {
        id: rectangle
        color: "#7a3452"
        anchors.fill: parent
        anchors.topMargin: 19
        anchors.rightMargin: 5
        anchors.leftMargin: 5


        RadialGradient {
            id: radialGradient
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#7a385e" }
                GradientStop { position: 0.5; color: "#622b4b" }
            }

            Rectangle {
                id: rectangle3
                height: 257
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 29

                Rectangle {
                    id: rectangle2
                    x: 390
                    y: 185
                    width: 200
                    height: 200
                    radius: 100
                    color: "#ffffff"
                    anchors.top: parent.top
                    anchors.topMargin: 67
                    anchors.centerIn: parent

                    Label {
                        id: label
                        text: qsTr("ID: 7732")
                        font.family: bebasRegularFont.name
                        anchors.centerIn: parent
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 30
                        color:  "#9a4268"

                    }

                    Label {
                        id: label1
                        x: 53
                        y: 126
                        width: 94
                        height: 30
                        font.family: bebasRegularFont.name
                        text: qsTr("Mode:light")
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 10
                        color:  "#9a4268"
                    }
                }

                RoundButtonImg  {
                    id: iconOff
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/icon/off.png"
                    x_value: 0
                    y_value: 140

                }

                RoundButtonImg  {
                    id: iconMusic
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/icon/music.png"
                    x_value: -100
                    y_value: 110

                }


                RoundButtonImg  {
                    id: iconLight
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/icon/sleep.png"
                    x_value: 100
                    y_value: 110

                }
                RoundButtonImg  {
                    id: painLight
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/icon/paint.png"
                    x_value: 150
                    y_value: 20

                }

                RoundButtonImg  {
                    id: wandLight
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/icon/magic-wand.png"
                    x_value: -150
                    y_value: 20

                }

                Column {
                    id: column
                    x: 8
                    y: 17
                    width: 214
                    height: 579

                    RectangleLabel {
                        textLabel: "ON"
                    }

                    RectangleLabel {
                        textLabel: "77 88"
                    }

                    RectangleLabel {
                        textLabel: "HC-06"
                    }

                    RectangleLabel {
                        textLabel: "Stereo mixer"
                    }

                    Rectangle{

                        id: rectangle10
                        height: 350
                        width: parent.width
                        color: "#00000000"
                        Rectangle {
                            property int timeGradient: 5000
                            anchors.centerIn: parent
                            id: colorGradient
                            width: 30
                            height: 300
                            color: "#ffffff"
                            radius: 15
                            gradient: Gradient {

                                GradientStop { position: 0.0; color: colorDialog1.color
                                    SequentialAnimation on color
                                    {
                                        id: gradientPaintTop;
                                        loops: Animation.Infinite


                                        ColorAnimation
                                        {
                                            from: colorDialog2.color
                                            to: colorDialog1.color
                                            duration: colorGradient.timeGradient
                                        }

                                        ColorAnimation
                                        {
                                            from: colorDialog1.color
                                            to: colorDialog2.color
                                            duration: colorGradient.timeGradient
                                        }

                                        ColorAnimation
                                        {
                                            from: colorDialog2.color
                                            to: colorDialog2.color
                                            duration: colorGradient.timeGradient
                                        }



                                    }
                                }

                                GradientStop { position: 0.5; color: colorDialog1.color
                                    SequentialAnimation on color
                                    {
                                        id: gradientPaintMiddle;
                                        loops: Animation.Infinite


                                        ColorAnimation
                                        {
                                            from: colorDialog2.color
                                            to: colorDialog2.color
                                            duration: colorGradient.timeGradient
                                        }
                                        ColorAnimation
                                        {
                                            from: colorDialog2.color
                                            to: colorDialog1.color
                                            duration: colorGradient.timeGradient
                                        }
                                        ColorAnimation
                                        {
                                            from: colorDialog1.color
                                            to: colorDialog2.color
                                            duration: colorGradient.timeGradient
                                        }



                                    }
                                }
                                GradientStop { position: 1.0; color: colorDialog2.color
                                    SequentialAnimation on color
                                    {
                                        id: gradientPaintBottom;
                                        loops: Animation.Infinite

                                        ColorAnimation
                                        {
                                            from: colorDialog1.color
                                            to: colorDialog2.color
                                            duration: colorGradient.timeGradient
                                        }
                                        ColorAnimation
                                        {
                                            from: colorDialog2.color
                                            to: colorDialog2.color
                                            duration: colorGradient.timeGradient
                                        }
                                        ColorAnimation
                                        {
                                            from: colorDialog2.color
                                            to: colorDialog1.color
                                            duration: colorGradient.timeGradient
                                        }






                                    }}

                            }


                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle {
                            id: colorButton1
                            x: 56
                            width: 24
                            height: 24
                            radius: 12
                            color: colorDialog1.color
                            anchors.right: colorGradient.left
                            anchors.top: colorGradient.bottom
                            anchors.topMargin: -293
                            anchors.rightMargin: 6
                            MouseArea {
                                anchors.fill: parent
                                onClicked: colorDialog1.open()
                                hoverEnabled: true

                                onEntered: { colorDialogWidth1Up.start(); colorDialogHeight1Up.start();}
                                onExited: { colorDialogWidth1Down.start(); colorDialogHeight1Down.start();}

                            }

                            NumberAnimation {id: colorDialogWidth1Up; property: "width"; target: colorButton1;duration: 50;to: 26}
                            NumberAnimation {id: colorDialogWidth1Down; property: "width"; target: colorButton1;duration: 50;to: 24}
                            NumberAnimation {id: colorDialogHeight1Up; property: "height"; target: colorButton1;duration: 50;to: 26}
                            NumberAnimation {id: colorDialogHeight1Down; property: "height"; target: colorButton1;duration: 50;to: 24}





                        }

                        Rectangle {
                            id: colorButton2
                            x: 56
                            width: 24
                            height: 24
                            radius: 12
                            color: colorDialog2.color
                            anchors.right: colorGradient.left
                            anchors.top: colorGradient.bottom
                            anchors.topMargin: -35
                            anchors.rightMargin: 6

                            MouseArea {
                                anchors.fill: parent
                                onClicked: colorDialog2.open()
                                hoverEnabled: true
                                onEntered: { colorDialogWidth2Up.start(); colorDialogHeight2Up.start();}
                                onExited: { colorDialogWidth2Down.start(); colorDialogHeight2Down.start();}
                            }


                            NumberAnimation {id: colorDialogWidth2Up; property: "width"; target: colorButton2;duration: 50;to: 26}
                            NumberAnimation {id: colorDialogWidth2Down; property: "width"; target: colorButton2;duration: 50;to: 24}
                            NumberAnimation {id: colorDialogHeight2Up; property: "height"; target: colorButton2;duration: 50;to: 26}
                            NumberAnimation {id: colorDialogHeight2Down; property: "height"; target: colorButton2;duration: 50;to: 24}

                        }



                        Image {
                            id: painImage
                            width: 37
                            height: 33
                            anchors.left: colorGradient.right
                            anchors.top: colorGradient.bottom
                            source: "../images/icon/paint.png"
                            anchors.topMargin: -293
                            anchors.leftMargin: 6
                            fillMode: Image.PreserveAspectFit
                        }

                        ColorDialog {
                            id: colorDialog1
                            title: qsTr("choose the color")
                            onAccepted: {
                                gradientPaintTop.restart()
                                gradientPaintBottom.restart()
                                gradientPaintMiddle.restart()
                            }

                            color: "#ff0100"
                        }

                        ColorDialog {
                            id: colorDialog2
                            title: qsTr("choose the color")
                            onAccepted: {
                                gradientPaintTop.restart()
                               gradientPaintBottom.restart()
                                gradientPaintMiddle.restart()
                            }
                            color: "#c60100"
                        }




                    }
                }

                Rectangle {
                    id: rectangle6
                    x: 782
                    width: 360
                    color: "#00000000"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 49
                    anchors.bottomMargin: 8
                    anchors.rightMargin: 8

                    ProgressBar {
                        id: control
                        value: 0.5
                        width: parent.width - 20
                        height: 12

                        background: Rectangle {
                            implicitWidth: parent.width - 20
                            implicitHeight: 12
                            color: "white"
                            radius: 6
                        }

                        contentItem: Item {
                            implicitWidth: parent.width - 20
                            implicitHeight: 12

                            Rectangle {
                                width: control.visualPosition * parent.width
                                height: parent.height
                                radius: 6
                                color: "#ff6860"
                            }
                        }
                    }

                    FontLoader {
                        id: bebasFont1
                        source: "../font/BebasNeue Regular.ttf"
                    }

                    Label {
                        id: timeToSleep
                        x: 0
                        y: 18
                        font.family: bebasFont1.name
                        font.pointSize: 13
                        width: 79
                        height: 69
                        color: "white"
                        text: qsTr("time to sleep:")
                    }
                    Label {
                        id: timeToSleep1
                        x: 81
                        y: 18
                        width: 79
                        height: 69

                        color: "#ff6860"
                        text: qsTr("5 min")
                        font.pointSize: 13
                        font.family: bebasFont1.name
                    }

                    Rectangle {
                        id: rectangle7
                        x: 0
                        y: 46
                        width: 113
                        height: 30
                        radius: 15
                        color: "#00d4e0"

                        Label {
                            id: sleepAll
                            font.family: bebasFont1.name
                            font.pointSize: 13
                            color: "white"
                            text: qsTr("SLEEP")
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        id: rectangle8
                        x: 126
                        y: 46
                        width: 221
                        height: 30
                        radius: 15
                        color: "#ffd400"

                        Row {
                            anchors.centerIn: parent
                            id: row1

                            width: 120
                            height: 30

                            TextField {
                                horizontalAlignment: "AlignRight"
                                width:60
                                font.family: bebasFont1.name
                                font.pointSize: 13
                                placeholderText: qsTr("from")
                                color: "black"
                                background: Rectangle { color: "#ffd400" }
                            }

                            TextField {

                                width:60
                                font.family: bebasFont1.name
                                font.pointSize: 13
                                placeholderText: qsTr("to")
                                color: "black"
                                background: Rectangle { color: "#ffd400" }
                            }
                        }

                        Label {
                            anchors.centerIn: parent
                            id: label2
                            font.pointSize: 13
                            width: 10
                            text: qsTr("-")
                            anchors.verticalCenterOffset: 0
                            anchors.horizontalCenterOffset: 4
                        }

                    }


                    RoundButtonTree {

                        id: treeButton
                        width: 50
                        height: 50
                        color: "off"
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: 0
                        anchors.topMargin: 113
                        anchors.verticalCenterOffset: 38
                        anchors.horizontalCenterOffset: -155
                        imageSource: "../images/icon/tree.png"
                    }

                    Label {
                        id: label3
                        height: 43
                        font.family: bebasFont1.name
                        font.pointSize: 17
                        color: "white"
                        text: qsTr("CONNECT ALL DEVICES")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.topMargin: 120
                        anchors.rightMargin: 103
                        anchors.leftMargin: 56
                    }

                    Label {
                        id: countOfLed
                        height: 43
                        color: "#ffffff"
                        text: qsTr("COUNT OF LED:")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 14
                        anchors.rightMargin: 151
                        anchors.topMargin: 169
                        font.family: bebasFont1.name
                        anchors.leftMargin: 8
                    }

                    Rectangle {
                        id: countOfLedRectengle
                        y: 176
                        width: 100
                        height: 30
                        radius: 15
                        anchors.left: countOfLed.right
                        anchors.leftMargin: -117
                        color: "#9b4068"

                        TextField {
                            horizontalAlignment: "AlignHCenter"
                            anchors.centerIn: parent
                            width:60
                            font.family: bebasFont1.name
                            font.pointSize: 13
                            placeholderText: qsTr("...")
                            color: "white"
                            background: Rectangle { color: "#9b4068" }
                        }


                    }





                }
            }

            Rectangle {
                id: rectangle4
                y: 334
                height: 285
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0

                Rectangle {
                    id: rectangle5
                    y: 8
                    height: 268
                    width:400
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.centerIn: parent

                    T.Slider {
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: controlLight
                        x: 90
                        anchors.top: parent.top
                        anchors.topMargin: -19
                        anchors.horizontalCenterOffset: 0
                        implicitWidth: 300
                        implicitHeight: 26

                        handle: Rectangle {
                            x: controlLight.visualPosition * (controlLight.width - width)
                            y: (controlLight.height - height) / 2
                            width: 14
                            height: 14

                            radius: 7
                            color: controlLight.pressed ? "#f0f0f0" : "#f6f6f6"
                            border.color: UIStyle.colorQtGray7
                        }

                        background: Rectangle {
                            y: (controlLight.height - height) / 2
                            height: 14
                            radius: 7
                            color: UIStyle.colorQtGray3

                            Rectangle {
                                width: controlLight.visualPosition * parent.width
                                height: parent.height
                                color: "#ff6860"
                                radius: 7
                            }
                        }
                    }

                    T.Slider {
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: controlMusic
                        anchors.top: controlLight.bottom
                        anchors.horizontalCenterOffset: 2
                        anchors.topMargin: 18

                        implicitWidth: 300
                        implicitHeight: 26

                        handle: Rectangle {
                            x: controlMusic.visualPosition * (controlMusic.width - width)
                            y: (controlMusic.height - height) / 2
                            width: 14
                            height: 14

                            radius: 7
                            color: controlMusic.pressed ? "#f0f0f0" : "#f6f6f6"
                            border.color: UIStyle.colorQtGray7
                        }

                        background: Rectangle {
                            y: (controlMusic.height - height) / 2
                            height: 14
                            radius: 7
                            color: UIStyle.colorQtGray3

                            Rectangle {
                                width: controlMusic.visualPosition * parent.width
                                height: parent.height
                                color: "#ff6860"
                                radius: 7
                            }
                        }
                    }

                    RectangleLabel{
                        x: 50
                        anchors.top: parent.top
                        anchors.topMargin: 62
                        textLabel: "RAINBOW"
                        widthNew: 300
                    }

                    Row {
                        id: row
                        x: 37
                        width: 326
                        height: 32
                        anchors.top: parent.top
                        anchors.topMargin: 128
                        SmallButtonLight {
                            imageSource: "../images/light/1.png"
                        }
                        SmallButtonLight {
                            imageSource: "../images/light/2.png"
                        }
                        SmallButtonLight {
                            imageSource: "../images/light/3.png"
                        }
                        SmallButtonLight {
                            imageSource: "../images/light/4.png"
                        }
                    }

                    Row {
                        id: row2
                        x: 57
                        width: 142
                        anchors.top: parent.top
                        anchors.topMargin: 170

                        SmallButtonMusic {
                            imageSource: "../images/music/1.png"
                            troggle: "on"
                        }
                        SmallButtonMusic {
                            imageSource: "../images/music/2.png"
                        }
                        SmallButtonMusic {
                            imageSource: "../images/music/3.png"
                        }
                        SmallButtonMusic {
                            imageSource: "../images/music/4.png"
                        }
                    }

                    Row {
                        id: row3
                        x: 221
                        width: 142
                        height: 81
                        anchors.top: parent.top
                        anchors.topMargin: 170
                        SmallButtonMusic {
                            imageSource: "../images/music/5.png"
                        }

                        SmallButtonMusic {
                            imageSource: "../images/music/6.png"
                        }

                        SmallButtonMusic {
                            imageSource: "../images/music/7.png"
                        }

                        SmallButtonMusic {
                            imageSource: "../images/music/8.png"
                        }
                    }

                    Image {
                        id: image
                        anchors.left: row2.right
                        anchors.right: row3.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "../images/icon/music.png"
                        anchors.bottomMargin: 35
                        anchors.topMargin: 193
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0
                        fillMode: Image.PreserveAspectFit
                    }

                    Image {
                        id: imageLight
                        x: 8
                        width: 38
                        height: 24
                        anchors.right: controlLight.left
                        anchors.top: controlLight.bottom
                        source: "../images/icon/light.png"
                        anchors.topMargin: -24
                        anchors.rightMargin: 4
                        fillMode: Image.PreserveAspectFit
                    }

                    Image {
                        id: imageVoid
                        x: 8
                        width: 38
                        height: 24
                        anchors.right: controlMusic.left
                        anchors.top: controlMusic.bottom
                        source: "../images/icon/loud.png"
                        anchors.rightMargin: 4
                        fillMode: Image.PreserveAspectFit
                        anchors.topMargin: -25
                    }
                }
            }









        }

    }


    Rectangle {

        id: headerBar
        height: 25

        color:  "#9a4268"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 2
        radius: 3




        Label {
            FontLoader {
                id: superionFont
                source: "../font/Superion 400.otf"
            }

            id: labelTitle
            x: 420
            y: 21
            color: "#ffffff"
            text: qsTr("Sunshine")
            font.pointSize: 13
            anchors.centerIn: parent
            font.family: superionFont.name



            MouseArea {
                x: 0
                hoverEnabled: true
                anchors.fill: parent
                anchors.bottomMargin: -10
                onEntered: {
                    labelTitle.state = "PRESSED"
                    labelUp.start()


                }
                onExited: {
                    labelDown.start()
                    labelTitle.state = "RELEASED"
                }

            }




            NumberAnimation
            {
                id: labelUp
                target: labelTitle
                property: "font.pointSize"
                to: 15;
                duration: 50
            }
            NumberAnimation
            {
                id: labelDown
                target: labelTitle
                property: "font.pointSize"
                to: 13;
                duration:  50
            }


            states: [
                State {
                    name: "PRESSED"
                    PropertyChanges { target: labelTitle; color: "#ffea00"}

                },
                State {
                    name: "RELEASED"
                    PropertyChanges { target: labelTitle; color: "white"}

                }
            ]

            transitions: [
                Transition {
                    from: "PRESSED"
                    to: "RELEASED"
                    ColorAnimation { target: labelTitle; duration: 100}


                },
                Transition {
                    from: "RELEASED"
                    to: "PRESSED"
                    ColorAnimation { target: labelTitle; duration: 100}
                }


            ]





        }

        Row {
            id: row4

            width: 75
            height: 25
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: minimize
                width: 25
                height: 25
                source: "../images/icon/minimaze.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: minimize.opacity=0.7
                    onExited: minimize.opacity=1
                    onClicked: aplicationWindow.visibility = "Minimized"
                }
            }

            Image {
                id: maximize
                width: 25
                height: 25
                source: "../images/icon/maximize.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: maximize.opacity=0.7
                    onExited: maximize.opacity=1
                    onClicked: aplicationWindow.visibility = "Maximized"
                }
            }

            Image {
                id: close
                width: 25
                height: 25
                source: "../images/icon/close.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: close.opacity=0.7
                    onExited: close.opacity=1
                    onClicked: Qt.quit()
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            anchors.rightMargin: 96

                   onPressed: {
                       previousX = mouseX
                       previousY = mouseY
                   }

                   onMouseXChanged: {
                       var dx = mouseX - previousX
                       aplicationWindow.setX(aplicationWindow.x + dx)
                   }

                   onMouseYChanged: {
                       var dy = mouseY - previousY
                       aplicationWindow.setY(aplicationWindow.y + dy)
                   }

               }

           }

           MouseArea {
               width: 5

               anchors {
                   right: parent.right
                   top: parent.top
                   bottom: parent.bottom
               }

               cursorShape: Qt.SizeHorCursor

               onPressed: previousX = mouseX

               onMouseXChanged: {
                   var dx = mouseX - previousX
                   aplicationWindow.setWidth(parent.width + dx)
               }

           }

           MouseArea {
               height: 5
               anchors {
                   top: parent.top
                   left: parent.left
                   right: parent.right
               }

               cursorShape: Qt.SizeVerCursor

               onPressed: previousY = mouseY

               onMouseYChanged: {
                   var dy = mouseY - previousY
                   aplicationWindow.setY(aplicationWindow.y + dy)
                   aplicationWindow.setHeight(aplicationWindow.height - dy)

               }
    }
}









