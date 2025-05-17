;                   CALCULATOR APP
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


section .bss
    buffer1 resb 20 ; reserve 20 Bytes for input
    buffer2 resb 20
    buffer3 resb 20
    resultbuf resb 20

section .data
    prompt1 db "Enter first number: ", 0
    prompt1_len equ $ - prompt1
    prompt2 db "Enter the operand: ", 0
    prompt2_len equ $ - prompt2
    prompt3 db "Enter second number: ", 0
    prompt3_len equ $ - prompt3
    answer  db "Your result is: ", 0
    answer_len  equ $ - answer
    newline db 10, 0 ; newline for printing

    division_error db "Error: Division by Zero", 10
    division_error_len equ $ - division_error

    invalid_msg db "Error: Invalid Input.", 0
    invalid_msg_len equ $ - invalid_msg

section .text
    global _start

_start:
    ; ask for first number
    print prompt1, prompt1_len

    ; get input
    input buffer1, 20
    call remove_newline

    ; convert number1 to int
    mov rsi, buffer1
    call string_to_int
    mov r8, rax ; store first number in r8

    ; ask for operand
    print prompt2, prompt2_len

    ; read operand
    input buffer2, 20
    call remove_newline
    ; Catch operands that dont require a second argument
    cmp byte [buffer2],'!'
    je math_factorial

    ; ask for second number
    print prompt3, prompt3_len

    ; read second number
    input buffer3, 20
    call remove_newline

    ; convert number2 to int
    mov rsi, buffer3
    call string_to_int
    mov r10, rax

    ; calculate result
    cmp byte [buffer2], '+'
    je addition
    ;cmp byte [buffer2], 'plus'
    je addition
    cmp byte [buffer2], '-'
    je subtraction
    ;cmp byte [buffer2], 'minus'
    je subtraction
    cmp byte [buffer2], '*'
    je multiplication
    ;cmp byte [buffer2], 'times'
    je multiplication
    cmp byte [buffer2], '/'
    je division
    ;cmp byte [buffer2], 'divide'
    je division
    cmp byte [buffer2], '%'
    je math_mod
    cmp byte [buffer2], '^'
    je math_expt

; fallback if nothing matches
invalidInput:
    print invalid_msg, invalid_msg_len
    jmp end

addition:
    add r8, r10
    jmp result
subtraction:
    sub r8, r10
    jmp result
multiplication:
    imul r8, r10
    jmp result
division:
    cmp r10, 0 ; filter out 0 divsion
    je division_by_zero
    mov rax, r8
    xor rdx, rdx
    div r10
    mov r8, rax
    jmp result
division_by_zero:
    print division_error, division_error_len
    jmp end
; imported from math
math_mod:
    call modulo
    jmp result
math_factorial:
    call factorial
    jmp result
math_expt:
    call exponentiation
    jmp result

result:
    mov rax, r8             ; move result into rax
    mov rdi, resultbuf      ; point to buffer
    call int_to_string      ; result in rax = length
    mov r11, rax            ; set rdx = length

output_result:
    ; write answer preamble
    print answer, answer_len

    ; write result
    print resultbuf, r11

end:
    mov rax, 60
    xor rdi, rdi
    syscall
                        ;Helper functions
;-------------------------------------------------------------
