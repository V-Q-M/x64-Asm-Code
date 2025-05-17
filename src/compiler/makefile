all: compiler

compiler.o: compiler.asm
	nasm -f elf64 -o compiler.o compiler.asm

calc: compiler.o
	ld compiler.o -L../../lib -lstring -lmath -o calc

clean:
	rm -f compiler.o calc
