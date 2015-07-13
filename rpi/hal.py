#!/usr/bin/python

from ads1x15_ex_singleended import read_volts
import pigpio
from  HTU21DF import read_temperature
from  HTU21DF import read_humidity

def current_read(channel):
    return read_volts(channel)

def soil_moist_read():
    return ads1x15_ex_singleended.read_volts(3)

def relay_open(channel):
    pi = pigpio.pi()
    relay_pins[8] = [7,0,0,0,0,0,0,0]
    if pi.connected:
        pi.set_mode(relay_pins[channel], pi.OUTPUT)
        pi.write(relay_pins[channel], pi.HIGH)
        pi.stop()
        return 0
    else:
        return -1  

def relay_close(channel):
    pi = pigpio.pi()
    relay_pins[8] = [7,0,0,0,0,0,0,0]
    if pi.connected:
        pi.set_mode(relay_pins[channel], pi.OUTPUT)
        pi.write(relay_pins[channel], pi.LOW)
        pi.stop()
        return 0
    else:
        return -1  

def temp_read(port):
	return read_temperature

def hum_read(port):
	return read_humidity

