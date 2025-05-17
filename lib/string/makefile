# Assemble and archive string.asm into ../libstring.a

all: ../libstring.a

string.o: string.asm
	nasm -f elf64 string.asm -o string.o

../libstring.a: string.o
	ar rcs ../libstring.a string.o

clean:
	rm -f string.o ../libstring.a
