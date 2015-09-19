#!/usr/bin/python
import pigpio
import os 
import logging
import time
from hal import hal
from datetime import datetime
import json


try :
    os.remove('timer.log')
except IndexError, e:
    print str(e)
except TypeError, e:
    print str(e)
except Exception, e: 
    print str(e)



logging.basicConfig(filename='timer.log',filemode='a', level=logging.DEBUG, format='%(levelname)s: %(asctime)s\t%(message)s')

ON_TIME_HR = 5
ON_TIME_MIN = 00
OFF_TIME_HR = 23
OFF_TIME_MIN = 00
WARN_HUM = 70.0
WARN_TEMP = 28.0
ALARM_HUM = 80.0
ALARM_TEMP = 33.0
VENT_ON_DC = 0.5
VENT_DC_PERIOD = 1.0
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
last_temp = -1
last_hum = -1
handle = 0

output_data = []

while True :
    try:
        try:
            logging.debug("Reading environment sensors")
            temp = hw.temp_read(7)
            time.sleep(0.5)
            hum = hw.hum_read(7)
            time.sleep(0.5)
            relays = hw.relay_readState(5) 
            moist0 = hw.soil_moist_read(2,0)
            moist1 = hw.soil_moist_read(2,1)
            moist2 = hw.soil_moist_read(2,2)
            moist3 = hw.soil_moist_read(2,3)

            # JSON Logging
            output_data = []
            output_data.append({ "addr" : (7, 0), "data" : temp })
            output_data.append({ "addr" : (7, 1), "data" : hum })
            output_data.append({ "addr" : (2, 0), "data" : moist0 })
            output_data.append({ "addr" : (2, 1), "data" : moist1 })
            output_data.append({ "addr" : (2, 2), "data" : moist2 })
            output_data.append({ "addr" : (2, 3), "data" : moist3 })
            output_data.append({ "addr" : (5, 0), "data" : 1 if (relays & (1 << 0)) == 0 else 0})
            output_data.append({ "addr" : (5, 1), "data" : 1 if (relays & (1 << 1)) == 0 else 0})
            output_data.append({ "addr" : (5, 2), "data" : 1 if (relays & (1 << 2)) == 0 else 0})
            output_data.append({ "addr" : (5, 3), "data" : 1 if (relays & (1 << 3)) == 0 else 0})
            output_data.append({ "addr" : (5, 4), "data" : 1 if (relays & (1 << 4)) == 0 else 0})
            output_data.append({ "addr" : (5, 5), "data" : 1 if (relays & (1 << 5)) == 0 else 0})
            output_data.append({ "addr" : (5, 6), "data" : 1 if (relays & (1 << 6)) == 0 else 0})
            output_data.append({ "addr" : (5, 7), "data" : 1 if (relays & (1 << 7)) == 0 else 0})

            jsonfile = open('/home/ugrow/val_logs/sensors.json', 'w')
            jsonfile.write(json.dumps(output_data, indent=4, sort_keys=True))
            jsonfile.close()
            # END JSON Logging


        except IndexError, e:
            print str(e)
            next
        except TypeError, e:
            print str(e)
            next
        except Exception, e: 
            print str(e)
            next
        handle = os.system("sudo pigs i2co 1 0x70 0")
        if handle < 0 :
            logging.debug("pigpiod has crashed, closing all open i2c handles")
            for i in range(0, 31) :
                command = "sudo pigs i2cc %d" % i
                os.system(command)
            next
        else :
            command = "sudo pigs i2cc %d" % handle
            os.system(command)
        
        last_temp = temp
        last_hum = hum

        now = datetime.now()
        if relays & 0x06 == 0x00 :
            vent_on = True
        else :
            vent_on = False
        if relays & 0x01 == 0x00 :
            lamp_on = True
        else: 
            lamp_on = False
        logging.info("%02.2f\t%02.2f\t%d\t%d\t%04d\t%04d\t%04d\t%04d", temp, hum, vent_on, lamp_on,moist0,moist1,moist2,moist3) 
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
                    hw.relay_on(5,4)
                    time.sleep(0.5)
                    hw.relay_on(5,2)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        elif hum > WARN_HUM :
            if not vent_on :
                logging.debug("Turning on ventilation because humidity is above warning threshold")
            while True:
                try:
                    hw.relay_on(5,4)
                    time.sleep(0.5)
                    hw.relay_on(5,2)
                except Exception, e:
                    logging.debug("%s", e)
                    next
                break
        elif vent_dc_counter < VENT_ON_DC * VENT_DC_PERIOD :
            if not vent_on:
                logging.debug("Turning on ventilation for on period")
            while True:
                try:
                    hw.relay_on(5,4)
                    time.sleep(0.5)
                    hw.relay_on(5,2)
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
logging.critical("Execution out of loop!")
os.system("sudo reboot")
