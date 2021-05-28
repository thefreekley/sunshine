# This Python file uses the following encoding: utf-8
import sys
import os
import datetime
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal

# import sqlite3
#
# conn = sqlite3.connect("database_sunshine.db") # или :memory: чтобы сохранить в RAM
# cursor = conn.cursor()

color_1 = "#ff0100"
color_2 = "#c60100"

sleep_from = ""
sleep_to = ""

value_light = 50
value_laud = 10

music_mode = 2
light_mode = 1

wand_troggle = False
music_troggle = False
off_troggle = False
sleep_troggle = False
paint_troggle = False




class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)


    @Slot(result=int)
    def lightModeNumber(self):
        global light_mode
        return light_mode

    @Slot(result=int)
    def musicModeNumber(self):
        global music_mode
        return music_mode

    @Slot(result=int)
    def lightSliderValue(self):
        global value_light
        return value_light

    @Slot(int)
    def getSliderLightValue(self,value):
        global value_light
        value_light = value

    @Slot(result=int)
    def loudSliderValue(self):
        global value_laud
        return value_laud

    @Slot(int)
    def getSliderLoundValue(self, value):
        global value_laud
        value_laud = value

    @Slot(result=str)
    def colorOnePallete(self):
        global color_1
        return color_1

    @Slot(result=str)
    def colorTwoPallete(self):
        global color_2
        return color_2


    @Slot(str,int)
    def getCollorPallet(self, value, index):
        global color_1,color_2
        if index==1: color_1 = value
        elif index == 2: color_2 = value

    @Slot(result=str)
    def timeToSleep(self):
        global sleep_to
        return sleep_to

    @Slot(result=str)
    def timeFromSleep(self):
        global sleep_from
        return sleep_from

    @Slot(result=str)
    def currentTime(self):
        return str(datetime.datetime.now(tz=None))[11:16]


    @Slot(str)
    def getTimeFromToSleep(self, value):
        global sleep_from, sleep_to
        split_value = value.split("-")
        sleep_from = split_value[0]
        sleep_to = split_value[1]






    @Slot(bool, bool, bool, bool, bool)
    def getModeTroggle(self, troggleWand, troggleMusic, troggleOff, troggleSleep, trooglePaint):
        global wand_troggle,music_troggle,off_troggle,sleep_troggle,paint_troggle
        wand_troggle = troggleWand
        music_troggle = troggleMusic
        off_troggle = troggleOff
        sleep_troggle = troggleSleep
        paint_troggle = trooglePaint

    @Slot(bool, bool, bool, bool, bool, bool, bool, bool)
    def getMusicTroggle(self, musicTroggle1, musicTroggle2, musicTroggle3, musicTroggle4, musicTroggle5,musicTroggle6,musicTroggle7,musicTroggle8):
        global music_mode

        if music_troggle:
            if musicTroggle1: music_mode=1
            elif musicTroggle2: music_mode = 2
            elif musicTroggle3:music_mode = 3
            elif musicTroggle4: music_mode = 4
            elif musicTroggle5:music_mode = 5
            elif musicTroggle6: music_mode = 6
            elif musicTroggle7:music_mode = 7
            elif musicTroggle8: music_mode = 8

    @Slot(bool, bool, bool, bool)
    def getLightTroggle(self, lightTroggle1, lightTroggle2, lightTroggle3, lightTroggle4):
        global light_mode
        if light_mode:
            if lightTroggle1: light_mode =1
            elif lightTroggle2: light_mode = 2
            elif lightTroggle3: light_mode = 3
            elif lightTroggle4:light_mode = 4




if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    # Get Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Load Qml file
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
