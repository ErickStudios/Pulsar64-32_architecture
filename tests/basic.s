    org64
    dd start
start:
    jmp         bootstrap

    LETLEN      equ 10
    NUMLEN      equ 6

    ; tokens type
    TYIDENT     equ 0
    TYNUM       equ 1
    TYOPR       equ 2

    align 20
identifiers:
    db          (print_ident/20)
    db          (input_ident/20)
    db          (goto_ident/20)
    db          (gosub_ident/20)
    db          (return_ident/20)
    db          0

    align       20
spaces:
    db          20h
    db          0Ah
    db          0Ch
    db          00h

    align       20
symbols:
    db          '+'
    db          '-'
    db          '*'
    db          '/'
    db          0

align 20 print_ident: 
    db 'P','R','I','N','T',0
align 20 input_ident: 
    db 'I','N','P','U','T',0
align 20 goto_ident: 
    db 'G','O','T','O',0
align 20 gosub_ident: 
    db 'G','O','S','U','B',0
align 20 return_ident: 
    db 'R','E','T','U','R','N'

    align 20
vars:
    reserve ((LETLEN+NUMLEN)*100)

    align   2
returnstack: reserve (2*128)
retTOS:
basicsp: word 0

    align   8
reserve 128 logicalstack:
bufferline: reserve 128
tokens:     reserve (2*20)

bootstrap:
    li32    sp, logicalstack
    mov     r0, 0
    calc    r0

    li32    r0, retTOS
    bl      config_sp

    li32    r0, bufferline
    bl      parse

    hlt

config_sp:
    li32    r7, basicsp
    mwr16   r7, r0
    jmp     lnk

push_value_bsp:
    li32    r7, basicsp
    lv16    r7, r8
    sub     r8, r8, 2
    mwr16   r7, r8
    mwr16   r8, r0
    jmp     lnk

push_new_token:
    li32    r7, tokens
    

parse:
loopp:
    mov     r1, [byte r0]
    add     r2, 0, (symbols/20)
    mul     r2, r2, 20
loop1:
    mov     r3, [byte r2]
    cmp     r4, r1, r3
    inc     r2
    jz      isSymbol

isSymbol:
endloop1: