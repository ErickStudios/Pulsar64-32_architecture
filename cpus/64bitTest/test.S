org32

vectors: Dword start        ; vector de arranque

Mode32 EQU 00h ; modo de ejecucion
Mode64 EQU 01h ; modo de ejecucion

    Byte        0
start:                      ; alinear a 3
    dbgAc64                 ; configurar el 64 (skip solo para debug)
    org64                   ; decirle al asm que esta en Pulsar64
    
    slcinm       00h        ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld64        CPUTABLE    ; cargar direccion del stack
    linm        r0, 00h     ; cargar el inm que se edito

    ltbl        r0          ; cargar tabla

    slcinm       00h        ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld64        STACK_TOP   ; cargar direccion del stack
    linm        sp, 00h     ; cargar el inm que se edito

    rstinm                  ; resetear el inm que se esta editando
    ld16        0DEADh      ; valor a cargar
    linm        r0, 00h     ; cargar

    slcinm       01h        ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld16        00A0h      ; valor a cargar
    
    sub         sp, sp, 8   ; restar
    mwr64       sp, r0      ; poner en el stack
    
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r0, 02h     ; obtener inmediato
    
    sub         r0, 7, 7    ; restar ya que asi se calcula
    calc        r0          ; actualizar flags (01 FF FF 23)

    slcinm      02h         ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld64        TestEqual   ; valor a cargar

    jifeq       i(02h)      ; saltar al inmediato 2 (01 FF 3[BitToBeTruthyFor] TI)

    add         r0, 4, 5    ; xd  

TestEqual:
    add         r0, 1, 2    ; xd  
    
    int         01h         ; lanzar int

    Align       128 Byte 0
    Align       128
STACK_TOP:

    Align       4096
CPUTABLE:
    Qword       InterruptionsTable
    Qword       LevelsSettings
    Qword       MemoryRegionsTable

    Align       16
InterruptionsTable:
    Dword       Mode32      ; modo de ISA en el que operara
    Dword       00h         ; indice de la paleta de nivel de privilegio
    Qword       isr1        ; manejador

    Dword       Mode64      ; modo de ISA en el que operara
    Dword       00h         ; indice de la paleta de nivel de privilegio
    Qword       isr2        ; manejador

    Align       16
LevelsSettings:
    Qword       00h, 0FFFFFFFFH ; IOM + PRIVS (kernel)
    Qword       01h, 0FFFFFFFFH ; IOM + PRIVS (user)

    Align       16
MemoryRegionsTable:
    Qword       00000000h, 0FFFFFFFFFFFFFFFFh ; inicio y fin de donde tiene permitido escribir
    Qword       ProgramsSafeZone, EndProgramSafeZone ; final

ProgramsSafeZone:
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
    Align 512 Byte  0
EndProgramSafeZone:

    org32
isr1:
    Push-Dword          10  ; probar
    Ror-Dword           Ax, Sp ; recuperar
    Iret                    ; instruccion especial para retornar el contexto

    org64
    Align       4
isr2:
    sub         sp, sp, 8   ; restar
    mwr64       sp, r0      ; poner en el stack

    movi64
    slcinm      02h         ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld64        xd2         ; valor a cargar

    jmp         i(02h)
    add         r0, r0, 7   ; ejemplo para saltar

xd2:
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r0, 02h     ; obtener inmediato
    
    iret