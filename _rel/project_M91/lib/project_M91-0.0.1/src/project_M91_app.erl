-module(project_M91_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    project_M91_sup:start_link().

stop(_State) ->
    ok.
