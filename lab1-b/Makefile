start.s: start.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax start.c -S -o start.s

start.o: start.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax start.s -c -o start.o

calculadora.s: calculadora.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax calculadora.c -S -o calculadora.s

calculadora.o: calculadora.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax calculadora.s -c -o calculadora.o

calculadora.x:  calculadora.o start.o
	ld.lld calculadora.o start.o -o calculadora.x

all: calculadora.x
