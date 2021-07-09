import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.0 as T
import QtQuick.Dialogs 1.0


Item {
 width: 210
 height:42
 id: root
 property ListModel new_model: [""]
 property string selectText: ""
 property int fontSize: 14
 function activationBackend(value){

 }

FontLoader {
        id: bebasFont1
        source: "../font/BebasNeue Regular.ttf"
        }

 ComboBox {

  id:equipmentList
  anchors.verticalCenter: parent.verticalCenter
  width: 210
  height:32

   Component.onCompleted: currentIndex = find(root.selectText)

   onActivated: {

       activationBackend(root.new_model.get(equipmentList.currentIndex).text)
   }

  model: root.new_model

  //the background of the combobox
  background: Rectangle {
      color: "#c60100"
      radius: height/2
  }

  delegate: ItemDelegate {
          id:itemDlgt
          width: equipmentList.width
          height:equipmentList.height
          padding:0

          contentItem: Text {
                leftPadding: -10
              id:textItem
              text: modelData
              color: hovered?"#ffea00":"white"
              font.pointSize: fontSize
              anchors.centerIn: parent
              font.family: bebasFont1.name

              verticalAlignment: Text.AlignVCenter
              horizontalAlignment: Text.AlignHCenter

          }

          background: Rectangle {

            radius: 20
            color:itemDlgt.hovered?"#d10000":"#c60100";
            anchors.left: itemDlgt.left
            anchors.leftMargin: 0
            width:itemDlgt.width-2
          }


   }

   //the arrow on the right in the combobox
   indicator:Image{
         width:15; height:15;
         horizontalAlignment:Image.AlignHCenter
         y:10
         x:175

         source:comboPopup.visible ? "../images/icon/arrow_up.png":"../images/icon/arrow_down.png";
   }

   //the text in the combobox
   contentItem: Text {

        leftPadding: -10
         text: equipmentList.displayText
         font.pointSize: fontSize
          anchors.centerIn: parent
          font.family: bebasFont1.name
         color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
   }

   //the list of elements and their style when the combobox is open
   popup: Popup {
         id:comboPopup
         y: equipmentList.height - 1
         width: equipmentList.width
         height:contentItem.implicitHeigh
         padding: 1

         contentItem: ListView {
             id:listView
             implicitHeight: contentHeight
             model: equipmentList.popup.visible ? equipmentList.delegateModel : null

             ScrollIndicator.vertical: ScrollIndicator { }
         }

         background: Rectangle {
            radius: 20
            color:"#c60100"

         }
     }

  }
}
