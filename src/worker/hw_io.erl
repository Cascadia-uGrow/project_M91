%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_io 
%% @doc hw io callback wrapper
%% display as "YYYY-MM-DD".


-module(hw_io).

-export([init/0, terminate/1, read/3, write/4] ).
-include("hw.hrl").

init() ->
	{ok, PyPid} = python:start([{python_path, "/home/indicasloth/project_M91/rpi"}]),
	PyPid.

terminate(PyPid) ->
	python:stop(PyPid).

read(PyPid, temp, {Port, Chan}) ->
	python:call(PyPid, debug_hal, temp_read_func, [Port]);

read(PyPid, hum, {Port, Chan}) ->
	python:call(PyPid, hal, hum_read_func, [Port]);

read(PyPid, soil, {Port, Chan}) ->
	python:call(PyPid, hal, soil_moist_read_func, [Port]);

read(PyPid, curr, {Port, Chan}) ->
	python:call(PyPid, hal, current_read_func, [Port, Chan]);

read(PyPid, power, {Port, Chan}) ->
	python:call(PyPid, hal, power_func, [Port, Chan]);

read(PyPid, relay, {Port, Chan}) ->
	python:call(PyPid, hal, relay_readState_func, [Port]).

write(PyPid, relay, Action, {Port, Chan}) ->
	Mask = 1 bsl Chan,
	State = python:call(PyPid, hal, relay_readState_func, [Port]),
	case Action of
		on ->
			NewState = State bor Mask;
		off ->
			NewState = State xor Mask
	end,
	python:call(PyPid, hal, relay_writeMask_func, [Port, NewState]).



