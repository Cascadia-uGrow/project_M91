
-record(sensor, {name, pid, read_config, data}).

-record(hw_state, {pyPID, network, port}).

-record(temp_config, {i2c_addr = 0}). 
