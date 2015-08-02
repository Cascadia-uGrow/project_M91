%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_state
%% @doc HW State utility module.
%% display as "YYYY-MM-DD".

-module(hw_state).

-include_lib("stdlib/include/qlc.hrl").

-record(hw_state, {type, name, addr}).

-define(HW_CONFIG, "/home/indicasloth/.m91/config/hw.conf").
-define(DB_DIR, "/home/indicasloth/.m91/db/").
-define(DB_BACK, "/home/indicasloth/.m91/db/BACKUP").

-export([init/1, write/1, read/1, terminate/2, code_change/3]).

write(Record) ->
	try
		mnesia:activity(transaction, fun() -> mnesia:write(Record) end)
	catch
		exception:{aborted,{no_thing_exists, Tab}} -> throw({aborted, {no_thing_exists, Record}})
	end.

read(Key) ->
	try
		mnesia:activity(transaction, fun() -> mnesia:read({hw_state, Key}) end)
	catch 
		exception:{aborted, {no_thing_exists, hw_state}} -> throw({error, {no_table, Key}})
	end. 

restore() ->
	case mnesia:table_info(schema, size) of
	0 ->
		throw({aborted, no_schema});
	SchemaSize ->
		mnesia:start(),
		mnesia:restore(?DB_BACK, [])
	end. 
	
create() ->
	try	
		ok = mnesia:create_schema([node()]),
		ok = mnesia:start(),
		{atomic, ok} = mnesia:create_table(hw_state, [{type, bag}, {attributes, record_info(fields, hw_state)}]),
		{atomic, ok} = mnesia:add_table_index(hw_state, addr)	
	catch
		error:{badmatch, {Event, Reason}} -> throw({Event, {hw_state_create_failed, Reason}})
	end,
	try 
		{ok, Entries} = file:consult(?HW_CONFIG),
		populate(Entries)
	catch
		error:{badmatch, {error, _}} -> throw({error, "HW Config Missing"});
		throw:{aborted, {no_exist, Thing}} -> throw({error, "HW Config Error"})
	end,
	mnesia:backup(?DB_BACK).

populate([]) ->
	ok;

populate([Entry|Entries]) ->
	write(Entry),
	populate(Entries).

start(nuclear) ->
	mnesia:stop(),
	mnesia:delete_schema([node()]),
	start([]);

start([]) ->
	application:set_env(mnesia, dir, ?DB_DIR),
	try
		{ok, Tabs} = restore()
	catch
		throw:{aborted, no_schema} -> create();
		error:{badmatch, {error, Reason}} -> throw({error, {hw_state_start_failed, Reason}})
	end.	

init(Args) ->
	% Setup DB
	try
		{ok, State} = start(Args)
	catch
		throw:{error, {hw_state_start_fail, Reason}} -> throw({error, {hw_state_init_fail, Reason}}); 
		throw:{error, Reason} -> start(nuclear)
	end.
	
terminate(State, Reason) ->
	if not (State == error) ->
		mnesia:backup(?DB_BACK)
	end,
	mnesia:stop(),
	exit({State, Reason}).

code_change(OldVsn, State, Extra) ->
	State = mnesia:backup(?DB_BACK),
	mnesia:stop(),
	hw_state:init([]),
	{ok, State}.
