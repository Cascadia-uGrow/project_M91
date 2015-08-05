
-record(sensor, {name, pid, hw_state, data}).

-record(hw_state, {pyPID, network, port}).

-record(temp_config, {i2c_addr = 0}). 
