%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_server
%% @doc HW Server bridges the Env FSM to the hardware.
%% display as "YYYY-MM-DD".

-module(hw_server).
-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

init(Args) ->
	%% Connect to Sensor DB
	%% Connect to Relay Network
	%% Connect to Env FSM
	{ok, Args}.

handle_call(Request, From, State) ->
	{noreply, State}.

handle_cast(Request, State) ->
	{noreply, State}.

handle_info(Request, State) ->
	{noreply, State}.

terminate(Reason, State) ->
	exit(Reason).

code_change(OldVsn, State, Extra) ->
	{ok, State}.
