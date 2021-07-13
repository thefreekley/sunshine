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
from serial.tools import list_ports
import win32gui


comport_name = "COM5"
open_comport_troggle = False
list_id = []
last_id = 1
last_index_input = 3
last_input_name = ""
troggle_equalizer = True
tie_device = False


coef_frequence = [0]*7

conn = sqlite3.connect("database_sunshine.db")
cursor = conn.cursor()

cursor.execute("SELECT * FROM info")
info_database = cursor.fetchall()


cursor.execute("SELECT * FROM last_data")
last_info = cursor.fetchall()

for i in info_database:
    list_id.append(i[0])


def boolint(boolean):
    return 1 if boolean else 0

def intbool(integer):
    return True if integer==1 else False

last_id = last_info[0][0]
comport_name = last_info[0][1]
last_index_input = last_info[0][2]
troggle_equalizer = intbool(last_info[0][3])
tie_device = intbool(last_info[0][4])



try:
    audio_input = AmplitudeLevel(last_index_input)
    open_audio_troggle = True
except:
    open_audio_troggle = False

try:
    ser = serial.Serial(comport_name, 9600, timeout=0)
    open_comport_troggle = True
except:
    open_comport_troggle = False
    ser = False

delta_time = 0


def mapping(num,max_cur,max_new): #start - 0
    coef = max_new/max_cur
    return int(coef*num)





def pixel_color_at(x, y):
    hdc = win32gui.GetWindowDC(win32gui.GetDesktopWindow())
    c = int(win32gui.GetPixel(hdc, x, y))
    # (r, g, b)
    return (c & 0xff), ((c >> 8) & 0xff), ((c >> 16) & 0xff)


amplituda = 0
troggle_equalizer = True

string_time_to_sleep = ""
current_day = 0
progress_percent = 0
time_to_send_audio = 20
in_max = 1000000
comp_find_count = 0
comp_find_process = False

info = list()

def update_info(index):
    global info
    info.append({
        'id' : info_database[index][0],
        'wand_troggle' : intbool(info_database[index][1]),
        'music_troggle' : intbool(info_database[index][2]),
        'off_troggle' : intbool(info_database[index][3]),
        'screen_troggle' : intbool(info_database[index][4]),
        'paint_troggle' : intbool(info_database[index][5]),
        'sleep_from' : [info_database[0][6], info_database[index][7]],
        'sleep_to' : [info_database[0][8], info_database[index][9]],
        'value_light' : info_database[index][10],
        'value_laud' : info_database[index][11],
        'music_mode' : info_database[index][12],
        'light_mode' : info_database[index][13],
        'color_1' : info_database[index][14],
        'color_2' : info_database[index][15]
    })

if len(info_database)==0:
    tie_device = True

for i in range(len(info_database)):
    update_info(i)

def get_info(id,property):
    for item in info:
        if item.get('id') == id:
            return item.get(property)

def set_info(id,property,value):

    for item in info:

        if item.get('id') == id:
            item.update({property:value})






class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        global info,last_id
        self.screen_timer = QTimer()
        self.screen_timer.timeout.connect(self.screenInfo)

        if get_info(last_id, 'screen_troggle'):
            self.screen_timer.start(1000)



        self.timer_equalizer = QTimer()
        self.timer_equalizer.timeout.connect(self.equalizerCurves)
        self.timer_equalizer.start(time_to_send_audio)

        self.timer_find_comp = QTimer()
        self.timer_find_comp.timeout.connect(self.comp_find)








    def comp_find(self):
        global open_comport_troggle,comp_find_count,ser,comport_name,comp_find_process
        serial_ports_list = [p.device for p in list_ports.comports()]
        comp_find_process = True
        if ser:
            ser.close()

        open_comport_troggle = False
        try:
            ser = serial.Serial(serial_ports_list[comp_find_count], 9600, timeout=0)
            time.sleep(3)
            for i in range(0, 1000):
                if (str(ser.readline())).find("tfk") != -1:
                    comport_name = serial_ports_list[comp_find_count]
                    open_comport_troggle = True

        except (OSError, serial.SerialException):
            pass

        comp_find_count+=1
        if comp_find_count == len(serial_ports_list) or open_comport_troggle == True:
            comp_find_count = 0
            self.timer_find_comp.stop()
            comp_find_process = False

        # ser_find.close()
        # ser = serial.Serial(comport_name, 9600, timeout=0)

    def screenInfo(self):
        screenColors = pixel_color_at(*win32gui.GetCursorPos())
        self.toController(broadcast=tie_device, id=last_id, mode=5, item=screenColors)



    def equalizerCurves(self):
        global coef_frequence,troggle_equalizer,amplituda,in_max, audio_input,open_audio_troggle
        old_coef_frequence = coef_frequence
        coef_frequence = []
        if(open_audio_troggle):
            fft_out = audio_input.get_fft()
        else:
            fft_out = [0]*7


        for i in range(len(fft_out)):
            a = int(fft_out[i]/ (270-get_info(last_id,'value_laud')))
            if a>200:
                a =200
            coef_frequence.append(a)

        if get_info(last_id,'music_troggle'):
            if get_info(last_id,'music_mode') == 6:
                byte_value = 0
                for i in range(len(coef_frequence)-1):
                    if coef_frequence[i]/ (old_coef_frequence[i] + 0.0001)>10:
                        byte_value = byte_value + 2**i

                if(open_comport_troggle):
                    ser.write(bytes([int(byte_value+3)]))
            else:
                if(open_audio_troggle):
                    a = int(audio_input.listen())
                else:
                    a = 0

                amplitude_filter = mapping(a, 6001, get_info(last_id,'value_laud')/2)

                amplitude_filter = amplitude_filter **2 + 3

                if amplitude_filter > 255:
                    amplitude_filter = 255
                if (open_comport_troggle):
                    ser.write(bytes([amplitude_filter]))




        if troggle_equalizer is False:
            coef_frequence = [0] * len(coef_frequence)


    @Slot(bool)
    def troggleEqualizer(self,troggle):
        global coef_frequence, troggle_equalizer
        troggle_equalizer = troggle

    @Slot(result=bool)
    def proccesCompFind(self):
        global comp_find_process
        return comp_find_process

    @Slot()
    def startProccesCompFind(self):
        global comp_find_process
        comp_find_process = True
        self.comp_find()
        self.timer_find_comp.start(10000)




    @Slot(int,result=int)
    def equalizerLine(self,index):

        global coef_frequence,value_laud
        new_coef_frequence = list()
        for i in coef_frequence:
            new_coef =  i*(get_info(last_id,'value_laud') / 60)
            new_coef_frequence.append( 200 if new_coef>200 else new_coef )



        return new_coef_frequence[index]

    @Slot(result=str)
    def callSerialPortList(self):
        global comport_name

        serial_ports_list =  [p.device for p in list_ports.comports()]

        str_serial_ports = ""
        for i in serial_ports_list:
            if str_serial_ports.find(i)==-1:
                str_serial_ports+=i
                str_serial_ports+="-"

        if(str_serial_ports.find(comport_name) == -1 and comport_name!="..."):
            temp_str =  str_serial_ports
            str_serial_ports += ""
            str_serial_ports = temp_str + comport_name + "-"

        return str_serial_ports[0:-1]

    def doWork(self):
        global  progress_percent,string_time_to_sleep,current_day,delta_time

        curent_time = (str(datetime.datetime.now(tz=None))[11:19]).split(":")
        current_second = (int(curent_time[0]))*60*60 + (int(curent_time[1]))*60 + (int(curent_time[2]))


        sleep_from = get_info(last_id,'sleep_from')
        sleep_to = get_info(last_id,'sleep_to')

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
            # self.toController(broadcast=tie_device, id=last_id, mode=3, item=[0])
            # time.sleep(0.05)










    @Slot(result=int)
    def lightModeNumber(self):
        return get_info(last_id,'light_mode')

    @Slot(result=str)
    def callCompName(self):
        global comport_name
        return comport_name

    @Slot(result=str)
    def callLastIdName(self):
        global last_id
        return ("id:" + str(last_id))

    @Slot(result=str)
    def callLastIndexInput(self):
        global last_input_name
        return last_input_name

    @Slot(result=str)
    def callIdListName(self):
        str_list_id = ""
        for item in info:
            str_list_id+= "id:" + str(item.get("id")) + "-"
        str_list_id = str_list_id[:-1]

        return str_list_id



    @Slot(result=str)
    def callAudioInputList(self):
        global last_input_name,last_index_input
        audio_list_str = ""
        for i in range(len(audio_input.find_input_device())):

            input_item = audio_input.find_input_device()[i].get("name")
            if(len(input_item)>25):
                input_item = input_item[0:23]
                if input_item[-1] == " ":
                    if input_item.find("(")!=-1:
                        input_item = input_item[:-1] + ")"
                else:
                    input_item += "..)"
            audio_list_str += input_item + "-"
            if(audio_input.find_input_device()[i].get("index") == last_index_input ):
                last_input_name = input_item

        return audio_list_str[:-1]


    @Slot(result=int)
    def musicModeNumber(self):
        return get_info(last_id,'music_mode')

    @Slot(int)
    def removeDeviceId(self,value):
        global last_id,tie_device
        for item in info:

            if item.get("id") == value:
                if len(info) - 1 == 0:
                    temp_item = item.copy()
                    temp_item.update(id = 0)
                    info.append(temp_item)
                    tie_device = True

                info.remove(item)

        if value == last_id:
            last_id = info[0].get("id")




    @Slot(int)
    def addDeviceId(self, value):

        for item in info:
            if item.get("id") == last_id:
                temp_item = item.copy()
                temp_item.update(id = value)
                info.append(temp_item)




    @Slot(str,result=bool)
    def modeNumber(self,item):
        if item == "wand": return get_info(last_id, 'wand_troggle')
        elif item == "music": return get_info(last_id,'music_troggle')
        elif item == "off":return get_info(last_id,'off_troggle')
        elif item == "screen":return get_info(last_id, 'screen_troggle')
        elif item == "paint": return get_info(last_id,'paint_troggle')


    @Slot(result=int)
    def lightSliderValue(self):
        return get_info(last_id,'value_light')



    @Slot(int)
    def getSliderLightValue(self, value):
        set_info(last_id, 'value_light', value)
        if not get_info(last_id,'off_troggle'):
            self.toController(broadcast=tie_device, id=last_id, mode=4, item=[get_info(last_id,'value_light')])

    @Slot(str)
    def getNewId(self, value):
        global last_id
        last_id = int(value.replace("id:",""))




    @Slot(result=str)
    def callId(self):
        global last_id
        return "id:" + str(last_id)

    @Slot(str)
    def getNewCompPort(self, value):
        global comport_name,ser,open_comport_troggle,comport_name
        if ser:
            ser.close()
        try:
            ser = serial.Serial(value, 9600, timeout=0)
            open_comport_troggle = False
            time.sleep(3)

            for i in range(0,1000):
                if (str(ser.readline())).find("tfk") != -1:

                    open_comport_troggle = True

            if open_comport_troggle == True:
                comport_name = value

        except (OSError, serial.SerialException):
            open_comport_troggle = False


        comport_name = value

    @Slot(str)
    def getInputDevice(self, value):
        global audio_input,last_index_input,open_audio_troggle
        for i in range(len(audio_input.find_input_device())):
            input_item = audio_input.find_input_device()[i].get("name")
            if input_item.find(value[0:-4])!=-1:
                last_index_input=i
        try:
            audio_input = AmplitudeLevel(last_index_input)
            open_audio_troggle = True
        except:
            open_audio_troggle = False

    @Slot(result=bool)
    def errAudioDevice(self):
        global open_audio_troggle
        return open_audio_troggle

    @Slot(result=int)
    def loudSliderValue(self):
        return get_info(last_id,'value_laud')

    @Slot(result=bool)
    def callErrComport(self):
        global open_comport_troggle
        return open_comport_troggle

    @Slot(int)
    def getSliderLoundValue(self, value):
        set_info(last_id, 'value_laud', value)



    @Slot(result=str)
    def colorOnePallete(self):
        return get_info(last_id,'color_1')

    @Slot(result=str)
    def colorTwoPallete(self):
        return get_info(last_id,'color_2')


    @Slot(str,int)
    def getCollorPallet(self, value, index):
        if index==1: color_1 = value
        elif index == 2: color_2 = value
        if get_info(last_id,'paint_troggle'):
            items = list()
            items.append(ImageColor.getcolor(get_info(last_id,'color_1'), "RGB")[0])
            items.append(ImageColor.getcolor(get_info(last_id,'color_1'), "RGB")[1])
            items.append(ImageColor.getcolor(get_info(last_id,'color_1'), "RGB")[2])

            items.append(ImageColor.getcolor(get_info(last_id,'color_2'), "RGB")[0])
            items.append(ImageColor.getcolor(get_info(last_id,'color_2'), "RGB")[1])
            items.append(ImageColor.getcolor(get_info(last_id,'color_2'), "RGB")[2])

            self.toController(broadcast=tie_device,id=last_id,mode=7,item=items)


    @Slot(result=str)
    def timeToSleep(self):
        sleep_to = get_info(last_id,'sleep_to')
        return str(sleep_to[0]) + ("0" if sleep_to[0]==0 else "") + ":" + str(sleep_to[1]) + ("0" if sleep_to[1]==0 else "")

    @Slot(result=str)
    def timeFromSleep(self):
        sleep_from = get_info(last_id,'sleep_from')
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
        global current_day
        split_value = value.split("-")

        set_info(last_id, 'sleep_from', [int(split_value[0].split(":")[0]),int(split_value[0].split(":")[1])])
        set_info(last_id, 'sleep_to', [int(split_value[1].split(":")[0]), int(split_value[1].split(":")[1]) ])


        current_day =int(datetime.date.today().day)









    @Slot(bool, bool, bool, bool, bool)
    def getModeTroggle(self, troggleWand, troggleMusic, troggleOff, troggleScreen, trooglePaint):

        if get_info(last_id,'off_troggle') is not troggleOff:
            self.toController(broadcast=tie_device, id=last_id, mode=4, item=[0 if troggleOff else get_info(last_id,'value_light')])
            time.sleep(0.05)

        if (trooglePaint is not get_info(last_id,'paint_troggle') and get_info(last_id, 'wand_troggle')) or (get_info(last_id, 'wand_troggle') is not troggleWand and get_info(last_id,'paint_troggle')):
            self.toController(broadcast=tie_device, id=last_id, mode=2, item=[5])
            time.sleep(0.05)


        set_info(last_id,'wand_troggle',troggleWand)
        set_info(last_id, 'music_troggle', troggleMusic)
        set_info(last_id, 'off_troggle', troggleOff)
        set_info(last_id, 'screen_troggle', troggleScreen)
        set_info(last_id, 'paint_troggle', trooglePaint)



        if get_info(last_id, 'screen_troggle'):
            self.screen_timer.start(1000)
        else:
            self.screen_timer.stop()




    @Slot(bool, bool, bool, bool, bool, bool, bool, bool)
    def getMusicTroggle(self, musicTroggle1, musicTroggle2, musicTroggle3, musicTroggle4, musicTroggle5,musicTroggle6,musicTroggle7,musicTroggle8):

        if get_info(last_id,'music_troggle'):
            if musicTroggle1: set_info(last_id,'music_mode',1)
            elif musicTroggle2: set_info(last_id,'music_mode',2)
            elif musicTroggle3:set_info(last_id,'music_mode',3)
            elif musicTroggle4: set_info(last_id,'music_mode',4)
            elif musicTroggle5:set_info(last_id,'music_mode',5)
            elif musicTroggle6: set_info(last_id,'music_mode',6)
            elif musicTroggle7:set_info(last_id,'music_mode',7)
            elif musicTroggle8:set_info(last_id,'music_mode',8)
            time.sleep(0.5)
            self.toController(broadcast=tie_device, id=last_id, mode=1, item=[get_info(last_id,'music_mode')])
            time.sleep(0.5)

    @Slot(bool, bool, bool, bool)
    def getLightTroggle(self, lightTroggle1, lightTroggle2, lightTroggle3, lightTroggle4):
        if get_info(last_id, 'wand_troggle'):
            if lightTroggle1: set_info(last_id,'light_mode',1)
            elif lightTroggle2: set_info(last_id,'light_mode',2)
            elif lightTroggle3: set_info(last_id,'light_mode',3)
            elif lightTroggle4: set_info(last_id,'light_mode',4)
            if not get_info(last_id,'paint_troggle'):
                self.toController(broadcast=tie_device, id=last_id, mode=2, item=[get_info(last_id,'light_mode')])


    def toController(self,broadcast, id, mode, item):
        if (open_comport_troggle):
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
    cursor.execute("DELETE FROM info")
    for item in info:
        list_save = [item.get('id'), boolint(item.get('info').get('wand_troggle')),
                     boolint(item.get('info').get('music_troggle')),boolint(item.get('info').get('off_troggle')),
                     boolint(get_info(last_id, 'screen_troggle')), boolint(get_info(last_id, 'paint_troggle')),
                     get_info(last_id, 'sleep_from')[0], get_info(last_id, 'sleep_from')[1],
                     get_info(last_id, 'sleep_to')[0], get_info(last_id, 'sleep_to')[1],get_info(last_id, 'value_light'),
                     get_info(last_id, 'value_laud'),get_info(last_id, 'music_mode') , get_info(last_id, 'light_mode'),
                     get_info(last_id, 'color_1'),get_info(last_id, 'color_2')
                     ]
        cursor.execute("INSERT INTO info  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", list_save)

    cursor.execute("DELETE FROM last_data")
    cursor.execute("INSERT INTO last_data  VALUES(?,?,?,?,?)", [last_id,comport_name,last_index_input,boolint(troggle_equalizer),tie_device])

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
