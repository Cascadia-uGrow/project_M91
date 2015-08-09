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

-export([init/1, start/0, start_link/0, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start() ->
	start_link().

start_link() ->
	gen_server:start_link({global,hw_server}, hw_server, [], []).

init(_Args) ->
	% Setup DB
	try
		Tab = hw_state:init([]),
		PyPid = hw_io:init(),
		State = #hw_state{tab = Tab, pyPid = PyPid},
		{ok, State}
	catch
		throw:{error, {hw_state_init_failed, Reason}} -> exit({error, {hw_state_init_failed, Reason}})
	end.

average(Data) ->
	42.

update_avg(List, PyPid) ->
	update_avg(List, [], PyPid).

update_avg([Cur | List], Data, PyPid) ->
	New = hw_io:temp_read(PyPid, Cur#hw_entry.port),
	update_avg(List, [Data | New], PyPid);
update_avg([], Data, PyPid) ->
	average(Data).

handle_call(read_temp, From, State) ->
	% check ets for current state
	try
		
		% get a list of temp sensors
		{ok, Temps} = hw_state:read(temp),
		Temp = update_avg(Temps, State#hw_state.pyPid),
		%Temp = 0,
		gen_event:notify(env_man, {temp_update, Temp})
	catch 
		throw:{error, {no_table, Key}} -> exit(error, no_table)
	end;
	%{reply, State};
	
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
