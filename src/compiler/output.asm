section .bss

section .data

teststring db "Salve amicus!", 10
len_teststring equ $ - teststring
section .text
	global _start

_start:

mov rax, 1
mov rdi, 1
mov rsi, teststringtesttestestt
mov rdx, len_teststringtesttestestt
syscall



end:
	mov rax, 60
	xor rdi, rdi
	syscall
