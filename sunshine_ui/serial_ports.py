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
import math
import win32gui
import serial_ports

comport_name = "COM5"
open_comport_troggle = False
list_id = []
last_id = 1
last_index_input = 3
last_input_name = ""
troggle_equalizer = True



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

print(last_info)

amplituda = 0
troggle_equalizer = True

string_time_to_sleep = ""
current_day = 0
progress_percent = 0
tie_device = False
time_to_send_audio = 20
in_max = 1000000
comp_find_count = 0
comp_find_process = False

info = list()

def update_info(index):
    global info
    temp_info = {
        'id' : info_database[index][0],
        'info' :{
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
        }
    }
    info.append(temp_info)


for i in range(len(info_database)):
    update_info(i)

def get_info(id,property):
    for item in info:
        if item.get('id') == id:
            return item.get('info').get(property)

def set_info(id,property,value):
    for item in info:
        if item.get('id') == id:
            new_value = {property:value}
            item.get('info').update(new_value)

set_info(0,'color_2',"#c60101")
print(get_info(last_id,'color_2') )


