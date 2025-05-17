
all: ../libmath.a

math.o: math.asm
	nasm -f elf64 math.asm -o math.o

../libmath.a: math.o
	ar rcs ../libmath.a math.o

clean:
	rm -f math.o ../libmath.a
