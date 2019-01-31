all: sync-data costas sync-data-tx replay demod

sync-data: sync-data.c
	gcc -o sync-data sync-data.c

sync-data-tx: sync-data-tx.c
	gcc -o sync-data-tx sync-data-tx.c

costas: costas.c
	gcc -o costas costas.c -lm

replay: replay.c
	gcc -o replay replay.c

demod: demod.cc
	gcc -O3 -Wall -Werror -o demod demod.cc -lm -lstdc++

clear:
	rm sync-data costas
