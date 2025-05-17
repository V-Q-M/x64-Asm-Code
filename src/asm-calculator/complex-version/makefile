# Makefile for main.asm + libstring.a

all: calc

extended_calculator.o: extended_calculator.asm
	nasm -f elf64 -o extended_calculator.o extended_calculator.asm

calc: extended_calculator.o
	ld extended_calculator.o -L../../../lib -lstring -lmath -o calc

clean:
	rm -f extended_calculator.o calc
