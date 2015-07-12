-module(hw_io).

-export([i2c_read/2, i2c_write/3]).
-include("hw_io.hrl").

i2c_read(State, Register) ->
	python:call(State#hw_state.pyPID, hw_io, i2c_read, [State#hw_state.network, State#hw_state.port, Register]).

i2c_write(State, Register, Data) ->
	python:call(State#hw_state.pyPID, hw_io, i2c_write, [State#hw_state.network, State#hw_state.port, Register, Data]).
