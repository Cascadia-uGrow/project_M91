from numpy import std
from hal import hal

hw = hal()
samples = list()

for n in range(0,30) :
    samples.append(hw.power(4,0))
    relays = hw.relay_readState(5)
    if (hw.relay_readState(5) & 0x1) :
        print "Sample count: %d"%n
        break


maximum = max(samples)
minimum = min(samples)
stddev = std(samples)
mean = sum(samples)/len(samples)

print "max: %f"%maximum
print "min: %f"%minimum
print "std dev %f"%stddev
print "mean: %f"%mean
