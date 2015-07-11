-module(i2c).
-export([read/1, write/2, test/1]).
-on_load(init/0).

init() ->
	ok = erlang:load_nif("./priv/i2c_nif", 0).

read(_Addr) ->
	exit(nif_library_not_loaded).

write(_Addr, _Data) ->
	exit(nif_library_not_loaded).

test(_Data) -> 
	exit(nif_library_not_loaded).
