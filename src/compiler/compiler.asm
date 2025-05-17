;                   OVID-LANG COMPILER
;---------------------------------------------------------
;String functions
extern string_to_int
extern int_to_string
extern remove_newline

;Math functions
extern modulo
extern factorial
extern exponentiation


%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro input 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


section .data
    input_file db "test.ovd", 0
    output_file   db "output.asm", 0
    contents_size equ 100

    O_WRONLY    equ 1
    O_CREAT     equ 64
    O_TRUNC     equ 512
    MODE_644    equ 0o644

section .bss
    contents resb contents_size

section .text
    global _start

_start:
; open ovid-file
    mov rax, 2          ; open file
    mov rdi, input_file
    mov rsi, 0
    syscall
    mov r12, rax        ; save file descriptor
; read contents
    mov rax, 0
    mov rdi, r12
    mov rsi, contents
    mov rdx, contents_size
    syscall
    mov r13, rax        ; r13= number of bytes read

; close fd
    mov rax, 3
    mov rdi, r12
    syscall

; translate to asm


; write to output
; open output file
    mov rax, 2
    mov rdi, output_file
    mov rsi,  O_WRONLY | O_CREAT | O_TRUNC ; flags
    mov rdx, MODE_644                      ; file permission
    syscall
    mov r12, rax

; write contents
    mov rax, 1
    mov rdi, r12
    mov rsi, contents
    mov rdx, r13
    syscall

; close fd
    mov rax, 3
    mov rdi, r12
    syscall


end:
    mov rax, 60
    xor rdi, rdi
    syscall
