%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title sense_sup 
%% @doc Sensor supervisor manages sensor based workers
%% display as "YYYY-MM-DD".

-module(sense_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
	SupFlags = {one_for_one, 2, 1},
	{ok, {SupFlags, []}}.



