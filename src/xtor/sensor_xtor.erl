%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title Sensor Xtor Behaviour  
%% @doc defines the general behaviour of the sensor xtor modules
%% display as "YYYY-MM-DD".

-module(sensor_xtor).
-behaviour(gen_server).

-include("sensor.hrl").

%% Gen Server Export
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]). 

%% API Exports
-export([start_link/0]).


-callback start(State :: term()) ->
	{ok, State :: term()} |
	{ok, State :: term(), timeout()} |
	{stop, Reason :: term()} |
	ignore.

-callback stop(State :: term()) ->
	{ok, State :: term()} |
	{stop, Reason :: term()} |
	ignore.

-callback dev_read(State :: term()) ->
	{ok, Data :: term()} |
	{stop, Reason :: term()} |
	ignore.

-callback dev_write(State :: term()) ->
	{ok, Result :: term()} |
	{stop, Reason :: term()} |
	ignore.

%% API Functions
start_link() ->
	%init(#hw_state{network = 0, port = 0}),
	gen_server:start_link(?MODULE, [], []).


%% Gen Server Functions
init(State) ->
	State#hw_state{pyPID = python:start()},
	{ok, State}.

handle_call({read, Register}, {From, Tag}, State) ->
	{reply, hw_io:sensor_read(State, Register), State};
handle_call({write, Register, Data}, {From, Tag}, State) ->
	{reply, hw_io:sensor_write(State, Register, Data), State};
handle_call(Msg, _From, State) ->
	io:write(Msg),
	{noreply, State}.

handle_cast(Msg, State) ->
	io:write("MEOW MEOW MEOW"),
	{noreply,  State}.

handle_info(Info, State) ->
	{noreply, State}.

terminate(Reason, Pid) ->
	gen_server:stop(Pid).

code_change(OldVsn, State, Extra) ->
	{ok, alive}.
