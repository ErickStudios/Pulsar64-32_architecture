org32

vectors: Dword start        ; vector de arranque
start:
    dbgAc64                 ; configurar el 64 (skip solo para debug)
    org64                   ; decirle al asm que esta en Pulsar64
    
    slcinm       00h        ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld64        STACK_TOP   ; cargar direccion del stack

    linm        sp, 00h     ; cargar el inm que se edito
                            ; 01 40 02 00

    Align       200h
Byte 0
Align           128
STACK_TOP: