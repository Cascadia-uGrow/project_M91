-module(hw_io).

-export([sensor_read/2, i2c_write/3]).
-include("hw_io.hrl").

sensor_read(State, Register) ->
	%Volt = python:call(State#hw_state.pyPID, ads1x15_ex_singleended, read_volts, [State#hw_state.network, State#hw_state.port, Register]),
	Volt = python:call(State#hw_state.pyPID, ads1x15_ex_singleended, read_volts, []),
	Volt/1000.

i2c_write(State, Register, Data) ->
	python:call(State#hw_state.pyPID, hw_io, i2c_write, [State#hw_state.network, State#hw_state.port, Register, Data]).
