-module(temp_xtor_tests).
-include_lib("eunit/include/eunit.hrl").
-include("sensor.hrl").



%%%%%%%%%%%%%%%%%%%%%%%
%% TEST DESCRIPTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%

init_test_() ->
	{"Testing bringing a sensor online and offline",
	{setup,
		fun start/0,
		fun stop/1,
		fun read/1}}.

%%%%%%%%%%%%%%%%%%%%%
%% SETUP FUNCTIONS %%
%%%%%%%%%%%%%%%%%%%%%

start() -> 
	State = #sensor{},
	{ok, Pid} = temp_xtor:start(State),
	State#sensor{pid = Pid, data = 1}. 

stop(_) ->
	temp_xtor:stop({}).	

read(State) ->
	[?_assert(temp_xtor:read(State) > 0)].

