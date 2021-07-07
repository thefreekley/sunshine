import sys
import glob
import serial
from serial.tools import list_ports
def serial_ports():
    ports = [p.device for p in list_ports.comports()]
    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result