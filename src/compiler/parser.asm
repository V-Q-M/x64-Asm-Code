parse_scribe:
    xor rcx, rcx
    lea rsi, [contents + r15 + 1] ; source = current position + 1 (skip '(')
.loop:
    mov rbx, r15
    add rbx, rcx
    cmp rbx, r13         ; check end of buffer, avoid overflow
    jge .error_or_exit

    cmp byte [contents + r15 + rcx + 1], ')'
    je .found_close

    inc rcx
    jmp .loop

.found_close:
    lea rdi, [arg_buffer]     ; destination buffer
    rep movsb                 ; copy rcx bytes from rsi to rdi

    mov byte [arg_buffer + rcx], 0  ; null-terminate

    ; write output
    write scribe, scribe_len
    write arg_buffer, rcx
    write scribe_mid, scribe_mid_len
    write arg_buffer, rcx
    write text_syscall, text_syscall_len

    ;jmp ret

.error_or_exit:
    ;jmp return_to_scribe
