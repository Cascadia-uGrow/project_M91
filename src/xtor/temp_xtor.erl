%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title temp xtor 
%% @doc hw xtor for temp sensor
%% display as "YYYY-MM-DD".


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
