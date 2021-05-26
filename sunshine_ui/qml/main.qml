import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T

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
                    imageSource: "../images/icon/music.png"
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
                RectangleLabel {
                    textLabel: "ON"
                }
            }

            Rectangle {
                id: rectangle4
                y: 342
                height: 227
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
                    height: 200
                    width:400
                    color: "#00000000"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.centerIn: parent

                    T.Slider {
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: controlLight
                        x: 90
                        y: 41
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
                            height: 16
                            radius: 8
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
                        y: 0

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







