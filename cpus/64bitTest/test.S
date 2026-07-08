
    org32
vectors: 
    Dword start        ; vector de arranque
    Mode32 EQU 00h ; modo de ejecucion
    Mode64 EQU 01h ; modo de ejecucion

    Byte        0
start:
    dbgAc64                 ; configurar el 64 (skip solo para debug)
    org64                   ; decirle al asm que esta en Pulsar64

    li64        r0, TABLEC  ; cargar tope del stack
    srw         fs, r0      ; 01 05 05 03 (SR (R))

    add         r0, 0, 0    ; limpiar r0
    calc        r0          ; limpiar flags

    li64        sp, STACK_TOP;cargar tope del stack
    li64        r0, CPUTABLE; cargar direccion de la tabla
    ltbl        r0          ; cargar tabla

    sub         r0, 7, 7    ; restar ya que asi se calcula
    calc        r0          ; actualizar flags (01 FF FF 23)
    
    slcinm      02h         ; seleccionar el inm a editar
    rstinm                  ; resetear el inm que se esta editando
    ld64        TestEqual   ; valor a cargar

    jifeq       i(02h)      ; saltar al inmediato 2 (01 FF 3[BitToBeTruthyFor] TI)

    add         r0, 4, 5    ; xd  

TestEqual:
    add         r0, 1, 2    ; xd  
    int         12h         ; lanzar int

    Align       128 Byte 0
STACK_START:
    Align       128
STACK_TOP:

    Align       4096
CPUTABLE:
    Qword       InterruptionsTable
    Qword       LevelsSettings
    Qword       MemoryRegionsTable

    Align       16
InterruptionsTable:

    ; ========== 00h a 0Fh reservados para excepciones

    Dword       Mode64, 00h ; permisos de la excepcion de violacion de segmento
    Qword       segfault    ; puntero alli

    Dword       Mode64, 00h ; permisos de la excepcion de violacion de registro de segmento
    Qword       hang        ; puntero alli

    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0
    Qword       0,0

    Dword       Mode32      ; modo de ISA en el que operara
    Dword       00h         ; indice de la paleta de nivel de privilegio
    Qword       isr1        ; manejador

    Dword       Mode64      ; modo de ISA en el que operara
    Dword       00h         ; indice de la paleta de nivel de privilegio
    Qword       isr2        ; manejador

    Dword       Mode64      ; modo de ISA en el que operara
    Dword       01h         ; indice de la paleta de nivel de privilegio
    Qword       user_load   ; manejador

    Align       16
LevelsSettings:
    Qword       00h, 0FFFFFFFFH ; IOM + PRIVS (kernel)
    Qword       01h, 0FFFF8203H ; IOM + PRIVS (user)

    Align       16
MemoryRegionsTable:
    Qword       00000000h
    Dword       0FFFFFFFFh, 0FFFFFFFFh ; inicio y fin de donde tiene permitido escribir
    Qword       ProgramsSafeZone ; final
    Dword       0FFFFFFFFh, 0FFFFFFFFh ; final de la ram

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

    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r0, 02h     ; obtener inmediato
    
    iret

; ================ EXCEPCIONES ================
    org64
segfault:
    li64        r0, hang    ; obtener direccion del panic
    jmp         r0          ; saltar
    
ProgramsSafeZone:
user_load:
    li64        sp, KernelStackTop ; iniciar el stack del usuario
    li64        r0, adaa    ; puntero al mensaje
    li64        bl, putmsg  ; funcion para poner mensaje
    bl          r6          ; lanzar funcion y guardar el retorno en lnk
    hlt                     ; programa terminado
adaa:
    Byte 'a','b','c',0
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

    Align       128 Byte 0
KernelStackStart:
    Align       128
KernelStackTop:

    Align       4096
EndProgramSafeZone:

; ================ HANDLE PARA EXCEPCIONES Y MAS ================
    org64
hang:
    li64        r0, hang    ; obtener direccion del label
    jmp         r0          ; saltar

putmsg:
    sub         sp, sp, 8   ; restar
    mwr64       sp, lnk     ; poner en el stack
    sub         sp, sp, 8   ; restar
    mwr64       sp, r0      ; poner en el stack
    sub         sp, sp, 8   ; restar
    mwr64       sp, r1      ; poner en el stack
    sub         sp, sp, 8   ; restar
    mwr64       sp, r2      ; poner en el stack
    sub         sp, sp, 8   ; restar
    mwr64       sp, r3      ; poner en el stack
putmsgl:
    ifm8        02h, r0      ; obtener caracter
    linm        r1, 02h     ; obtener
    sub         r2, r1, 0   ; restar para verificar si termino
    calc        r2          ; calcular
    li64        r3, putmsg_end ; direccion de fin
    jifeq       r3          ; saltar si termino
    li64        r3, 100000h ; cargar direccion del uart
    mwr8        r3, r1      ; escribir
    add         r0, r0, 1   ; seguir puntero
    li64        r3, putmsgl; direccion de fin
    jmp         r3
putmsg_end:
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r3, 02h     ; obtener inmediato
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r2, 02h     ; obtener inmediato
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r1, 02h     ; obtener inmediato
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        r0, 02h     ; obtener inmediato
    ifm64       02h, sp     ; obtener del el puntero al stack
    add         sp, sp, 8   ; añadir
    linm        lnk, 02h    ; obtener inmediato
    jmp         lnk         ; saltar al link
