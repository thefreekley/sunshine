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
    title: qsTr("Sunshine")

    property int previousX
    property int previousY


        Component.onCompleted: {
            setSerialPort()
            setIdList()
            setAudioInput()
        }

    function setSerialPort(){
        var serialPortStr = backend.callSerialPortList();
        var serialPortListSplit = (serialPortStr).split("-")
        for(var i = 0; i < serialPortListSplit.length;i++){
            compCombobox.new_model.append({ text:serialPortListSplit[i]})
    }

    }

    function setIdList(){
        var idStr = backend.callIdListName();
        var idListSplit = (idStr).split("-")
        for(var i = 0; i < idListSplit.length;i++){
            idCombobox.new_model.append({ text:idListSplit[i]})
    }

    }


    function setAudioInput(){
        var audioInputStr = backend.callAudioInputList();
        var audioInputSplit = (audioInputStr).split("-")
        for(var i = 0; i < audioInputSplit.length;i++){
            inputCombobox.new_model.append({ text:audioInputSplit[i]})
    }

    }

    function callModeBackend(){

        backend.getModeTroggle(wandLight.troggle,iconMusic.troggle,iconOff.troggle,screenLight.troggle,painLight.troggle)

        backend.getLightTroggle(lightButton1.troggle,lightButton2.troggle,lightButton3.troggle,lightButton4.troggle)

        backend.getMusicTroggle(smallButtonMusic1.troggle,smallButtonMusic2.troggle,smallButtonMusic3.troggle,smallButtonMusic4.troggle,
                                smallButtonMusic5.troggle,smallButtonMusic6.troggle,smallButtonMusic7.troggle,smallButtonMusic8.troggle)

        save.opacity = 0.8
        animationLoader(true,500)
    }
    Timer {
          id: timerLoader
          interval: 5000; running: true; repeat: false
          onTriggered: animationLoader(false)
    }

    Timer {
          id: stopRoatLoader
          interval: 100; running: true; repeat: false
          onTriggered: animationLoaderRotate.stop()
    }


    function animationLoader(state,during){
        loader.stateLoader=state
        if(loader.stateLoader){
            animationLoaderRotate.start()
            animationLoaderOpacityUp.start()
            timerLoader.interval = during
            timerLoader.start()
        }
        else{
            animationLoaderOpacityDown.start()
            stopRoatLoader.start()
        }

    }



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
                        Component.onCompleted: {
                            if(treeButton.troggle==false) label.text = backend.callId()
                            else label.text = "ALL"
                        }

                        font.family: bebasRegularFont.name
                        anchors.centerIn: parent
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 30
                        color:  "#9a4268"

                    }

                    Label {
                        id: labelNameMone
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



                Rectangle {

                    id: loader
                    x: 390
                    y: 185
                    width: 260
                    height: 260
                    radius: 100
                    color: "#00000000"
                    anchors.top: parent.top
                    anchors.topMargin: 67
                    anchors.centerIn: parent
                    property bool stateLoader: false
                    Component.onCompleted: {
                        animationLoaderOpacityDown.start()
                    }


                    Image
                    {
                        anchors.centerIn: parent
                        width: 220
                        height: 220
                        source: "../images/other/round.png"
                        RotationAnimation on rotation {
                            id: animationLoaderRotate
                            running: true
                            from: 0
                            to: 360
                            duration: 16000
                            loops: Animation.Infinite
                        }
                        NumberAnimation on opacity {
                               running: false
                              id: animationLoaderOpacityUp
                              from: 0; to: 1
                          }
                        NumberAnimation on opacity {
                               running: false
                               id: animationLoaderOpacityDown
                               from: 1; to: 0
                          }
                    }

                }

                RoundButtonImg  {
                    id: iconOff
                    width: 50
                    height: 50
                    troggle: backend.modeNumber("off")
                    imageSource: "../images/icon/off.png"
                    x_value: 0
                    y_value: 140

                }

                RoundButtonImg  {
                    id: iconMusic
                    width: 50
                    height: 50
                    troggle: backend.modeNumber("music")
                    imageSource: "../images/icon/music.png"
                    x_value: -100
                    y_value: 110

                }


                RoundButtonImg  {
                    id: screenLight
                    width: 50
                    height: 50
                    troggle: backend.modeNumber("screen")
                    imageSource: "../images/icon/screen.png"
                    x_value: 100
                    y_value: 110

                }
                RoundButtonImg  {
                    id: painLight
                    width: 50
                    height: 50
                    troggle: backend.modeNumber("paint")
                    imageSource: "../images/icon/paint.png"
                    x_value: 150
                    y_value: 20

                }

                RoundButtonImg  {
                    id: wandLight
                    width: 50
                    height: 50
                    troggle: backend.modeNumber("wand")
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




                    CustomCombobox {
                        id: idCombobox 
                        function activationBackend(value){
                            backend.getNewId(value)
                            if(treeButton.troggle==false){
                                animationLoader(true,500)
                                label.text = backend.callId()
                            }
                        }
                        Component.onCompleted: idCombobox.selectText = backend.callLastIdName()
                        new_model: ListModel{

                        }
                    }

                    CustomCombobox {
                        y: 50
                        id: compCombobox

                        function activationBackend(value){
                            animationLoader(true,5000)
                            backend.getNewCompPort(value)
                            timerUpdateErr.start()


                        }
                        Timer {
                            id: timerUpdateErr
                            interval: 5000;
                            running: false;
                            repeat: false
                            onTriggered: {
                                errComp.opacity = (backend.callErrComport() == 1)? 0:1
                            }
                        }


                        Component.onCompleted: compCombobox.selectText = backend.callCompName()

                        new_model: ListModel{

                        }

                    }
                    CustomCombobox {
                        id: inputCombobox
                        Component.onCompleted: inputCombobox.selectText = backend.callLastIndexInput()
                        function activationBackend(value){
                            animationLoader(true,1000)
                            backend.getInputDevice(value)
                           errAudioInput.opacity = (backend.errAudioDevice() == 1)? 0:1

                        }
                        fontSize: 11
                        y:100
                        new_model: ListModel{


                        }

                    }

                    Rectangle{
                        color: "#ffd400"
                        y:150
                        width:210
                        height: 32
                        radius: height/2
                    TextField {
                        x: 20
                        id: idInput
                        horizontalAlignment: "AlignHCenter"
                        width:100
                        font.family: bebasFont1.name
                        font.pointSize: 13
                        placeholderText: qsTr("ID:")
                        color: "black"

                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: RegExpValidator { regExp: /^\d+$/  }

                        background: Rectangle { color: "#ffd400" }
                    }
                    }

                    Rectangle{
                        id: rectangleAddDevice
                        color: "#ffd400"
                        y:155
                        x:130
                        width:24
                        height:24
                        radius: height/2
                        Label {
                            anchors.centerIn: parent
                            id: addDevice
                            horizontalAlignment: "AlignHCenter"
                            font.family: bebasFont1.name
                            font.pointSize: 23
                            color: "black"
                            text: qsTr("+")
                        }

                        MouseArea{
                            anchors.fill: parent

                            hoverEnabled: true

                            onEntered: { addDevice.color = "#ffd400"; rectangleAddDevice.color="black" }
                            onExited: { addDevice.color = "black"; rectangleAddDevice.color="#ffd400" }

                            onClicked:{
                               idInput.cursorVisible = false

                                var sameId = 0
                                for(var i=0; i< idCombobox.new_model.count;i++){
                                    var item = idCombobox.new_model.get(i).text


                                    if(item == ("id:" + idInput.text.toString())){
                                        sameId = 1
                                    }
                                }

                               if(sameId == 0 && idInput.text.toString()!="") idCombobox.new_model.append({ text: "id:" + idInput.text.toString()} )
                                idInput.text = ""
                            }

                        }

                    }

                    Rectangle{
                        color: "#ffd400"
                        id: rectangleRemoveDevice
                        y:155
                        x:170
                        width:24
                        height:24
                        radius: height/2
                        Label {
                            anchors.centerIn: parent
                            id: removeDevice
                            horizontalAlignment: "AlignHCenter"
                            font.family: bebasFont1.name
                            font.pointSize: 23
                            color: "black"
                            text: qsTr("-")
                        }

                        MouseArea{
                            anchors.fill: parent

                            hoverEnabled: true
                            onEntered: { removeDevice.color = "#ffd400"; rectangleRemoveDevice.color="black" }
                            onExited: { removeDevice.color = "black"; rectangleRemoveDevice.color="#ffd400" }

                            onClicked:{
                               idInput.cursorVisible = false


                                for(var i=0; i< idCombobox.new_model.count;i++){
                                    var item = idCombobox.new_model.get(i).text

                                    console.log(item,idInput.text.toString())
                                    if(item == ("id:" + idInput.text.toString())){
                                        idCombobox.new_model.remove(i,1)
                                    }
                                }
                                idInput.text = ""

                            }
                        }

                    }






                    Rectangle{

                        id: rectanglePaint
                        property bool sameColor: false
                        height: 350
                        width: parent.width
                        color: "#00000000"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 20
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
                                onClicked: {
                                   if(!rectanglePaint.sameColor) colorDialog2.open()
                                }
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

                        Image {

                            id: twoArrow
                            x: 128
                            width: 24
                            opacity: rectanglePaint.sameColor ? 0.6 : 1
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            source: "../images/icon/two_arrow.png"
                            anchors.bottomMargin: 144
                            anchors.topMargin: 160
                            fillMode: Image.PreserveAspectFit
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    rectanglePaint.sameColor = !rectanglePaint.sameColor
                                    twoArrow.opacity =  rectanglePaint.sameColor ? 0.6 : 1
                                    colorButton2.opacity =  rectanglePaint.sameColor ? 0 : 1
                                    if(rectanglePaint.sameColor){
                                        colorDialog2.color = colorDialog1.color
                                        gradientPaintTop.restart()
                                        gradientPaintBottom.restart()
                                        gradientPaintMiddle.restart()


                                    }
                                }
                            }
                        }

                        ColorDialog {
                            id: colorDialog1
                            title: qsTr("choose the color")
                            onAccepted: {

                                backend.getCollorPallet(colorDialog1.color,1)
                                if(rectanglePaint.sameColor){
                                    colorDialog2.color = colorDialog1.color
                                    backend.getCollorPallet(colorDialog1.color,2)
                                }

                                gradientPaintTop.restart()
                                gradientPaintBottom.restart()
                                gradientPaintMiddle.restart()



                            }

                            color: backend.colorOnePallete()
                        }

                        ColorDialog {
                            id: colorDialog2
                            title: qsTr("choose the color")
                            onAccepted: {
                                gradientPaintTop.restart()
                                gradientPaintBottom.restart()
                                gradientPaintMiddle.restart()
                                backend.getCollorPallet(colorDialog2.color,2)
                            }
                            color: backend.colorTwoPallete()
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

                        width: parent.width - 20
                        height: 12

                        Timer {
                            id: timerToSleep
                            interval: 1000;
                            running: true;
                            repeat: true
                            onTriggered: {

                                timeToSleepRemainTime.text = backend.remainTime()
                                control.value = backend.progressBarValue()

                            }
                        }

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
                        id: timeToSleepRemainTime
                        x: 81
                        y: 18
                        width: 79
                        height: 69

                        color: "#ff6860"
                        text: backend.remainTime()
                        font.pointSize: 13
                        font.family: bebasFont1.name
                    }

                    Rectangle {
                        id: sleepButton
                        property string timeToSleepValue: "-"
                        x: 0
                        y: 46
                        width: 113
                        height: 30
                        radius: 15
                        color: "#00d4e0"

                        //                        MouseArea{
                        //                            anchors.fill: parent
                        //                            onClicked:{
                        //                                sleepButton.timeToSleepValue = qsTr(textFieldFrom.text + "-" + textFieldTo.text)

                        //                                backend.getTimeFromToSleep(sleepButton.timeToSleepValue)
                        //                            }
                        //                        }

                        Label {
                            id: sleepAll
                            font.family: bebasFont1.name
                            font.pointSize: 13
                            color: "white"
                            text: qsTr("SLEEP")
                            anchors.centerIn: parent
                            property string duringTime: ""
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    textFieldFrom.cursorVisible = false
                                    textFieldTo.cursorVisible = false

                                    var timeSplitFrom = ""
                                    var timeSplitTo = ""
                                    var hour = 0
                                    var minute = 0

                                    if(timeSplitFrom[0] != "" && timeSplitFrom[1] != "" && timeSplitTo[0] != "" && timeSplitTo[1] != ""){
                                        notValid.opacity = 0
                                        timeSplitFrom = (textFieldFrom.text).split(":")
                                        hour = parseInt(timeSplitFrom[0])
                                        minute = parseInt(timeSplitFrom[1])
                                        textFieldFrom.text = ((hour<10) ? "0":"") + (hour).toString() + ":" + ((minute<10) ? "0":"") + (minute).toString()

                                        timeSplitTo = (textFieldTo.text).split(":")
                                        hour = parseInt(timeSplitTo[0])
                                        minute = parseInt(timeSplitTo[1])

                                        textFieldTo.text = ((hour<10) ? "0":"") + (hour).toString() + ":" + ((minute<10) ? "0":"") + (minute).toString()

                                        sleepAll.duringTime = textFieldFrom.text + "-" + textFieldTo.text

                                        backend.getTimeFromToSleep(sleepAll.duringTime)

                                    }

                                    timeSplitFrom = (textFieldFrom.text).split(":")
                                    if (timeSplitFrom[0] == "" || timeSplitFrom[1] == ""){
                                        notValid.opacity = 1
                                        textFieldFrom.text = backend.currentTime()
                                        timeSplitFrom = (textFieldFrom.text).split(":")
                                        hour = parseInt(timeSplitFrom[0])
                                        minute = parseInt(timeSplitFrom[1])

                                        textFieldFrom.text = ((hour<10) ? "0":"") + (hour).toString() + ":" + ((minute<10) ? "0":"") + (minute).toString()
                                    }




                                    timeSplitTo = (textFieldTo.text).split(":")
                                    if (timeSplitTo[0] == "" || timeSplitTo[1] == ""){
                                        notValid.opacity = 1
                                        textFieldTo.text = backend.currentTime()
                                        if(minute>54){
                                            minute = 0
                                            if(hour == 23)hour = 0
                                            else hour++
                                        }
                                        else minute+=5



                                        textFieldTo.text = ((hour<10) ? "0":"") + (hour).toString() + ":" + ((minute<10) ? "0":"") + (minute).toString()
                                    }







                                }
                            }

                        }
                    }

                    Rectangle {
                        id: timeRectangle
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
                                id: textFieldFrom
                                horizontalAlignment: "AlignRight"
                                width:60
                                font.family: bebasFont1.name
                                font.pointSize: 13
                                placeholderText: qsTr("from")
                                color: "black"
                                text: backend.timeFromSleep()
                                inputMask: "99:99"
                                inputMethodHints: Qt.ImhDigitsOnly
                                validator: RegExpValidator { regExp: /^([0-1\s]?[0-9\s]|2[0-3\s]):([0-5\s][0-9\s])$ / }

                                background: Rectangle { color: "#ffd400" }
                            }

                            TextField {
                                id: textFieldTo
                                width:60
                                font.family: bebasFont1.name
                                font.pointSize: 13
                                placeholderText: qsTr("to")
                                color: "black"
                                text: backend.timeToSleep()
                                inputMask: "99:99"
                                inputMethodHints: Qt.ImhDigitsOnly
                                validator: RegExpValidator { regExp: /^([0-1\s]?[0-9\s]|2[0-3\s]):([0-5\s][0-9\s])$ / }

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

                        Image {

                            id: image1
                            width: 53
                            height: 30
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            source: "../images/icon/current.png"
                            anchors.topMargin: 0
                            anchors.bottomMargin: 0
                            anchors.leftMargin: 10
                            fillMode: Image.PreserveAspectFit
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{

                                    textFieldFrom.text = backend.currentTime()
                                    var timeSplitTo = (textFieldFrom.text).split(":")
                                    var hour =0
                                    var minute = 0

                                    hour = parseInt(timeSplitTo [0])
                                    minute = parseInt(timeSplitTo [1])

                                    textFieldTo.text = backend.currentTime()
                                    if(minute>54){
                                        minute = 0
                                        if(hour == 23)hour = 0
                                        else hour++
                                    }
                                    else minute+=5
                                    textFieldTo.text = ((hour<10) ? "0":"") + (hour).toString() + ":" + ((minute<10) ? "0":"") + (minute).toString()
                                }


                            }
                        }

                        Label {
                            id: label1
                            x: 177
                            width: 26
                            height: 30
                            text: qsTr("+")

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {

                                    var timeSplit = (textFieldTo.text).split(":")
                                    if (timeSplit[0] == "" || timeSplit[1] == ""){
                                        textFieldTo.text = backend.currentTime()
                                        timeSplit = (textFieldTo.text).split(":")
                                    }

                                    var hour = parseInt(timeSplit[0])
                                    var minute = parseInt(timeSplit[1])

                                    if(minute>54){
                                        minute = 0
                                        if(hour == 23)hour = 0
                                        else hour++
                                    }
                                    else minute+=5

                                    textFieldTo.text = ((hour<10) ? "0":"") + (hour).toString() + ":" + ((minute<10) ? "0":"") + (minute).toString()




                                }
                            }

                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 14
                            anchors.topMargin: 0
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 18
                        }

                    }


                    RoundButtonTree {

                        id: treeButton
                        width: 50
                        height: 50
                        troggle: false
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


                    Label {
                        id: notValid
                        width: 113
                        height: 13
                        text: qsTr("not valid")
                        opacity: 0
                        color: "#ff6860"
                        font.pointSize: 13
                        font.family: bebasFont1.name
                        anchors.left: parent.left
                        anchors.top: parent.top
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: 82
                        anchors.leftMargin: 0
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

                Label {
                    id: errComp
                    width: 73
                    height: 13
                    font.pointSize: 11
                    color: "#ffffff"
                    opacity: (backend.callErrComport() == 1)? 0:1
                    text: qsTr("Error")
                    font.family: bebasFont1.name
                    anchors.left: column.right
                    anchors.top: column.bottom
                    anchors.topMargin: -515
                    anchors.leftMargin: 6
                }
                Label {
                    id: errAudioInput
                    width: 73
                    height: 13
                    font.pointSize: 11
                    color: "#ffffff"
                    opacity: (backend.errAudioDevice() == 1)? 0:1
                    text: qsTr("Error")
                    font.family: bebasFont1.name
                    anchors.left: column.right
                    anchors.top: column.bottom
                    anchors.topMargin: -465
                    anchors.leftMargin: 6
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
                        from:0
                        to:250

                        value: backend.lightSliderValue()

                        onValueChanged: backend.getSliderLightValue(controlLight.value)


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

                        from:0
                        to:255

                        value: backend.loudSliderValue()

                        onValueChanged: backend.getSliderLoundValue(controlMusic.value)

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
                        id: mode_for_mode
                        x: 50
                        anchors.top: parent.top
                        anchors.topMargin: 62
                        textLabel: "GET FROM DEVICE"
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
                            id: lightButton1
                            imageSource: "../images/light/1.png"
                            troggle: (backend.lightModeNumber() == 1 && backend.modeNumber("wand")) ? true : false
                            label_text: "Fire"
                        }
                        SmallButtonLight {
                            id: lightButton2
                            imageSource: "../images/light/2.png"
                            troggle: (backend.lightModeNumber() == 2 && backend.modeNumber("wand")) ? true : false
                            label_text: "Lava"
                        }
                        SmallButtonLight {
                            id: lightButton3
                            imageSource: "../images/light/3.png"
                            troggle: (backend.lightModeNumber() == 3 && backend.modeNumber("wand")) ? true : false
                            label_text: "Rainbow"
        }
                        SmallButtonLight {
                            id: lightButton4
                            imageSource: "../images/light/4.png"
                            troggle: (backend.lightModeNumber() == 4 && backend.modeNumber("wand")) ? true : false
                            label_text: "Circular Rainbow"
        }
                    }

                    Row {
                        id: row2
                        x: 57
                        width: 142
                        anchors.top: parent.top
                        anchors.topMargin: 170

                        SmallButtonMusic {
                            id: smallButtonMusic1
                            imageSource: "../images/music/1.png"
                            troggle: (backend.musicModeNumber() == 1  && backend.modeNumber("music")) ? true : false
                        }
                        SmallButtonMusic {
                            id: smallButtonMusic2
                            imageSource: "../images/music/2.png"
                            troggle: (backend.musicModeNumber() == 2  && backend.modeNumber("music")) ? true : false
                        }
                        SmallButtonMusic {
                            id: smallButtonMusic3
                            imageSource: "../images/music/3.png"
                            troggle: (backend.musicModeNumber() == 3  && backend.modeNumber("music")) ? true : false
                        }
                        SmallButtonMusic {
                            id: smallButtonMusic4
                            imageSource: "../images/music/4.png"
                            troggle: (backend.musicModeNumber() == 4 && backend.modeNumber("music")) ? true : false
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
                            id: smallButtonMusic5
                            imageSource: "../images/music/5.png"
                            troggle: (backend.musicModeNumber() == 5  && backend.modeNumber("music")) ? true : false
                        }

                        SmallButtonMusic {
                            id: smallButtonMusic6
                            imageSource: "../images/music/6.png"
                            troggle: (backend.musicModeNumber() == 6  && backend.modeNumber("music")) ? true : false
                        }

                        SmallButtonMusic {
                            id: smallButtonMusic7
                            imageSource: "../images/music/7.png"
                            troggle: (backend.musicModeNumber() == 7  && backend.modeNumber("music")) ? true : false
                        }

                        SmallButtonMusic {
                            id: smallButtonMusic8
                            imageSource: "../images/music/8.png"
                            troggle: (backend.musicModeNumber() == 8  && backend.modeNumber("music")) ? true : false
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

                Row {
                    id: equalizerBar
                    x: 823
                    width: 288
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 51
                    anchors.bottomMargin: 32
                    anchors.rightMargin:0




                    EqualizerItem {
                        id: lineEqualizer1
                        line_idex:0
                        color_item: "#ff6861"
                    }

                    EqualizerItem {
                        id: lineEqualizer2
                        line_idex:2
                        color_item: "#00d2df"
                    }

                    EqualizerItem {
                        id: lineEqualizer3
                        line_idex:3
                        color_item: "#ffd300"
                    }

                    EqualizerItem{
                        id: lineEqualizer4
                        line_idex:4
                        color_item: "#ff6861"
                    }
                    EqualizerItem{
                        id: lineEqualizer5
                        line_idex:5
                        color_item: "#00d2df"
                    }
                    EqualizerItem{
                        id: lineEqualizer6
                        line_idex:6
                        color_item: "#ffd300"
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




        Image {
            id: save
            width: 20
            height: 20
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            source: "../images/icon/save.png"
            anchors.leftMargin: 10
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: 0
                onClicked: {
                    save.opacity = 1
                    backend.saveInfo()
                }
            }
        }

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
            anchors.leftMargin: 78
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

        Image {
            id: equalizerTroggle
            property bool troggle_eq: true
            opacity: 1
            x: 33
            width: 29
            height: 25
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            source: "../images/icon/equalizer.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                anchors.leftMargin: 0
                onClicked: {



                    equalizerTroggle.troggle_eq = !equalizerTroggle.troggle_eq

                    backend.troggleEqualizer(equalizerTroggle.troggle_eq)

                    if(equalizerTroggle.troggle_eq) equalizerTroggle.opacity = 1
                    else equalizerTroggle.opacity = 0.5


                }
            }
            anchors.topMargin: 0
            anchors.bottomMargin: 0
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

    Rectangle {
        id: footer
        y: 639
        height: 15
        color: "#9a4268"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        Label {
            font.family: bebasRegularFont
            anchors.centerIn: parent
            font.pointSize: 9
            id: label4
            color:"white"
            width: 73
            height: 13
            text: qsTr("TFK 2021")
            horizontalAlignment: Text.AlignHCenter
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

    Connections{
        target:backend
    }


}










/*##^##
Designer {
    D{i:0;formeditorZoom:2}
}
##^##*/
