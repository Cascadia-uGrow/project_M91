-module(i2c).
-export([read/1, write/2, test/1]).
-on_load(init/0).

-define(APPNAME, i2c_nif).
-define(LIBNAME, i2c_nif).

init() ->
	SoName = case code:priv_dir(?APPNAME) of
		{error, bad_name} ->
			case filelib:is_dir(filename:join(["..", priv])) of
				true ->
					filename:join(["..", priv, ?LIBNAME]);
				_ ->
					filename:join([priv, ?LIBNAME])
			end;
		Dir ->
			filename:join(Dir, ?LIBNAME)
	end,
	erlang:load_nif(SoName, 0).

read(_Addr) ->
	exit(nif_library_not_loaded).

write(_Addr, _Data) ->
	exit(nif_library_not_loaded).

test(_Data) -> 
	exit(nif_library_not_loaded).
