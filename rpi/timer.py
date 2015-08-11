from hal import hal
#from subprocess import call
import time
from datetime import datetime

ON_TIME_HR = 5
ON_TIME_MIN = 00
OFF_TIME_HR = 23
OFF_TIME_MIN = 00

print "Starting timer app"
#call("pigpiod")
hw = hal()
hw.relay_initProt(5)

while True :
    now = datetime.now()
    on_time = now.replace(hour=ON_TIME_HR,minute=ON_TIME_MIN)
    off_time = now.replace(hour=OFF_TIME_HR,minute=OFF_TIME_MIN)
    if now <= on_time or now >= off_time :
        hw.relay_writeMaskProt(5,1)
    else : 
        hw.relay_writeMaskProt(5,0)
    time.sleep(60)
