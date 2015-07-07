-module(project_M91_sup).

-behaviour(supervisor).

-export([
         init/1,
         start_link/0
        ]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
   SupFlags = {one_for_one, 2, 1},
	ChildSpec =  [
					{hw_sup, {hw_sup, start_link, []}, permanent, infinity, supervisor, [hw_sup]},
					{act_sup, {act_sup, start_link, []}, permanent, infinity, supervisor, [act_sup]},
					{sense_sup, {sense_sup, start_link, []}, permanent, infinity, supervisor, [sense_sup]},
					{env_sup, {env_sup, start_link, []}, permanent, infinity, supervisor, [env_sup]}				
				 ],
    {ok, {SupFlags, ChildSpec}}.
