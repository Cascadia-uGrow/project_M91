%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title Sensor Xtor Behaviour  
%% @doc defines the general behaviour of the sensor xtor modules
%% display as "YYYY-MM-DD".

-module(sensor_xtor).
%%-behaviour(gen_server).


%% Gen Server Export
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]). 

%% API Callback defines
-callback start(Args :: list(term())) -> 
	{ok, State :: term()} | 
	{ok, State :: term(), timeout()} |
	{stop, Reason :: term()} | 
	ignore.

-callback handle_control(Control :: timeout() | term(), State :: term()) ->
	{noreply, NewState :: term()} |
	{noreply, NewState :: term(), timeout() | hibernate} |
	{stop, Reason :: term(), NewState :: term()}.

-callback handle_io(Event :: term(), State :: term()) -> 
	{ok, NewState :: term()} |
	{stop, Reason :: term(), NewState :: term()}.

-callback terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()), State :: term()) -> 
	term().

%% Gen Server Defines
init(Args) ->
	{ok, alive}.

handle_call(Msg, {From, Tag}, State) ->
	{noreply, alive}.

handle_cast(Msg, State) ->
	{noreply, State}.

handle_info(Info, State) ->
	{noreply, alive}.

terminate(Reason, State) ->
	ok.

code_change(OldVsn, State, Extra) ->
	{ok, alive}.
