section .bss

section .data

teststring db "Salve amicus!", 10
teststring_len equ $ - teststring
section .text
	global _start

_start:

mov rax, 1
mov rdi, 1
mov rsi, teststring
mov rdx, teststring_len
syscall





end:
	mov rax, 60
	xor rdi, rdi
	syscall
