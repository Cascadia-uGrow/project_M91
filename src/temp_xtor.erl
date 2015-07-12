-module(temp_xtor).
-behaviour(sensor_xtor).

-export([start/1, stop/1,  read/1]).

-include("sensor.hrl").

start(State) ->
	State#hw_state{pyPID = python:start()},
	sensor_xtor:start_link().
	%sensor_xtor:init(State).

stop(State) ->
	python:stop(State#hw_state.pyPID),
	{ok, State}.

read(State) ->
	State#sensor.data.
