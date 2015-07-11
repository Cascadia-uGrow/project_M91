%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title env_fsm
%% @doc Env FSM takes inputs from sensors and outputs relay control. Depends on the hw_server for i/o.
%% display as "YYYY-MM-DD".

-module(env_fsm).
-behaviour(gen_fsm).

-export([init/1, terminate/3, handle_event/3, handle_sync_event/4, handle_info/3, code_change/4]).

init(Args) ->
	{ok, init, Args}.

handle_event(Event, StateName, StateData) ->
	{next_state, StateName, StateData}.

handle_sync_event(Event, From, StateName, StateData) ->
	{next_state, StateName, StateData}.

handle_info(Info, StateName, StateData) ->
	{next_state, StateName, StateData}.

terminate(Reason, StateName, StateData) ->
	exit(Reason).

code_change(OldVsn, StateName, StateData, Extra) ->
	{ok, StateName, StateData}.

