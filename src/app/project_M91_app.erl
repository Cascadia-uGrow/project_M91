%% @author Camille Day <camille@cascadiamicrogrow.com>
%% 	[http://www.cascadiamicrogrow.com]
%% @copyright 2015 Camille Day 
%% @version x.x.x
%% @title project_M91 app 
%% @doc primary app to launch M91 primary supervisor
%% display as "YYYY-MM-DD".


-module(project_M91_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    project_M91_sup:start_link().

stop(_State) ->
    ok.
