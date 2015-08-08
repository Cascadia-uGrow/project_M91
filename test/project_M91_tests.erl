-module(project_M91_tests).

-include_lib("eunit/include/eunit.hrl").

project_M91_test_() ->
    {setup,
     fun() ->
             ok
     end,
     fun(_) ->
             ok
     end,
     [
      {"project_M91 is alive",
       fun() ->
               %% format is always: expected, actual
               ?assertEqual(howdy, project_M91:hello())
       end}
      ]}.

