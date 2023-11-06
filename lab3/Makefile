codigo.s: codigo.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax codigo.c -S -o codigo.s

codigo.o: codigo.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax codigo.s -c -o codigo.o

codigo.x: codigo.o
	ld.lld codigo.o -o codigo.x

teste: teste.c
	gcc teste.c

all: codigo.x
