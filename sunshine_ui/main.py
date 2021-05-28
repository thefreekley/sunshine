# This Python file uses the following encoding: utf-8
import sys
import os

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal

# import sqlite3
#
# conn = sqlite3.connect("database_sunshine.db") # или :memory: чтобы сохранить в RAM
# cursor = conn.cursor()



music_mode = 0
light_mode = 0

wand_troggle = False
music_troggle = False
off_troggle = False
sleep_troggle = False
paint_troggle = False




class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    @Slot(bool, bool, bool, bool, bool)
    def getModeTroggle(self, troggleWand, troggleMusic, troggleOff, troggleSleep, trooglePaint):
        wand_troggle = troggleWand
        music_troggle = troggleMusic
        off_troggle = troggleOff
        sleep_troggle = troggleSleep
        paint_troggle = trooglePaint

    @Slot(bool, bool, bool, bool, bool, bool, bool, bool)
    def getMusicTroggle(self, musicTroggle1, musicTroggle2, musicTroggle3, musicTroggle4, musicTroggle5,musicTroggle6,musicTroggle7,musicTroggle8):
        global music_mode
        if musicTroggle1: music_mode=1
        elif musicTroggle2: music_mode = 2
        elif musicTroggle3:music_mode = 3
        elif musicTroggle4: music_mode = 4
        elif musicTroggle5:music_mode = 5
        elif musicTroggle6: music_mode = 6
        elif musicTroggle7:music_mode = 7
        elif musicTroggle8: music_mode = 8
        else: music_mode = 0

    @Slot(bool, bool, bool, bool)
    def getLightTroggle(self, lightTroggle1, lightTroggle2, lightTroggle3, lightTroggle4):
        global light_mode
        if lightTroggle1: light_mode =1
        elif lightTroggle2: light_mode = 2
        elif lightTroggle3: light_mode = 3
        elif lightTroggle4:light_mode = 4
        else: light_mode = 0



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
