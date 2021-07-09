import sys
import glob
import serial
from serial.tools import list_ports
import time

def serial_ports():
    ports = [p.device for p in list_ports.comports()]
    result = []
    for port in ports:
        try:
            ser = serial.Serial(port, 9600, timeout=0)
            open_comport_troggle = False
            time.sleep(5)
            for i in range(0, 1000):
                if (str(ser.readline())).find("tfk") != -1:
                    open_comport_troggle = True
            if open_comport_troggle:
                result.append(i)



        except (OSError, serial.SerialException):
            pass

    return result