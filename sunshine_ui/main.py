# This Python file uses the following encoding: utf-8
import sys
import os
import datetime
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal, QTimer
from amplitude_level import AmplitudeLevel

# import sqlite3
#
# conn = sqlite3.connect("database_sunshine.db") # или :memory: чтобы сохранить в RAM
# cursor = conn.cursor()

color_1 = "#ff0100"
color_2 = "#c60100"

sleep_from = [0]*2
sleep_to = [0]*2

sleep_from = [22,33]
sleep_to = [21,18]
current_day = 0
string_time_to_sleep = ""



progress_percent = 0

value_light = 50
value_laud = 10

music_mode = 2
light_mode = 1

wand_troggle = False
music_troggle = False
off_troggle = False
sleep_troggle = False
paint_troggle = False


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
        global sleep_to, sleep_from, progress_percent,string_time_to_sleep,current_day

        curent_time = (str(datetime.datetime.now(tz=None))[11:19]).split(":")
        curent_second = (int(curent_time[0]))*60*60 + (int(curent_time[1]))*60 + (int(curent_time[2]))


        from_in_seconds = sleep_from[0]*60*60 + sleep_from[1]*60
        to_in_seconds = sleep_to[0]*60*60 + sleep_to[1]*60



        if from_in_seconds < to_in_seconds and curent_second<to_in_seconds:
            if curent_second - from_in_seconds >= 0:
                delta_time = to_in_seconds - curent_second
                progress_percent = 1-delta_time/(to_in_seconds - from_in_seconds)
                time_string = (str(datetime.timedelta(seconds=delta_time ))).split(":")
                string_time_to_sleep = (time_string[0] + " h " ) if int(time_string[0]) >  0 else ""
                string_time_to_sleep = string_time_to_sleep + (time_string[1] + " min ") if int(time_string[1]) > 0 else ""
                string_time_to_sleep = string_time_to_sleep + (time_string[2] + " sec ") if int(time_string[2]) > 0 else ""

        elif from_in_seconds < to_in_seconds and curent_second>to_in_seconds:
            progress_percent = 1
            string_time_to_sleep = "Finish"

        #need fix
        new_current_day = int(datetime.date.today().day)
        if (from_in_seconds+ (24 * 60*60)*(current_day- new_current_day)) < (to_in_seconds + (24 * 60*60) ):

            curent_second = curent_second + (24 * 60*60)*(current_day- new_current_day)

            if curent_second - from_in_seconds >= 0:
                delta_time = (to_in_seconds + 24*60*60) - curent_second
                progress_percent = 1-delta_time/((to_in_seconds + 24*60*60) - (from_in_seconds+ (24 * 60*60)*(current_day- new_current_day)))
                time_string = (str(datetime.timedelta(seconds= abs(delta_time)))).split(":")
                string_time_to_sleep = (time_string[0] + " h ") if int(time_string[0]) > 0 else ""
                string_time_to_sleep = string_time_to_sleep + (time_string[1] + " min ") if int(time_string[1]) > 0 else ""
                string_time_to_sleep = string_time_to_sleep + (time_string[2] + " sec ") if int( time_string[2]) > 0 else ""








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
        return str(sleep_to[0]) + ":" + str(sleep_to[1])

    @Slot(result=str)
    def timeFromSleep(self):
        global sleep_from
        return str(sleep_from[0]) + ":" + str(sleep_from[1])

    @Slot(result=str)
    def currentTime(self):
        return str(datetime.datetime.now(tz=None))[11:16]

    @Slot(result=str)
    def remainTime(self):
        global string_time_to_sleep
        return string_time_to_sleep

    @Slot(result=float)
    def progressBarValue(self):
        global progress_percent
        return progress_percent

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
        global wand_troggle,music_troggle,off_troggle,sleep_troggle,paint_troggle
        wand_troggle = troggleWand
        music_troggle = troggleMusic
        off_troggle = troggleOff
        sleep_troggle = troggleSleep
        paint_troggle = trooglePaint

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
