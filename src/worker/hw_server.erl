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

%-record(hwServerSate{hName, sName, sensCon, relayCon, fsmCon}). 
-record(hw_state, {type, name, addr}).

-define(HW_CONFIG, "/home/indicasloth/m91_test/config/hw.conf").
-define(DB_DIR, "/home/indicasloth/m91_test/db/").
-define(DB_BACK, "/home/indicasloth/m91_test/db/backup").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

hw_state_write(State) ->
	try
		mnesia:activity(transaction, fun() -> mnesia:write(State) end)
	catch
		exception:{aborted,{no_thing_exists, Tab}} -> throw({aborted, {no_thing_exists, Tab}})
	end.

recover_hw_state() ->
	case mnesia:table_info(schema, size) of
	0 ->
		throw({aborted, no_schema});
	SchemaSize ->
		mnesia:start(),
		mnesia:restore(?DB_BACK)
	end. 
	
init_hw_state() ->
	try	
		ok = mnesia:create_schema([node()]),
		ok = mnesia:start(),
		{atomic, ok} = mnesia:create_table(hw_state, [{type, bag}, {attributes, record_info(fields, hw_state)}])	
	catch
		error:{badmatch, {Event, Reason}} -> throw({Event, {hw_state_init_failed, Reason}})
	end,
	try 
		{ok, Tabs} = file:consult(?HW_CONFIG),
		fill_empty_tabs(Tabs)
	catch
		error:{badmatch, {error, _}} -> throw({error, "HW Config Missing"})
	end,
	{ok, Tabs2} = file:consult(?HW_CONFIG),
	fill_empty_tabs(Tabs2),
	mnesia:backup(?DB_BACK).

fill_empty_tabs([]) ->
	ok;

fill_empty_tabs([Tab|Tabs]) ->
	hw_state_write(Tab),
	fill_empty_tabs(Tabs).

start_db(nuclear) ->
	mnesia:stop(),
	mnesia:delete_schema([node()]),
	start_db().

start_db() ->
	application:set_env(mnesia, dir, ?DB_DIR),
	try
		{ok, Tabs} = recover_hw_state()
	catch
		throw:{aborted, no_schema} -> init_hw_state();
		error:{badmatch, {error, Reason}} -> throw({error, db_failed})
	end.	

init(Args) ->
	% Setup DB
	try
		start_db()
	catch
		throw:{error, db_failed} -> exit(db_failed); 
		throw:{error, Reason} -> start_db(nuclear)
	end,
	
	% Read HW config file 
	{ok, Terms} = file:consult(?HW_CONFIG),

	
	%% Connect to Sensor DB
		% sensors = connectSensors(hName)
	%% Connect to Relay Network
		% relays = connectRelays(hName)
	%% Connect to Env Sup
		% fsm = connectFSM(sName)
	{ok, Args}.

handle_call(read_temp, From, State) ->
	% check ets for current state
	[HW] = mnesia:read(hw_state, temp_avg, read);
	
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
