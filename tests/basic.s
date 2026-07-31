    org64
    dd start
start:
    jmp         bootstrap

    LETLEN      equ 10
    NUMLEN      equ 3   ;0 - 999 (well, 255 xD)

    ; tokens type
    TYIDENT     equ 0
    TYNUM       equ 1
    TYOPR       equ 2
    TYUNKNOW    equ 3

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
    db 5,'P','R','I','N','T'
align 20 input_ident: 
    db 5,'I','N','P','U','T'
align 20 goto_ident: 
    db 4,'G','O','T','O'
align 20 gosub_ident: 
    db 5,'G','O','S','U','B'
align 20 return_ident: 
    db 6,'R','E','T','U','R','N'

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
testcode:
    db '1','2','3','+','0','0','4',0
tokens:     reserve (2*20)
toki:       word 0

bootstrap:
    li32    sp, logicalstack
    mov     r0, 0
    calc    r0

    li32    r0, retTOS
    bl      config_sp

    li32    r0, testcode
    bl      parse

    mov     r1, [dword r0+(0*2)]
    mov     r1, [dword r0+(1*2)]
    mov     r1, [dword r0+(2*2)]

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
    push    r0
    push    r1
    li32    r0, tokens
    li32    r1, toki
    lv16    r1, r1

    push    r1
    push    r2
    add     r0, r0, r1
    mwr8    r0, r7
    inc     r0
    mwr8    r0, r8
    pop     r2
    pop     r1

    push    r2
    li32    r2, toki
    add     r1, r1, 2
    mwr16   r2, r1
    pop     r2
    pop     r1
    pop     r0
    ret

parse:
    push    lnk
loopp:
    pop     lnk
    push    lnk
    mov     r1, [byte r0]
    cmp     r4, r1, 0
    jz      endParse
tryParseSymbolStart:
    add     r2, 0, (symbols/20)
    mul     r2, r2, 20
    mov     r7, TYUNKNOW
tryParseSymbol:
    mov     r3, [byte r2]
    cmp     r4, r1, r3
    inc     r2
    jz      isSymbol
    cmp     r4, r3, 0
    jz      iGiveUpItIsNotSymbol
    jmp     tryParseSymbol

isSymbol:
    mov     r7, TYOPR
    mov     r8, r3
    jmp     yeahIFindIt
iGiveUpItIsNotSymbol:
    jmp     tryParseNumberMain

tryParseNumberMain:
    cmp     r4, r1, '0'
    jg      hmmINotSureNum
    jz      isNumberPrefix
    jmp     endTryNum

hmmINotSureNum:
    cmp     r4, r1, '9'
    jl      isNumberPrefix
    jz      isNumberPrefix
    jmp     endTryNum

endTryNum:
    jmp     iGiveUpItIsNotNumber
isNumberPrefix:
    mov     r8, 0
    mov     r7, [byte r0]
    sub     r7, r7, '0'
    mul     r8, r8, 10
    add     r8, r8, r7
    mov     r7, [byte r0+1]
    sub     r7, r7, '0'
    mul     r8, r8, 10
    add     r8, r8, r7
    mov     r7, [byte r0+2]
    sub     r7, r7, '0'
    add     r8, r8, r7
    add     r0, r0, 2
    mov     r7, TYNUM
    jmp     yeahIFindIt
iGiveUpItIsNotNumber:
yeahIFindIt:
    bl      push_new_token
    inc     r0
    jmp     loopp
endParse:
    pop     lnk
    li32    r0, tokens
    ret