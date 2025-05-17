global modulo
global exponentiation
global factorial


modulo:
    mov rax, r8
    xor rdx, rdx
    div r10
    mov r8, rdx
    jmp done
exponentiation:
    mov rax, r8
    mov r8, 1
.loop:
    cmp r10, 0
    je done

    imul r8, rax
    dec r10
    jmp .loop
factorial:
    mov rax, r8     ; rax = n
.loop:
    dec rax     ; n-1
    jz done
    imul r8, rax    ; n * n-1
    jmp .loop


done:
    ret
