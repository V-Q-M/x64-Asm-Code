section .bss

section .data

salve db "Salve Amici!", 10
len_salve equ $ - salve 

section .text
	global _start

_start:

mov rax, 1
mov rdi, 1
mov rsi, salve
mov rdx, len_salve
syscall



end:
	mov rax, 60
	xor rdi, rdi
	syscall
