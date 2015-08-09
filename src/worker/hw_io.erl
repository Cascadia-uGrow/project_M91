%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_io 
%% @doc hw io callback wrapper
%% display as "YYYY-MM-DD".


-module(hw_io).

-export([init/0, terminate/1, temp_read/2] ).
-include("hw.hrl").

init() ->
	{ok, PyPid} = python:start([{python_path, "/home/ugrow/project_M91/rpi"}]),
	PyPid.

terminate(PyPid) ->
	python:stop(PyPid).

temp_read(PyPid, Port) ->
	python:call(PyPid, hal, temp_read_func, [Port]).

