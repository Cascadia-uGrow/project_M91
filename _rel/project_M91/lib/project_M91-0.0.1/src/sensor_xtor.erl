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

-callback read(State :: term()) ->
	{ok, Data :: term()} |
	{stop, Reason :: term()} |
	ignore.

%% API Functions
start_link() ->
	gen_server:start_link(?MODULE, [], []).

%% Gen Server Functions
init(Args) ->
	{ok, Args}.

handle_call(Msg, {From, Tag}, State) ->
	{noreply, State}.

handle_cast(Msg, State) ->
	{noreply, State}.

handle_info(Info, State) ->
	{noreply, State}.

terminate(Reason, Pid) ->
	gen_server:stop(Pid).

code_change(OldVsn, State, Extra) ->
	{ok, alive}.
