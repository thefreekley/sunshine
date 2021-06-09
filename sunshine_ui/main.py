# This Python file uses the following encoding: utf-8
import sys
import os
import datetime
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal, QTimer
from amplitude_level import AmplitudeLevel
from PIL import ImageColor
import time
import sqlite3
import serial
from builtins import chr

conn = sqlite3.connect("database_sunshine.db")
cursor = conn.cursor()

ser = serial.Serial('COM5', 9600, timeout=0)
delta_time = 0
def boolint(boolean):
    return 1 if boolean else 0

def intbool(integer):
    return True if integer==1 else False

cursor.execute("SELECT * FROM info")
info_database = cursor.fetchall()

string_time_to_sleep = ""
current_day = 0
progress_percent = 0
tie_device = False

print(info_database)

if len(info_database) == 0:

    current_id = 0

    color_1 = "#ff0100"
    color_2 = "#c60100"

    sleep_from = [0]*2
    sleep_to = [0]*2

    sleep_from = [22,33]
    sleep_to = [21,18]

    value_light = 50
    value_laud = 10

    music_mode = 2
    light_mode = 1

    wand_troggle = True
    music_troggle = False
    off_troggle = False
    sleep_troggle = False
    paint_troggle = False
else:
    current_id = info_database[0][0]
    wand_troggle = intbool(info_database[0][1])
    music_troggle = intbool(info_database[0][2])
    off_troggle = intbool(info_database[0][3])
    sleep_troggle = intbool(info_database[0][4])
    paint_troggle = intbool(info_database[0][5])
    sleep_from =[info_database[0][6],info_database[0][7]]
    sleep_to =[info_database[0][8],info_database[0][9]]
    value_light = info_database[0][10]
    value_laud = info_database[0][11]
    music_mode = info_database[0][12]
    light_mode = info_database[0][13]
    color_1 = info_database[0][14]
    color_2 = info_database[0][15]


audio_input = AmplitudeLevel()
coef_frequence = []

class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.timer = QTimer()
        self.timer.timeout.connect(self.doWork)
        if sleep_troggle:
            self.timer.start(1000)

        self.timer_equalizer = QTimer()
        self.timer_equalizer.timeout.connect(self.equalizerCurves)
        self.timer_equalizer.start(50)

    def equalizerCurves(self):
        global coef_frequence
        coef_frequence = []
        fft_out = audio_input.get_fft()

        for i in range(len(fft_out)):
            a = int(fft_out[i]/40)
            if a>200:
                a =200
            coef_frequence.append(a)



    @Slot(bool)
    def troggleEqualizer(self,troggle):
        global coef_frequence
        if troggle : self.timer_equalizer.start(50)
        else:
            self.timer_equalizer.stop()
            coef_frequence= [0]*len(coef_frequence)


    @Slot(int,result=int)
    def equalizerLine(self,index):

        global coef_frequence

        return coef_frequence[index]

    def doWork(self):
        global sleep_to, sleep_from, progress_percent,string_time_to_sleep,current_day,delta_time

        curent_time = (str(datetime.datetime.now(tz=None))[11:19]).split(":")
        current_second = (int(curent_time[0]))*60*60 + (int(curent_time[1]))*60 + (int(curent_time[2]))



        from_in_seconds = sleep_from[0]*60*60 + sleep_from[1]*60
        to_in_seconds = sleep_to[0]*60*60 + sleep_to[1]*60

        new_current_day = int(datetime.date.today().day)
        current_second = current_second + (24 * 60 * 60) * (current_day - new_current_day)

        if to_in_seconds<from_in_seconds:
            to_in_seconds = to_in_seconds + 24*60*60

        if current_second<to_in_seconds:
            if current_second - from_in_seconds >= 0:
                delta_time = to_in_seconds - current_second
                progress_percent = 1-delta_time/(to_in_seconds - from_in_seconds)
                time_string = (str(datetime.timedelta(seconds=delta_time ))).split(":")
                string_time_to_sleep = (time_string[0] + " h " ) if int(time_string[0]) >  0 else ""
                string_time_to_sleep = string_time_to_sleep + (time_string[1] + " min ") if int(time_string[1]) > 0 else ""
                string_time_to_sleep = string_time_to_sleep + (time_string[2] + " sec ") if int(time_string[2]) > 0 else ""

        else:
            progress_percent = 1
            string_time_to_sleep = "Finish"










    @Slot(result=int)
    def lightModeNumber(self):
        global light_mode
        return light_mode

    @Slot(result=int)
    def musicModeNumber(self):
        global music_mode
        return music_mode

    @Slot(str,result=bool)
    def modeNumber(self,item):
        if item== "wand": return wand_troggle
        elif item == "music": return music_troggle
        elif item == "off":return off_troggle
        elif item == "sleep":return sleep_troggle
        elif item == "paint": return paint_troggle


    @Slot(result=int)
    def lightSliderValue(self):
        global value_light
        return value_light


    @Slot(str)
    def getId(self,id_string):

        print( int(id_string[3:]))

    @Slot(int)
    def getSliderLightValue(self, value):
        global value_light
        value_light = value
        items = list()
        items.append(value_light)
        toController(broadcast=tie_device, id=current_id, mode=4, item=items)
        time.sleep(0.05)

    @Slot(result=int)
    def loudSliderValue(self):
        global value_laud
        return value_laud

    @Slot(int)
    def getSliderLoundValue(self, value):
        global value_laud
        value_laud = value
        items = list()
        items.append(value_laud)
        toController(broadcast=tie_device, id=current_id, mode=5, item=items)
        time.sleep(0.05)

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
        global color_1,color_2,paint_troggle
        if index==1: color_1 = value
        elif index == 2: color_2 = value
        if paint_troggle:
            items = list()
            items.append(ImageColor.getcolor(color_1, "RGB")[0])
            items.append(ImageColor.getcolor(color_1, "RGB")[1])
            items.append(ImageColor.getcolor(color_1, "RGB")[2])

            items.append(ImageColor.getcolor(color_2, "RGB")[0])
            items.append(ImageColor.getcolor(color_2, "RGB")[1])
            items.append(ImageColor.getcolor(color_2, "RGB")[2])

            toController(broadcast=tie_device,id=current_id,mode=7,item=items)


    @Slot(result=str)
    def timeToSleep(self):
        global sleep_to
        return str(sleep_to[0]) + ("0" if sleep_to[0]==0 else "") + ":" + str(sleep_to[1]) + ("0" if sleep_to[1]==0 else "")

    @Slot(result=str)
    def timeFromSleep(self):
        global sleep_from
        return str(sleep_from[0]) + ("0" if sleep_from[0]==0 else "") + ":" + str(sleep_from[1]) + ("0" if sleep_from[1]==0 else "")

    @Slot(result=str)
    def currentTime(self):
        return str(datetime.datetime.now(tz=None))[11:16]

    @Slot(result=str)
    def remainTime(self):
        global string_time_to_sleep,delta_time
         
        return string_time_to_sleep

    @Slot(result=float)
    def progressBarValue(self):
        global progress_percent
        return progress_percent

    @Slot(bool)
    def getTieConnect(self,tie):
        global tie_device
        tie_device = tie


    @Slot()
    def saveInfo(self):
        save()

    @Slot(str)
    def getTimeFromToSleep(self, value):
        global sleep_from, sleep_to,current_day
        split_value = value.split("-")

        sleep_from[0] = int(split_value[0].split(":")[0])
        sleep_from[1] = int(split_value[0].split(":")[1])

        sleep_to[0] = int(split_value[1].split(":")[0])
        sleep_to[1] = int(split_value[1].split(":")[1])

        current_day =int(datetime.date.today().day)









    @Slot(bool, bool, bool, bool, bool)
    def getModeTroggle(self, troggleWand, troggleMusic, troggleOff, troggleSleep, trooglePaint):
        global wand_troggle,music_troggle,off_troggle,sleep_troggle,paint_troggle,music_mode,light_mode,color_1,color_2
        wand_troggle = troggleWand
        music_troggle = troggleMusic
        off_troggle = troggleOff
        sleep_troggle = troggleSleep
        paint_troggle = trooglePaint
        if wand_troggle:
            toController(broadcast=tie_device, id=current_id, mode=2, item=[music_mode])
            time.sleep(0.05)
        if music_troggle:
            toController(broadcast=tie_device, id=current_id, mode=1, item=[light_mode])
            time.sleep(0.05)
        if off_troggle:
            toController(broadcast=tie_device, id=current_id, mode=3, item=[1 if off_troggle else 0])
            time.sleep(0.05)
        if sleep_troggle:
            toController(broadcast=tie_device, id=current_id, mode=3, item=[1 if off_troggle else 0])
            time.sleep(0.05)
        if paint_troggle:
            items = list()
            items.append(ImageColor.getcolor(color_1, "RGB")[0])
            items.append(ImageColor.getcolor(color_1, "RGB")[1])
            items.append(ImageColor.getcolor(color_1, "RGB")[2])

            items.append(ImageColor.getcolor(color_2, "RGB")[0])
            items.append(ImageColor.getcolor(color_2, "RGB")[1])
            items.append(ImageColor.getcolor(color_2, "RGB")[2])

            toController(broadcast=tie_device, id=current_id, mode=7, item=items)


        self.suport_mod(sleep = troggleSleep)

    def suport_mod(self, sleep=False):
        if sleep:
            self.timer.start(1000)
        else:
            self.timer.stop()

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
            toController(broadcast=tie_device, id=current_id, mode=1, item=[music_mode])
            time.sleep(0.05)

    @Slot(bool, bool, bool, bool)
    def getLightTroggle(self, lightTroggle1, lightTroggle2, lightTroggle3, lightTroggle4):
        global light_mode
        if light_mode:
            if lightTroggle1: light_mode =1
            elif lightTroggle2: light_mode = 2
            elif lightTroggle3: light_mode = 3
            elif lightTroggle4:light_mode = 4
            toController(broadcast=tie_device, id=current_id, mode=2, item=[light_mode])
            time.sleep(0.05)


def toController(broadcast, id, mode,item):

    if broadcast is False:
        ser.write(bytes([0]))
        ser.write(bytes([id]))
    else:
        ser.write(bytes([1]))

    ser.write(bytes([mode]))

    for i in item:
        ser.write(bytes([i]))



def save():
    list_save = [current_id, boolint(wand_troggle), boolint(music_troggle), boolint(off_troggle), boolint(sleep_troggle), boolint(paint_troggle),
                 int(sleep_from[0]),int(sleep_from[1]),int(sleep_to[0]),int(sleep_to[1]),value_light,value_laud,music_mode,light_mode,color_1,color_2
    ]
    cursor.execute("DELETE FROM info WHERE id = ?",[current_id])
    print(list_save)
    cursor.execute("INSERT INTO info  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", list_save)
    conn.commit()




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
