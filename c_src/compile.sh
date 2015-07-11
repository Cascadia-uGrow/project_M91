#gcc -o cserver -I /usr/local/lib/erlang/lib/erl_interface-3.7.20/include -L /usr/local/lib/erlang/lib/erl_interface-3.7.20/lib i2c.c cnode_i2c.c -lerl_interface -lei  -lpthread -lnsl -g -O0 
gcc -o i2c_nif.so -I /usr/local/lib/erlang/usr/include -fpic -shared i2c_nif.c i2c_io.c -lm 
