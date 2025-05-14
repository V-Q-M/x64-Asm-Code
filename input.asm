section .bss
    buffer resb 100 ; reserves 100 bytes for input

section .data
    prompt db "Enter something: ", 0xA
    prompt_len equ $ - prompt
    answer db "You entered: "
    answer_len equ $ - answer

section .text
    global _start

_start:
    ; print the prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; read from stdin into buffer
    mov rax, 0      ; syscall number: read
    mov rdi, 0      ; file descriptor: stdin
    mov rsi, buffer ; pointer to your input buffer
    mov rdx, 100    ; max bytes to read
    syscall
    ; result: rax = number of bytes read
    mov rbx, rax
    ; print the user input
    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rbx
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
