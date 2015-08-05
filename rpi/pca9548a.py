#!/usr/bin/python
from Adafruit_I2C import Adafruit_I2C
import smbus
import time

class TI_TCA9548A(object):
	ENABLE 	= 1
	DISABLE	= 0

	def __init__(self, address, busnum=-1):
		
		self.i2c = Adafruit_I2C(address=address, busnum=busnum)
		self.address = address

	def portSet(self, port_mask):
		self.i2c.writeRaw8(port_mask)

if __name__ == '__main__':
	tca = TI_TCA9548A(address = 0x70)
	tca.portSet(0xFF)
