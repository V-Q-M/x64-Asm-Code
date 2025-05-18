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

%macro write 2
    mov rax, 1
    mov rdi, r12
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .bss
    arg_buffer resb 20

section .data
    input_file db "input.ovd", 0
    output_file   db "output.asm", 0
    contents_size equ 100
    newline db 10, 0

    O_WRONLY    equ 1
    O_CREAT     equ 64
    O_TRUNC     equ 512
    MODE_644    equ 0o644



; Compiler text
    ; imports
    ;
    ; reserved data
    buffer_header db  "section .bss", 10, 10
    buffer_header_len equ $ - buffer_header
    data_header   db "section .data", 10, 10
    data_header_len   equ $ - data_header
    ; test data
    teststring    db 'teststring db "Salve amicus!", 10', 10, "len_teststring equ $ - teststring", 10
    len_teststring     equ $ - teststring

    ; main text
    main_method   db "section .text", 10, 9, "global _start", 10, 10
    main_method_len   equ $ - main_method

    ; ending
    main_footer   db "end:", 10, 9, "mov rax, 60", 10, 9, "xor rdi, rdi", 10, 9, "syscall", 10
    main_footer_len   equ $ - main_footer
;----------------------------------------------------
; Tokens
%include "tokens.asm"


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


; write to output
; open output file
    mov rax, 2
    mov rdi, output_file
    mov rsi,  O_WRONLY | O_CREAT | O_TRUNC ; flags
    mov rdx, MODE_644                      ; file permission
    syscall
    mov r12, rax



; write imports

; write reserved data
    write buffer_header, buffer_header_len


    write data_header, data_header_len
    ; test data
    write teststring, len_teststring

; write main header
    write main_method, main_method_len

; write contents
; translate to asm
; lexer, every token has its own label
lexer:
    xor r15, r15            ; index = 0
lexer_loop:
    cmp r15, r13            ; end of buffer?
    jge end_lexer

; the cases are stored in there
%include "lexer.asm"

next_char:
    inc r15
    jmp lexer_loop

end_lexer:

; parser
;%include "parser.asm"

; filler for now
    write newline, 1
    write newline, 1
    write newline, 1
    write newline, 1

; write footer
    write main_footer, main_footer_len

; close fd
    mov rax, 3
    mov rdi, r12
    syscall


end:
    mov rax, 60
    xor rdi, rdi
    syscall
