import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T
import QtQuick.Dialogs 1.0


Item {


FontLoader {
        id: bebasFont1
        source: "../font/BebasNeue Regular.ttf"
        }

    ComboBox {
        id: control
        model: ["dd:03", "id:02", "id:03"]

        delegate: ItemDelegate {
            width: control.width

            contentItem: Text {
                text: modelData
                color: "#9a4268"
                font.family: bebasFont1.name
                font.pointSize: 14
                elide: Text.ElideRight
                anchors.centerIn: parent
            }
            highlighted: control.highlightedIndex === index

        }

        indicator: Canvas {
            id: canvas

            x: control.width - width - control.rightPadding
            y: control.topPadding + (control.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            Connections {
                target: control
                function onPressedChanged() { canvas.requestPaint(); }
            }

            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = control.pressed ? "#743450" : "#9a4268";
                context.fill();
            }
        }

        contentItem: Text {
            leftPadding: 0
            rightPadding: control.indicator.width + control.spacing

            text: control.displayText
            font.family: bebasFont1.name
            font.pointSize: 14
            color: control.pressed ? "#743450" : "#9a4268"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 40
            border.color: control.pressed ? "#743450" : "#9a4268"
            border.width: control.visualFocus ? 2 : 1
            radius: 2
        }

        popup: Popup {
            y: control.height - 1
            width: control.width
            implicitHeight: contentItem.implicitHeight
            padding: 1

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: control.popup.visible ? control.delegateModel : null
                currentIndex: control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                border.color: "#9a4268"
                radius: 2
            }
        }
    }
}
