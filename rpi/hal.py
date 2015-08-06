#!/usr/bin/python

from ads1x15_ex_singleended import read_volts
#import pigpio
from  HTU21DF import read_temperature
from  HTU21DF import read_humidity
from Adafruit_MCP230xx import Adafruit_MCP230XX
from pca9548a import TI_TCA9548A
from Adafruit_ADS1x15 import ADS1x15
import time 
class hal(object):
    def __init__(self):
        self.mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
        self.tca = TI_TCA9548A(address = 0x70)
        self.tca.portSet(0)                     # Disable all iic ports

         

    def current_read(self, port, channel):
        samples = list()
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        adc = ADS1x15(address=0x48,ic=0)
        samples.append(adc.startContinuousConversion(channel=channel,pga=6144,sps=920) / 1000)
        for n in range(1, 152) :
        	samples.append(adc.getLastConversionResults() / 1000)
        	time.sleep(1/920)
        offset = sum(samples) / 153
        print "sensor offset: %f"%offset
        for n in range(0, 152) :
        	samples[n] = abs(samples[n] - offset)
        current = sum(samples)/ 153
        return current * 0.100 # 100mV per amp scale on sensor
    
    def soil_moist_read(self, port):
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        adc = ADS1x15(address=0x48,ic=0)
        return adc.readADCSingleEnded(channel=2)
    
    
    def temp_read(self, port):
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        temp = read_temperature()
        return temp
    
    def hum_read(self, port):
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        hum = read_humidity()
        return hum
    
    def relay_init(self, port):
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
        for pin in range(0,8):
             mcp.config(pin, mcp.OUTPUT)
        
    def relay_writeMask(self, port,mask):
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
        mcp.write8(mask)
    
    def relay_readState(self, port):
        tca = TI_TCA9548A(address = 0x70)
        tca.portSet(1 << port)
        mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
        return mcp.readU8()


if __name__ == '__main__':
    rpi = hal() 
    temp = rpi.temp_read(3)                 # Temp and humidity sensor is on iic channel 3
    humidity = rpi.hum_read(3)              # Temp and humidity sensor is on iic channel 3
    rpi.relay_init(5)                       # Relay control is on iic channel 5
    relays = rpi.relay_readState(5)         # Relay control is on iic channel 5
    moisture = rpi.soil_moist_read(4)       # ADC is on iic channel 4
    print "reading current"
    current = rpi.current_read(4,0)
    print "Current Temp: %02.2fC" % temp
    print "Current Humidity: %02.2f" %humidity
    for relay in range(0, 8):
        if relays & 1 << relay :
            print "Relay %d is inactive" %relay
        else:
            print "Relay %d is active" %relay   
    print "Soil Moisture: %01.3f (sensor currently disconnected)" % moisture
    print " RMS Current on Relay 0: %02.2f" %current
