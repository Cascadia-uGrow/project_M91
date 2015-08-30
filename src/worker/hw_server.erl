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
-include("hw.hrl").

-export([init/1, start_link/0, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
	gen_server:start_link({global,hw_server}, hw_server, [], []).

init(_Args) ->
	% Setup DB
	try
		{ok, Tab} = hw_state:init([]),
		PyPid = hw_io:init(),
		State = #hw_state{tab = Tab, pyPid = PyPid},
		{ok, State}
	catch
		throw:{error, {hw_state_init_failed, Reason}} -> exit({error, {hw_state_init_failed, Reason}})
	end.

debug_print(Mod, Msg) ->
	io:write(Mod + Msg).

average(X) -> 
	X,
	average(X, 0, 0).
average(X, 0, 0) ->
	X;
average([H|T], Length, Sum) -> average(T, Length + 1, Sum + H);
average([], Length, Sum) -> 
	Sum,
	Length,
	Sum / Length.

	
handle_call(Request, From, State) ->
	{noreply, State}.

handle_cast(read_hum, State) ->
	try
		% get a list of hum sensors
		[HumRecs] = hw_state:read_db(hum),
		HumValues = hw_state:read_hw([HumRecs], State#hw_state.pyPid),
		Hum = average(HumValues),
		gen_event:notify(env_man, {hum_update, Hum}),
		{noreply, State}
	catch 
		throw:{error, {no_table, Key}} -> exit(error, no_table)
	end;

handle_cast(read_temp, State) ->
	try
		% get a list of temp sensors
		[TempRecs] = hw_state:read_db(temp),
		TempValues = hw_state:read_hw([TempRecs], State#hw_state.pyPid),
		Temp = average(TempValues),
		gen_event:notify(env_man, {temp_update, Temp})
	catch 
		throw:{error, Reason} -> exit(error, Reason);
		throw:{error, {no_table, Key}} -> exit(error, no_table)
	end,
	{noreply, State};

handle_cast(Request, State) ->
	debug_print(?MODULE, "cast received"),
	{noreply, State}.

handle_info(Request, State) ->
	{noreply, State}.

terminate(Reason, State) ->
	exit(Reason).

code_change(OldVsn, State, Extra) ->
	{ok, State}.
