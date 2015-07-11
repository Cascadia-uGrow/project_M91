#include "erl_nif.h"
#include "i2c_io.h"

int test(x) {
	return i2c_read(x);
}


static ERL_NIF_TERM test_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
	int x, ret;
	if (!enif_get_int(env, argv[0], &x)) {
		return enif_make_badarg(env);;
	}
	ret = test(x);
	return enif_make_int(env, ret);
}

static ERL_NIF_TERM read_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int Addr, result;
    if (!enif_get_int(env, argv[0], &Addr)) {
		return enif_make_badarg(env);
    }
    result = i2c_read(Addr);
    return enif_make_int(env, result);
}

static ERL_NIF_TERM write_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int Addr, Data, result;
    if (!enif_get_int(env, argv[0], &Addr)) {
		return enif_make_badarg(env);
    }
    if (!enif_get_int(env, argv[1], &Data)) {
		return enif_make_badarg(env);
    }
    result = i2c_write(Addr, Data);
    return enif_make_int(env, result);
}

static ErlNifFunc nif_funcs[] = {
    {"read", 1, read_nif},
    {"write", 2, write_nif},
	 {"test", 1, test_nif}
};

ERL_NIF_INIT(i2c, nif_funcs, NULL, NULL, NULL, NULL)

