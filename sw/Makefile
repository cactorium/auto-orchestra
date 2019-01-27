all: sync-data costas sync-data-tx

sync-data: sync-data.c
	gcc -o sync-data sync-data.c

sync-data-tx: sync-data-tx.c
	gcc -o sync-data-tx sync-data-tx.c

costas: costas.c
	gcc -o costas costas.c -lm

clear:
	rm sync-data costas
