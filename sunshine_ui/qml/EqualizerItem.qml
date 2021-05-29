import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T
import QtQuick.Dialogs 1.0

Item{
    id: root

    width:40
    height: 200
    property string color_item: "white"
    property int update_height: 0
    property int line_idex: 0

    Rectangle{
        id: lineEqualizer
        width: 29

        radius: lineEqualizer.width/2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        color: root.color_item

        NumberAnimation { id: animationEqualizer;
            target: lineEqualizer;
            property: "height";
            to:  update_height
            easing.type: Easing.OutQuad
            duration: 60
        }

        Timer {
            id: timerToUpdateEqualizer
            interval: 60;

            running: true;
            repeat: true
            onTriggered: {
                update_height =  backend.equalizerLine(line_idex)
                animationEqualizer.start()
            }
        }
    }

}
