#a!/usr/bin/python
# -*- coding: utf-8 -*-
from math import sqrt
from ads1x15_ex_singleended import read_volts
#import pigpio
from  HTU21DF import read_temperature
from  HTU21DF import read_humidity
from Adafruit_MCP230xx import Adafruit_MCP230XX
from pca9548a import TI_TCA9548A
from Adafruit_ADS1x15 import ADS1x15
import time 
from scipy.signal import lfilter, firwin
class hal(object):
    def __init__(self):
        self.tca = TI_TCA9548A(address = 0x70)
        self.tca.portSet(0)                     # Disable all iic ports
        self.mcp = Adafruit_MCP230XX(address = 0x20, num_gpios = 8)
        self.adc = ADS1x15(address=0x48,ic=0)

    def adc_getVector(self, port, channel, samples, fs=1600) :
        SPS = fs
        N = samples
        samples = list()
        self.tca.portSet(1 << port)
        samples.append(self.adc.startContinuousConversion(channel=channel,pga=6144,sps=SPS) )
        for n in range(1, N-1) :
            while True :
                sample = self.adc.getLastConversionResults()
                if (sample != samples[n-1] ) :
                    break
            samples.append(sample)
        self.adc.stopContinuousConversion()
        return samples 


    def current_read(self, port, channel):
        SPS = 490
        N = int(1.0/60.0 * 25.0 * SPS)
        samples = list()
        self.tca.portSet(1 << port)
        samples.append(self.adc.startContinuousConversion(channel=channel,pga=6144,sps=SPS) )
        for n in range(1, N-1) :
            while True :
                sample = self.adc.getLastConversionResults()
                if (sample != samples[n-1] ) :
                    break
            samples.append(sample)
            time.sleep(1 / (SPS*2))
        self.adc.stopContinuousConversion()
        offset = sum(samples) /  len(samples)
        #offset = max(samples) - (max(samples) - min(samples)) / 2 
        for n in range(0, N-1) :
            #samples[n] = (samples[n] - 2500) ** 2
            samples[n] = (samples[n] - offset)
        h = firwin(21,360.0/490.0)
        filtered = lfilter(h,1.0,samples)
        squares = list();
        for n in range(0, len(filtered)-1) :
            squares.append(filtered[n]**2)
        mean = sum(squares)/ len(squares)
        current = sqrt(mean)
        return current / 66 # 100mV per amp scale on sensor
    
    def power(self, port, channel) :
        rmsI = self.current_read(port, channel)
        power = 120 * rmsI 
        return power

    def soil_moist_read(self, port):
        self.tca.portSet(1 << port)
        return self.adc.readADCSingleEnded(channel=0)
    
    
    def temp_read(self, port):
        self.tca.portSet(1 << port)
        temp = read_temperature()
        return temp
    
    def hum_read(self, port):
        self.tca.portSet(1 << port)
        hum = read_humidity()
        return hum
    
        
    def relay_writeMaskProt(self, port,mask):
        self.tca.portSet(1 << port)
        self.mcp.write8(mask & 0x01)
        
    def relay_writeMask(self, port,mask):
        read = self.relay_readState(port) & 0x01
        self.tca.portSet(1 << port)
        self.mcp.write8(mask & 0xFE | read)
    
    def relay_initProt(self, port):
        self.tca.portSet(1 << port)
        self.mcp.config(0, self.mcp.OUTPUT)
        self.relay_writeMask(port,0x01)

    
    def relay_init(self, port):
        self.tca.portSet(1 << port)
        for pin in range(1,8):
             self.mcp.config(pin, self.mcp.OUTPUT)
        self.relay_writeMask(port,0xFE)

    def relay_readState(self, port):
        self.tca.portSet(1 << port)
        return self.mcp.readU8()


if __name__ == '__main__':
    rpi = hal() 
    temp = rpi.temp_read(3)                 # Temp and humidity sensor is on iic channel 3
    humidity = rpi.hum_read(3)              # Temp and humidity sensor is on iic channel 3
    rpi.relay_init(5)                       # Relay control is on iic channel 5
    relays = rpi.relay_readState(5)         # Relay control is on iic channel 5
    moisture = rpi.soil_moist_read(4)       # ADC is on iic channel 4
    current = rpi.current_read(4,0)
    power = rpi.power(4,0)
    print "Current Temp: %02.1f°C" % temp
    print "Current Humidity: %02.2f%%" %humidity
    print "Soil Moisture: %01.3f (sensor currently disconnected)" % moisture
    print "RMS Current on Relay 0: %02.1f (A)" %current

    print "Average power on Relay 0: %03d (W)" %power
    print "relay switch demo"
    for relay in range(0, 8):
        rpi.relay_writeMask(5,0x01 << relay)
        relays = rpi.relay_readState(5)         # Relay control is on iic channel 5
        time.sleep(0.2)
    rpi.relay_writeMask(5,0x55)
    relays = rpi.relay_readState(5)         # Relay control is on iic channel 5
    time.sleep(0.2)
    rpi.relay_writeMask(5,0xff)
    relays = rpi.relay_readState(5)         # Relay control is on iic channel 5

def current_read_func(port,channel):
    rpi = hal() 
    return rpi.current_read(port,channel)

def power_func(port, channel) :
    rpi = hal() 
    return rpi.power(port,channel)

def soil_moist_read_func(port):
    rpi = hal() 
    return rpi.soil_moist_read(port)

def temp_read_func(port):
    rpi = hal() 
    return rpi.temp_read(port)

def hum_read_func(port):
    rpi = hal() 
    return rpi.hum_read(port)

def relay_writeMask_func(port,mask):
    rpi = hal() 
    return rpi.relay_readState(port,mask)

def relay_init_func(port):
    rpi = hal() 
    return rpi.relay_readState(port)

def relay_readState_func(port):
    rpi = hal() 
    return rpi.relay_readState(port)

 
