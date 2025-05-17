
section .data
    filename db "output.txt", 0
    buffer_size equ 100
    newline db 10

section .bss
    buffer resb buffer_size

section .text
    global _start

_start:
;   open input.txt readonly
mov rax, 2
mov rdi, filename
mov rsi, 0  ; readonly
syscall
mov r12, rax        ; save file descriptoer

; read
mov rax, 0
mov rdi, r12
mov rsi, buffer
mov rdx, buffer_size
syscall
mov r13, rax        ; r13= number of bytes read

;write
mov rax, 1
mov rdi, 1
mov rsi, buffer
mov rdx, r13
syscall

; close(fd)
mov rax, 3      ; syscall: close
mov rdi, r12
syscall

; exit
mov rax, 60
xor rdi, rdi
syscall
