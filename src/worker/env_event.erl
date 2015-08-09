%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title env_fsm
%% @doc Env FSM takes inputs from sensors and outputs relay control. Depends on the hw_server for i/o.
%% display as "YYYY-MM-DD".

-module(env_event).
-behaviour(gen_event).

-include("hw.hrl").

-record(room, {night=1, day=0, cooling=0, watering=0, co2=0}).
-record(env, {type, temp_range, hum_range, water_range, light_cycle}).
-record(state, {room = #room{}, env = #env{}}).

-export([init/1, start_link/0, terminate/3, handle_event/2, handle_call/2, handle_info/2, code_change/4]).


ac_cycle(Temp, State) ->
	TempState = {Temp < lists:min((State#state.env)#env.temp_range), Temp > lists:max((State#state.env)#env.temp_range)},
	case {(State#state.room)#room.cooling, TempState} of 
		{true, {true, _}} ->
			% turn off ac	
			State#state{room = #room{cooling = false}};
		{false, {_, true}} ->
			% Turn on ac
			State#state{room = #room{cooling = true}};
		_ ->
			State
	end.
		

light_cycle(_Light, State) ->
	if 
		(State#state.room)#room.day ->
			% turn off lights 
			% start night timer
			State#state{room = #room{day = false, night = true}};
		(State#state.room)#room.night ->
			% Turn on lights
			% start day timer
			State#state{room = #room{day = true, night = false}}
	end,
	State.
	

start_link() -> 
	gen_event:start_link({local, env_man}),
	gen_event:add_handler(env_man, env_event, []).

init(_Args) ->
	Env = file:consult(?ENV_CONFIG),
	{ok, #state{env = Env}}.

handle_event({temp_update, Temp}, State) ->
	{ok, ac_cycle(Temp, State)};

handle_event({light_update, Light}, State) ->
	{ok, light_cycle(Light, State)};

handle_event(_Event, State) ->
	{ok, State}.

handle_call(_Event, State) ->
	{ok, ok, State}.

handle_info(_Info, State) ->
	{ok, State}.

terminate(Reason, StateName, StateData) ->
	ok.

code_change(OldVsn, StateName, StateData, Extra) ->
	{ok, StateData}.

