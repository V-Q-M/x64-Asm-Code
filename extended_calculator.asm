;                   CALCULATOR APP
;---------------------------------------------------------
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

    division_error db "Error: Division by Zero", 0
    division_error_len equ $ - division_error

section .text
    global _start

_start:
    ; ask for first number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall

    ; read input
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer1
    mov rdx, 20
    syscall
    call remove_newline
    ; convert number1 to int
    mov rsi, buffer1
    call string_to_int
    mov r8, rax ; store first number in r8

    ; ask for operand
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall

    ; read operand
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer2
    mov rdx, 20
    syscall
    call remove_newline

    ; ask for second number
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt3
    mov rdx, prompt3_len
    syscall

    ; read second number
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer3
    mov rdx, 20
    syscall
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
    cmp byte [buffer2], '^'
    je exponentiation

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
exponentiation:
    mov rax, r8
    mov r8, 1
.loop:
    cmp r10, 0
    je result

    imul r8, rax
    dec r10
    jmp .loop


division_by_zero:
    mov rsi, division_error
    mov rdx, division_error_len
    jmp output_result


result:
    mov rax, r8             ; move result into rax
    mov rdi, resultbuf      ; point to buffer
    call int_to_string      ; result in rax = length
    mov r11, rax            ; set rdx = length

output_result:
    ; write answer preamble
    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_len
    syscall

    ; write result
    mov rax, 1
    mov rdi, 1
    mov rsi, resultbuf ; correct result buffer
    mov rdx, r11
    syscall


end:
    mov rax, 60
    xor rdi, rdi
    syscall

                        ;Helper functions
;-------------------------------------------------------------
remove_newline:
    xor rcx, rcx

.remove_newline_loop:
    mov al, [rsi + rcx]
    cmp al, 10         ; \n
    je .found_newline
    cmp al, 13         ; \r
    je .found_newline
    test al, al
    jz .done_removal
    inc rcx
    jmp .remove_newline_loop

.found_newline:
    mov byte [rsi + rcx], 0
.done_removal:
    ret


; converts string to integer
string_to_int:
    xor rax, rax    ; clear rax
    xor rcx, rcx    ; clear rcx
.loop:
    movzx rdx, byte [rsi + rcx] ; load byte
    test rdx, rdx               ; null terminator?
    jz .done                    ; if zero, done
    cmp rdx, 10                 ; check for newline
    je .done

    sub rdx, '0'                 ; convert ASCII to int
    imul rax, rax, 10            ; result *= 10
    add rax, rdx                 ; result += digit

    inc rcx                     ; move to next character
    jmp .loop
.done:
    ret

; convert integer to string
int_to_string:
; save original buffer pointer
    push rdi
    xor rcx, rcx ; digit = 0

    test rax, rax
    jnz .convert_loop

    mov byte [rdi], '0'
    mov byte [rdi + 1], 0
    mov rax, 1
    pop rdi
    ret
.convert_loop:
    xor rdx, rdx ;clear rdx before division
    mov rbx, 10
    div rbx     ; rax / 10 -> quotient in rax, remainder in rdx

    add rdx, '0'    ;convert digit to ascii
    push rdx        ; store on stack (to reverse later)
    inc rcx         ; count digits

    test rax, rax
    jnz .convert_loop

.write_digits:
    cmp rcx, 0
    je .done

    pop rax
    mov [rdi], al
    inc rdi
    dec rcx
    jmp .write_digits

.done:
    mov byte [rdi], 10
    mov rax, rdi
    sub rax, resultbuf
    pop rdi
    ret
