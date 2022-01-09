#!/usr/bin/python3

import serial, time

ser = serial.Serial("/dev/ttyUSB0", 9600, timeout=0.5)

i = 0
while (1):
    message = (i).to_bytes(4, byteorder="little")
    ser.write(message)
    print(i)
    time.sleep(0.5)
    i = (i + 1)%256
