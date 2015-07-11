
-record(sensor, {name, pid, read_config, data}).

-record(temp_config, {i2c_addr = 0}). 
