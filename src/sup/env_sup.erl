%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title env_sup 
%% @doc Environment Supervisor Runs automation workers.
%% display as "YYYY-MM-DD".

-module(env_sup).
-behaviour(supervisor).

-export([init/1, start_link/0]).

start_link() ->
	supervisor:start_link(env_sup, []).

init(_Args) ->
	SupFlags = {one_for_one, 2, 1},
	ChildSpecs = [
						{env_event, {env_event, start_link, []}, permanent, 5000, worker, [env_event]},
						{env_timer, {env_timer, start_link, []}, permanent, 5000, worker, [env_timer]}
					 ],
	{ok, {SupFlags, ChildSpecs}}.

