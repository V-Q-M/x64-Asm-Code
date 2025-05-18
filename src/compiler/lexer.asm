match_linea:
    mov rbx, r13
    sub rbx, r15
    cmp rbx, 5
    jl end_lexer

    cmp byte [contents + r15],     'L'
    jne match_caput
    cmp byte [contents + r15 + 1], 'i'
    jne match_caput
    cmp byte [contents + r15 + 2], 'n'
    jne match_caput
    cmp byte [contents + r15 + 3], 'e'
    jne match_caput
    cmp byte [contents + r15 + 4], 'a'
    jne match_caput
    add r15, 5
    ; found a string, now write it
    mov r14, -1
.small_loop:
        inc r14
        cmp byte [contents + r15 + r14 + 1], '='
        jne .small_loop

    mov rcx, r14
    lea rsi, [contents + r15 + 1] ; source = current
    lea rdi, [arg_buffer]     ; destination buffer
    rep movsb       ; copy n bytes from contents into
    mov byte [arg_buffer + r14], 0   ; null terminate arg_buffer

    write arg_buffer, r14       ;name
    write linea_db, 3           ; db

    add r15, r14
    ; string value comes here
    ;write testing, 11
    push r14
    add r15, 2
find_end:
    inc r14
    cmp byte [contents + r15 + r14], 34
    jne find_end

    mov rcx, r14
    lea rsi, [contents + r15 + 1] ; source = current
    lea rdi, [str_buffer]     ; destination buffer
    rep movsb       ; copy n bytes from contents into
  ;  mov byte [str_buffer + r14], 0   ; null terminate arg_buffer

    write str_buffer, r14
    write linea_end, 4

    pop r14

    write newline, 1
    write linea_prefix, 4           ; len_
    write arg_buffer, r14       ; name
    write linea_len, 8             ; equ $ -
    write arg_buffer, r14       ; name
    write newline, 1
    write newline, 1


match_caput:
    ; Check for "caput"
    mov rbx, r13
    sub rbx, r15
    cmp rbx, 5
    jl end_lexer

    cmp byte [contents + r15],     'c'
    jne match_scribe
    cmp byte [contents + r15 + 1], 'a'
    jne match_scribe
    cmp byte [contents + r15 + 2], 'p'
    jne match_scribe
    cmp byte [contents + r15 + 3], 'u'
    jne match_scribe
    cmp byte [contents + r15 + 4], 't'
    jne match_scribe
    ; write main header
    write main_method, main_method_len
    write caput, caput_len
    write newline, 1
    add r15, 5              ; skip past the matched token
    jmp lexer_loop

match_scribe:
    mov rbx, r13
    sub rbx, r15
    cmp rbx, 7
    jl end_lexer

    cmp byte [contents + r15],     's'
    jne next_char
    cmp byte [contents + r15 + 1], 'c'
    jne next_char
    cmp byte [contents + r15 + 2], 'r'
    jne next_char
    cmp byte [contents + r15 + 3], 'i'
    jne next_char
    cmp byte [contents + r15 + 4], 'b'
    jne next_char
    cmp byte [contents + r15 + 5], 'e'
    jne next_char
    ; found token, now look for argument
    cmp byte [contents + r15 + 6], '('
    ;jne next_char
    add r15, 6
    add r15, 1

    mov r14, -1
.small_loop:
    inc r14
    cmp byte [contents + r15 + r14 + 1], ')'
    jne .small_loop


    mov rcx, r14
    lea rsi, [contents + r15 + 1] ; source = current
    lea rdi, [arg_buffer]     ; destination buffer
    rep movsb       ; copy n bytes from contents into
    mov byte [arg_buffer + r14], 0   ; null terminate arg_buffer

    ; write correct passage
    write scribe, scribe_len ; syntax
    write arg_buffer, r14            ; argument
    write scribe_mid, scribe_mid_len
    write arg_buffer, r14
    write text_syscall, text_syscall_len

    jmp lexer_loop
