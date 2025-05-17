
section .data
    filename db "output.txt", 0
    text     db "Hello, world!", 10
    text_len equ $ - text

    O_WRONLY    equ 1
    O_CREAT     equ 64
    O_TRUNC     equ 512
    MODE_644    equ 0o644

section .text
    global _start

_start:
; open("output.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644)
mov rax, 2      ; syscall: open
mov rdi, filename ; const char *filename
mov rsi, O_WRONLY | O_CREAT | O_TRUNC ; flags
mov rdx, MODE_644   ; mode (file permission)
syscall
mov r12, rax    ; save file descriptor

; write(fd, text, text_len)
mov rax, 1
mov rdi, r12
mov rsi, text
mov rdx, text_len
syscall

; close(fd)
mov rax, 3      ; syscall: close
mov rdi, r12
syscall

; exit
mov rax, 60
xor rdi, rdi
syscall
