; Convert string to int and int to string
; --------------------------------------------
section .data
    msg db "123", 0
    len equ $ - msg
    buffer times 20 db 0


section .text
    global _start

_start:
    ; write string
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ;convert string to int
    mov rsi, msg
    call string_to_int
    ; result is in rax
    add rax, 1

    ;convert int to string
    mov rdi, buffer
    call int_to_string

    ; write results
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 5
    syscall


end:
    mov rax, 60
    xor rdi, rdi
    syscall


; converts string to integer
string_to_int:
    xor rax, rax    ; clear rax
    xor rcx, rcx    ; clear rcx

.loop:
    movzx rdx, byte [rsi + rcx] ; load byte
    test rdx, rdx               ; null terminator?
    jz .done                    ; if zero, done

    sub rdx, '0'                 ; convert ASCII to int
    imul rax, rax, 10            ; result *= 10
    add rax, rdx                 ; result += digit

    inc rcx                     ; move to next character
    jmp .loop

.done:
    ret


; Converts integer in RAX to a null-terminated ASCII string
; Input:  rax = integer to convert
;         rdi = pointer to buffer
; Output: buffer at [rdi] = ASCII string (null-terminated)
int_to_string:
; save original buffer pointer
    push rdi

    xor rcx, rcx ; digit = 0

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
    pop rax
    mov [rdi], al
    inc rdi
    loop .write_digits

    mov byte [rdi], 0   ; null terminator

    pop rdi             ; restore original buffer pointer
    ret
