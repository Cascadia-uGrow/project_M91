import os 
#os.system("sudo pigpiod")
from hal import hal
import time
from datetime import datetime
import logging

try :
    os.remove('timer.log')
except IndexError, e:
    print str(e)
except TypeError, e:
    print str(e)
except Exception, e: 
    print str(e)



logging.basicConfig(filename='timer.log', level=logging.DEBUG, format='%(levelname)s: %(asctime)s\t%(message)s')

ON_TIME_HR = 5
ON_TIME_MIN = 00
OFF_TIME_HR = 23
OFF_TIME_MIN = 00
WARN_HUM = 72
WARN_TEMP = 28
ALARM_HUM = 80
ALARM_TEMP = 33
VENT_ON_DC = 0.0625
VENT_DC_PERIOD = 4.0
SLEEP_INTERVAL = 10.0

print "Starting timer app"
hw = hal()
vent_dc_counter = 0
while True:
    try :
        hw.relay_initProt(5)
    except Exception:
        next
    break
    
while True:
    try :
        hw.relay_init(5)
    except Exception:
        next
    break
    
time.sleep(0.5)
time.sleep(0.5)
relays = 0
temp = 0
hum = 0

while True :
    try:
        try:
            logging.debug("Reading environment sensors")
            temp = hw.temp_read(7)
            #time.sleep(0.5)
            hum = hw.hum_read(7)
            #time.sleep(0.5)
            relays = hw.relay_readState(5) 
        except IndexError, e:
            print str(e)
            next
        except TypeError, e:
            print str(e)
            next
        except Exception, e: 
            print str(e)
            next
        now = datetime.now()
        if relays & 0x06 == 0x00 :
            vent_on = True
        else :
            vent_on = False
        if relays & 0x01 == 0x00 :
            lamp_on = True
        else: 
            lamp_on = False
        logging.info("%02.2f\t%02.2f\t%d\t%d", temp, hum, vent_on, lamp_on) 
        on_time = now.replace(hour=ON_TIME_HR,minute=ON_TIME_MIN)
        off_time = now.replace(hour=OFF_TIME_HR,minute=OFF_TIME_MIN)
        if now <= on_time or now >= off_time :
            if lamp_on:
                logging.info("Turning off lights for dark period")
            while True:
                try:    
                    hw.relay_off(5,1)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        elif temp >= ALARM_TEMP or hum >= ALARM_HUM :
            if lamp_on:
                logging.info("Turning off lights for over temp/hum reading")
            while True:
                try:
                    hw.relay_off(5,1)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        else : 
            if lamp_on == False:
                logging.info("Turning on lights for light period")
            while True:
                try:
                    hw.relay_on(5,1)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        
        if temp > WARN_TEMP :
            if not vent_on:
                logging.debug("Turning on ventilation because temperature is above warning threshold")
            while True:
                try:
                    hw.relay_on(5,6)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        elif hum > WARN_HUM :
            if not vent_on :
                logging.debug("Turning on ventilation because humidity is above warning threshold")
            while True:
                try:
                    hw.relay_on(5,6)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        elif vent_dc_counter < VENT_ON_DC * VENT_DC_PERIOD :
            if not vent_on:
                logging.debug("Turning on ventilation for on period")
            while True:
                try:
                    hw.relay_on(5,6)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        else :
            if vent_on:
                logging.debug("Turning off ventilation for off period")
            while True:
                try:
                    hw.relay_off(5,6)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
    
        vent_dc_counter += SLEEP_INTERVAL / 60 
        if vent_dc_counter >= VENT_DC_PERIOD :
            vent_dc_counter = 0
    
        time.sleep(SLEEP_INTERVAL)
    except Exception, e :
        print e

