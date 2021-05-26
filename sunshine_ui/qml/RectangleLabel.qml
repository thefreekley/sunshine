import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T

Item{
    property string textLabel: "value"
    width: 200
    height: 42

    id: root
    Rectangle {

        id:rectangle_lable
        width: 200
        height: 42
        color: "#9a4268"
        radius: 20

        Label {
            id: labelTitle1
            x: 420
            y: 21
            color: "#ffffff"
            text: qsTr(root.textLabel)
            font.pointSize: 13
            anchors.centerIn: parent
            FontLoader {
                id: bebasFont1
                source: "../font/BebasNeue Regular.ttf"
            }

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {
                    labelTitle1.state = "PRESSED"
                    labelUp1.start()


                }
                onExited: {
                    labelDown1.start()
                    labelTitle1.state = "RELEASED"
                }

            }

            NumberAnimation {
                id: labelUp1
                target: labelTitle1
                property: "font.pointSize"
                duration: 50
                to: 15
            }

            NumberAnimation {
                id: labelDown1
                target: labelTitle1
                property: "font.pointSize"
                duration: 50
                to: 13
            }
            font.family: bebasFont1.name
            states: [
                State {
                    name: "PRESSED"
                    PropertyChanges {
                        target: labelTitle1
                        color: "#ffea00"
                    }
                },
                State {
                    name: "RELEASED"
                    PropertyChanges {
                        target: labelTitle1
                        color: "white"
                    }
                }]
            transitions: [
                Transition {
                    ColorAnimation {
                        target: labelTitle1
                        duration: 100
                    }
                    to: "RELEASED"
                    from: "PRESSED"
                },
                Transition {
                    ColorAnimation {
                        target: labelTitle1
                        duration: 100
                    }
                    to: "PRESSED"
                    from: "RELEASED"
                }]
        }
        anchors.topMargin: 10
        anchors.leftMargin: 5
    }
}
