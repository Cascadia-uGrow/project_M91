#!/usr/bin/python
# -*- coding: utf-8 -*-
import random
def current_read_func(port,channel):
    random.seed()
     
    return random.uniform(0, 3)

def power_func(port, channel) :
    random.seed()
     
    return random.uniform(0, 5)

def soil_moist_read_func(port):
    random.seed()
     
    return random.random()

def temp_read_func(port):
    random.seed()
     
    return random.uniform(20, 30)

def hum_read_func(port):
    random.seed()
     
    return random.uniform(50, 90)

def relay_writeMask_func(port,mask):
    random.seed()
     
    return random.getrandbits(8)

def relay_init_func(port):
    random.seed()
     
    return random.getrandbits(8)

def relay_readState_func(port):
    random.seed()
     
    return random.getrandbits(8)

 
