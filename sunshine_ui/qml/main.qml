import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.15

Window {
    width: 1000
    height: 600
    visible: true
    color: "#00000000"
    title: qsTr("Hello World")
    FontLoader {
        id: bebasRegularFont
        source: "../font/BebasNeue Regular.ttf"
    }


    Rectangle {
        id: rectangle
        color: "#7a3452"
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5

        RadialGradient {
            id: radialGradient
            anchors.fill: parent
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.topMargin: 31
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
                    imageSource: "../images/off.png"
                     x_value: 0
                     y_value: 140

                }

                RoundButtonImg  {
                    id: iconMusic
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/music.png"
                     x_value: -100
                     y_value: 110

                }


                RoundButtonImg  {
                    id: iconLight
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/music.png"
                     x_value: 100
                     y_value: 110

                }
                RoundButtonImg  {
                    id: painLight
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/paint.png"
                     x_value: 150
                     y_value: 20

                }

                RoundButtonImg  {
                    id: wandLight
                    width: 50
                    height: 50
                    color: "on"
                    imageSource: "../images/magic-wand.png"
                    x_value: -150
                    y_value: 20

                }
            }

            Rectangle {
                id: rectangle4
                y: 349
                height: 220
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0

                Slider {
                    anchors.centerIn: parent
                    style: SliderStyle {
                        groove: Rectangle {
                            implicitWidth: 200
                            implicitHeight: 8
                            color: "gray"
                            radius: 8
                        }
                        handle: Rectangle {
                            anchors.centerIn: parent
                            color: control.pressed ? "white" : "lightgray"
                            border.color: "gray"
                            border.width: 2
                            implicitWidth: 34
                            implicitHeight: 34
                            radius: 12
                        }
                    }
                }
            }











                    }

            }


        Rectangle {
            id: rectangle1
            height: 42

            color:  "#9a4268"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.topMargin: 10
            radius: 20

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

                ColorOverlay {
                       id: imageRoundButtonColor
                       anchors.fill: imageRoundButton
                       source: imageRoundButton
                       color: "#ffffff"  // make image like it lays under red glass
                   }

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: {
                        labelTitle.state = "PRESSED"
                        labelUp.start()
                        imageRoundButtonColor.color = "red"

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

        }
    }





