global string_to_int
global int_to_string

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
    push rdi        ; Save original point
    mov rsi, rdi    ; Save base address to calculate length later
    xor rcx, rcx   ; digit = 0

    test rax, rax
    jnz .convert_loop

    mov byte [rdi], '0'
    mov byte [rdi + 1], 0
    mov rax, 1      ; length = 1
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
    sub rdi, rsi    ; rdi - original pointer = length
    mov rax, rdi    ; return length in rax
    pop rdi         ; restore rdi
    ret
