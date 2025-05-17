; TOKENS
;
; KEYWORDS
    scribe      db "mov rax, 1", 10
                db "mov rdi, 1", 10
                db "mov rsi, teststring", 10
                db "mov rdx, teststring_len", 10
                db "syscall", 10

    scribe_len equ $ - scribe

    sisi        db "test", 0   ;si is already used
    si_len      equ $ - sisi

    aliter      db "test", 0
    aliter_len  equ $ - aliter

    redde       db "test", 0
    redde_len   equ $ - redde

    et          db "test"
    et_len      equ $ - et

    aut         db "test"
    aut_len     equ $ - aut

    non         db "test"
    non_len     equ $ - non

    dum         db "test"
    dum_len     equ $ - dum

    pro         db "test"
    pro_len     equ $ - pro

    frange      db "test"
    frange_len  equ $ - frange

    verum       db "test"
    verum_len   equ $ - verum

    falsum      db "test"
    falsum_len  equ $ - falsum


    ; IDENTIFIER
    caput db "_start:",10
    caput_len equ $ - caput

    ; NUMBER


    ; SYMBOL
