all: compiler

compiler.o: compiler.asm
	nasm -f elf64 -o compiler.o compiler.asm

compiler: compiler.o
	ld compiler.o -L../../lib -lstring -lmath -o compiler

clean:
	rm -f compiler.o compiler
