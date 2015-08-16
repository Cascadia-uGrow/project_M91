%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_state
%% @doc HW State utility module.
%% display as "YYYY-MM-DD".

-module(hw_state).

-include_lib("stdlib/include/qlc.hrl").
-include("hw.hrl").


-export([init/1, write_db/1, read_db/1, read_hw/2, terminate/2, code_change/3]).

read_hw(Recs, PyPid) ->
	read_hw(Recs, [], PyPid).
read_hw([Rec | Recs], Values, PyPid) ->
	NewValues = Values ++ hw_io:read(PyPid, Rec#hw_entry.type, Rec#hw_entry.addr),
	read_hw(Recs, NewValues, PyPid); 
read_hw([], Values, PyPid) ->
	Values.

write_db(Record) ->
	try
		mnesia:activity(transaction, fun() -> mnesia:write(Record) end)
	catch
		exception:{aborted,{no_thing_exists, Tab}} -> throw({aborted, {no_thing_exists, Record}})
	end.

read_db(Key) ->
	try
		mnesia:activity(transaction, fun() -> mnesia:read({hw_entry, Key}) end)
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
		{atomic, ok} = mnesia:create_table(hw_entry, [{type, bag}, {attributes, record_info(fields, hw_entry)}]),
		{atomic, ok} = mnesia:add_table_index(hw_entry, name)	
	catch
		error:{badmatch, {Event, Reason}} -> throw({Event, {hw_state_create_failed, Reason}})
	end,
	try 
		{ok, Entries} = file:consult(?HW_CONFIG),
		populate(Entries),
		mnesia:backup(?DB_BACK),
		{ok, Entries}
	catch
		error:{badmatch, {error, _}} -> throw({error, "HW Config Missing"});
		throw:{aborted, {no_exist, Thing}} -> throw({error, "HW Config Error"})
	end.

populate([]) ->
	ok;

populate([Entry|Entries]) ->
	write_db(Entry),
	populate(Entries).

start(nuclear) ->
	mnesia:stop(),
	mnesia:delete_schema([node()]),
	start([]);

start([]) ->
	application:set_env(mnesia, dir, ?DB_DIR),
	try
		{atomic, Tab} = restore(),
		{ok, Tab}
	catch
		throw:{aborted, no_schema} -> create();
		error:{badmatch, {error, Reason}} -> throw({error, {hw_state_start_failed, Reason}});
		error:{badmatch, {aborted, Reason}} -> throw({aborted, {hw_state_restore_failed, Reason}})
	end.	

init(Args) ->
	% Setup DB
	try
		{ok, Tab} = start(Args),
		{ok, Tab}
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
