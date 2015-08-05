#!/usr/bin/python

from ads1x15_ex_singleended import read_volts
#import pigpio
from  HTU21DF import read_temperature
from  HTU21DF import read_humidity
from Adafruit_MCP230xx import Adafruit_MCP230XX
from pca9548a import TI_TCA9548A
from Adafruit_ADS1x15 import ADS1x15
 
def current_read(channel):
    return read_volts(channel)

def soil_moist_read(port):
    tca = TI_TCA9548A(address = 0x70)
    tca.portSet(1 << port)
    adc = ADS1x15(address=0x48,ic=0)
    return adc.readADCSingleEnded(channel=3)


def temp_read(port):
    tca = TI_TCA9548A(address = 0x70)
    tca.portSet(1 << port)
    temp = read_temperature()
    return temp

def hum_read(port):
    tca = TI_TCA9548A(address = 0x70)
    tca.portSet(1 << port)
    hum = read_humidity()
    return hum

def relay_init(port):
    tca = TI_TCA9548A(address = 0x70)
    tca.portSet(1 << port)
    mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
    for pin in range(0,8):
         mcp.config(pin, mcp.OUTPUT)
    
def relay_writeMask(port,mask):
    tca = TI_TCA9548A(address = 0x70)
    tca.portSet(1 << port)
    mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
    mcp.write8(mask)

def relay_readState(port):
    tca = TI_TCA9548A(address = 0x70)
    tca.portSet(1 << port)
    mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
    return mcp.readU8()


if __name__ == '__main__':
    temp = temp_read(3)                 # Temp and humidity sensor is on iic channel 3
    humidity = hum_read(3)              # Temp and humidity sensor is on iic channel 3
    relay_init(5)                       # Relay control is on iic channel 5
    relays = relay_readState(5)         # Relay control is on iic channel 5
    moisture = soil_moist_read(4)       # ADC is on iic channel 4
    print "Current Temp: %02.2fC" % temp
    print "Current Humidity: %02.2f" %humidity
    for relay in range(0, 8):
        if relays & 1 << relay :
            print "Relay %d is inactive" %relay
        else:
            print "Relay %d is active" %relay   
    print "Soil Moisture: %01.3f (sensor currently disconnected)" % moisture
