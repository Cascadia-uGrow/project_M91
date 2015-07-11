%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title hw_sup 
%% @doc Hardware Supervisor for running relay and sensor workers.
%% display as "YYYY-MM-DD".

-module(hw_sup).
-behaviour(supervisor).

-export([init/1, start_link/0]).

start_link() ->
	supervisor:start_link(hw_sup, []).

init(_Args) ->
	SupFlags = {one_for_one, 2, 1},
	ChildSpecs = [],
	{ok, {SupFlags, ChildSpecs}}.

