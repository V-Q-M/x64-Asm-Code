section .data
    msg1 db "Something's wrong...", 0xA
    len1 equ $ - msg1
    msg2 db "Correct!", 0xA
    len2 equ $ - msg2

section .text
    global _start

_start:

l1:
    mov rax, 4 ; 4
    add rax, 6 ; + 6
    imul rax, 4 ; * 3

    mov rbx, 30
    cmp rax, rbx
    je l2             ; jump if equal (i.e. correct)

    ; print msg1: "Something's wrong..."

    ; sys_write (syscall number 1)
    mov rax, 1       ; syscall: sys_write
    mov rdi, 1       ; file descriptor: stdout
    mov rsi, msg1    ; pointer to message
    mov rdx, len1    ; message length
    syscall
    jmp exit

l2:
    ; print msg2: "Correct!"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall


exit:
    ; sys_exit (syscall number 60)
    mov rax, 60     ; syscall: exit
    xor rdi, rdi    ; status: 0
    syscall
