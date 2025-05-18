section .bss

section .data

teststring db 
len_teststring equ $ - teststring 

hello db 
len_hello equ $ - hello 

section .text
	global _start

_start:

mov rax, 1
mov rdi, 1
mov rsi, teststring
mov rdx, len_teststring
syscall



end:
	mov rax, 60
	xor rdi, rdi
	syscall
