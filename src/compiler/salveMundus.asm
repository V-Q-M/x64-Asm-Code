section .bss

section .data

salve db "Salve Amici!", 10
len_salve equ $ - salve 

ajena db "Hajo Ajena", 10
len_ajena equ $ - ajena 

section .text
	global _start

_start:

mov rax, 1
mov rdi, 1
mov rsi, salve
mov rdx, len_salve
syscall
mov rax, 1
mov rdi, 1
mov rsi, ajena
mov rdx, len_ajena
syscall




end:
	mov rax, 60
	xor rdi, rdi
	syscall
