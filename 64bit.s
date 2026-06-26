
org64

start:
    slcinm       00h        ; seleccionar el inm a editar
                            ; 01 FF 01 00

    rstinm                  ; resetear el inm que se esta editando
                            ; 01 FF FF 01

    addinmb2     02h, 00h   ; añadir 2 bytes al inm
                            ; 01 12 02 00

    addinmb2     00h, 80h   ; añadir 2 bytes al inm
    savinm                  ; guardar el inm
                            ; 01 12 00 80

    linm        sp, 00h     ; cargar el inm que se edito
                            ; 01 40 02 00

    Align       20000h
Byte 0
Align           128
STACK_TOP: