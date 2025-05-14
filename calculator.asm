;                   CALCULATOR APP
;---------------------------------------------------------
section .bss
    buffer resb 100 ; reserve 100 Bytes for input

section .data
    prompt1 db "Enter first number: "
    prompt1_len equ $ - prompt1
    prompt2 db "Enter the operand: "
    prompt2_len equ $ - prompt2
    prompt3 db "Enter second number: "
    prompt3_len equ $ - prompt3

section .text
    global _start

_start:
    ; ask for first number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
