%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title env_timer 
%% @doc timer management worker
%% display as "YYYY-MM-DD".
-module(env_timer).
-export([start_link/0, stop/0]).

-define(ENV_CONF, "/home/indicasloth/.m91/conf/env.conf").

start_link() ->
	EnvState = file:consult(?ENV_CONF),
	timer:start(),
	% setup temp update timer
	setup(temp, EnvState),
	% setup water cycle timer
	setup(light, EnvState),
	% setup light cycle timer
	setup(water, EnvState),
	{ok, self()}.

stop() ->
	timer:stop(),
	ok.

setup(temp, EnvState) ->
	ok;
setup(light, EnvState) ->
	ok;
setup(water, EnvState) ->
	ok.

