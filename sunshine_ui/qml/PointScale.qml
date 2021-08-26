import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T
import QtQuick.Dialogs 1.0

Item {
    property string mode: "day"
    property int troggle: 1

    Rectangle{
        width: 8
        height: 8
        radius: height/2
        opacity: troggle
        color: (mode == "day") ? "#ffd400" : "white"
         y:20
    }
}
