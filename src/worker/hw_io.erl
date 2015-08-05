%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_io 
%% @doc hw io callback wrapper
%% display as "YYYY-MM-DD".


-module(hw_io).

-export([hw_read/2, hw_write/3]).
-include("hw_io.hrl").

hw_read(State, Register) ->
	python:call(State#hw_state.pyPID, hw_io, read, [State#hw_state.network, State#hw_state.port, Register]).

hw_write(State, Register, Data) ->
	python:call(State#hw_state.pyPID, hw_io, write, [State#hw_state.network, State#hw_state.port, Register, Data]).
