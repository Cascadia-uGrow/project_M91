%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_server
%% @doc HW Server bridges the Env FSM to the hardware.
%% display as "YYYY-MM-DD".

-module(hw_server).
-behaviour(gen_server).

-include_lib("stdlib/include/qlc.hrl").

-record(env_state, {temp, hum}).

-export([init/1, start/0, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start() ->
	spawn_link(?MODULE, init, []).

init(Args) ->
	% Setup DB
	try
		hw_state:init([])
	catch
		throw:{error, {hw_state_init_failed, Reason}} -> exit({error, {hw_state_init_failed, Reason}})
	end,
	ok.

handle_call(read_temp, From, State) ->
	% check ets for current state
	try
		{ok, Temp} = hw_state:read(temp_avg),
		State#env_state{temp = Temp},
		From ! {ok, State}
	catch 
		throw:{error, {no_table, Key}} -> exit(error, no_table)
	end;
	
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
