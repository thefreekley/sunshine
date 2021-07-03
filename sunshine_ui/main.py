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
import math
import win32gui

conn = sqlite3.connect("database_sunshine.db")
cursor = conn.cursor()

ser = serial.Serial('COM5', 9600, timeout=0)
delta_time = 0
def boolint(boolean):
    return 1 if boolean else 0

def intbool(integer):
    return True if integer==1 else False

def mapping(num,max_cur,max_new): #start - 0
    coef = max_new/max_cur
    return int(coef*num)


import win32gui


def pixel_color_at(x, y):
    hdc = win32gui.GetWindowDC(win32gui.GetDesktopWindow())
    c = int(win32gui.GetPixel(hdc, x, y))
    # (r, g, b)
    return (c & 0xff), ((c >> 8) & 0xff), ((c >> 16) & 0xff)

cursor.execute("SELECT * FROM info")
info_database = cursor.fetchall()

amplituda = 0
troggle_equalizer = True

string_time_to_sleep = ""
current_day = 0
progress_percent = 0
tie_device = False
time_to_send_audio = 20
in_max = 1000000



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
    screen_troggle = False
    paint_troggle = False
else:
    current_id = info_database[0][0]
    wand_troggle = intbool(info_database[0][1])
    music_troggle = intbool(info_database[0][2])
    off_troggle = intbool(info_database[0][3])
    screen_troggle = intbool(info_database[0][4])
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
coef_frequence = [0]*7

class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.screen_timer = QTimer()
        self.screen_timer.timeout.connect(self.screenInfo)
        if screen_troggle:
            self.screen_timer.start(1000)

        self.timer_equalizer = QTimer()
        self.timer_equalizer.timeout.connect(self.equalizerCurves)
        self.timer_equalizer.start(time_to_send_audio)







    def screenInfo(self):
        screenColors = pixel_color_at(*win32gui.GetCursorPos())
        self.toController(broadcast=tie_device, id=current_id, mode=5, item=screenColors)



    def equalizerCurves(self):
        global coef_frequence,troggle_equalizer,amplituda,in_max, audio_input
        old_coef_frequence = coef_frequence
        coef_frequence = []
        fft_out = audio_input.get_fft()



        for i in range(len(fft_out)):
            a = int(fft_out[i]/ (270-value_laud))
            if a>200:
                a =200
            coef_frequence.append(a)

        if music_troggle:
            if music_mode == 6:
                byte_value = 0
                for i in range(len(coef_frequence)-1):
                    if coef_frequence[i]/ (old_coef_frequence[i] + 0.0001)>10:
                        byte_value = byte_value + 2**i

                ser.write(bytes([int(byte_value+3)]))
            else:

                a = int(audio_input.listen())

                amplitude_filter = mapping(a, 6001, value_laud/2)

                amplitude_filter = amplitude_filter **2 + 3

                if amplitude_filter > 255:
                    amplitude_filter = 255

                ser.write(bytes([amplitude_filter]))




        if troggle_equalizer is False:
            coef_frequence = [0] * len(coef_frequence)


    @Slot(bool)
    def troggleEqualizer(self,troggle):
        global coef_frequence, troggle_equalizer
        troggle_equalizer = troggle



    @Slot(int,result=int)
    def equalizerLine(self,index):

        global coef_frequence,value_laud
        new_coef_frequence = list()
        for i in coef_frequence:
            new_coef =  i*(value_laud / 60)
            new_coef_frequence.append( 200 if new_coef>200 else new_coef )



        return new_coef_frequence[index]

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
            # self.toController(broadcast=tie_device, id=current_id, mode=3, item=[0])
            # time.sleep(0.05)










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
        elif item == "screen":return screen_troggle
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
        global value_light,off_troggle
        value_light = value
        if not off_troggle:

            self.toController(broadcast=tie_device, id=current_id, mode=4, item=[value_light])


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

            self.toController(broadcast=tie_device,id=current_id,mode=7,item=items)


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
    def getModeTroggle(self, troggleWand, troggleMusic, troggleOff, troggleScreen, trooglePaint):
        global wand_troggle,music_troggle,off_troggle,screen_troggle,paint_troggle,music_mode,light_mode,color_1,color_2

        if off_troggle is not troggleOff:
            self.toController(broadcast=tie_device, id=current_id, mode=4, item=[0 if troggleOff else value_light])
            time.sleep(0.05)

        if (trooglePaint is not paint_troggle and wand_troggle) or (wand_troggle is not troggleWand and paint_troggle):

            self.toController(broadcast=tie_device, id=current_id, mode=2, item=[5])
            time.sleep(0.05)


        wand_troggle = troggleWand
        music_troggle = troggleMusic
        off_troggle = troggleOff
        screen_troggle = troggleScreen
        paint_troggle = trooglePaint

        print(screen_troggle)

        if screen_troggle:
            self.screen_timer.start(1000)
        else:
            self.screen_timer.stop()




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
            time.sleep(0.5)
            self.toController(broadcast=tie_device, id=current_id, mode=1, item=[music_mode])
            time.sleep(0.5)

    @Slot(bool, bool, bool, bool)
    def getLightTroggle(self, lightTroggle1, lightTroggle2, lightTroggle3, lightTroggle4):
        global light_mode
        if wand_troggle:
            if lightTroggle1: light_mode =1
            elif lightTroggle2: light_mode = 2
            elif lightTroggle3: light_mode = 3
            elif lightTroggle4:light_mode = 4
            if not paint_troggle:
                self.toController(broadcast=tie_device, id=current_id, mode=2, item=[light_mode])


    def toController(self,broadcast, id, mode, item):
        self.timer_equalizer.stop()
        time.sleep(0.02)
        if broadcast is False:
            ser.write(bytes([0]))
            time.sleep(0.02)
            ser.write(bytes([id]))
        else:
            ser.write(bytes([1]))
        time.sleep(0.02)
        ser.write(bytes([mode]))
        time.sleep(0.02)
        for i in item:
            ser.write(bytes([i]))
            time.sleep(0.02)

        time.sleep(0.02)
        self.timer_equalizer.start(time_to_send_audio)




def save():
    list_save = [current_id, boolint(wand_troggle), boolint(music_troggle), boolint(off_troggle), boolint(screen_troggle), boolint(paint_troggle),
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
