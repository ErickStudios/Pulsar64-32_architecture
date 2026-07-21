
    org32
vectors: 
    Dword start        ; vector de arranque
    Mode32 EQU 00h ; modo de ejecucion
    Mode64 EQU 01h ; modo de ejecucion

    Align 24
DiskFsSelected: Byte 0
DiskSector:     Byte 0
DiskOutpudDir:  Byte 0
DiskReadTrigger:Byte 0
DiskReadFinish: Byte 0

    Byte        0
start:
    dbgAc64                 ; configurar el 64 (skip solo para debug)
    org64                   ; decirle al asm que esta en Pulsar64

    li64        r0, TABLEC  ; cargar tope del stack
    srw         fs, r0      ; 01 05 05 03 (SR (R))

    cmp         r0, 0, 0

    li64        sp, STACK_TOP;cargar tope del stack
    li64        r0, CPUTABLE; cargar direccion de la tabla
    ltbl        r0          ; cargar tabla
    
    cmp         r0, 7, 7    ; equal thing
    jifeq       TestEqual   ; equal
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

    Dword       Mode64      ; modo de ISA en el que operara
    Dword       00h         ; indice de la paleta de nivel de privilegio
    Qword       bootsrap    ; manejador

    Dword       Mode64      ; modo de ISA en el que operara
    Dword       00h         ; indice de la paleta de nivel de privilegio
    Qword       diskRead    ; manejador

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
    push        r0          ; guardar r0
    pop         r0          ; cargar r0

    iret

; ================ EXCEPCIONES ================
    org64
segfault:
    jmp         hang        ; loop

none:
    hlt
    iret

diskRead:
    bl          readDisk
    iret 

bootsrap:
    bl          lnk
    iret 

ProgramsSafeZone:
user_load:
    li64        sp, KernelStackTop ; iniciar el stack del usuario

    li64        r0, 0       ; fs 
    li64        r1, 0       ; sector
    li64        r2, 8200h   ; direccion donde escribira
    int         14h         ; funcion para lanzar funciones desde el anillo 0

    jmp         r2 
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

readDisk:
    ; escribir el FS donde leera
    push        r1
    push        r2
    push        r3
    add         r2, r0, 0   ; añadir
    li64        r1, DiskFsSelected
    add         r3, r2, 0   ; mover
    shr         r3, r3, 8   ; shiftear
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    add         r3, r2, 0   ; mover
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    pop         r3
    pop         r2
    pop         r1

    ; escribir el Sector donde leera
    push        r1
    push        r2
    push        r3
    add         r2, r1, 0   ; añadir
    li64        r1, DiskSector
    add         r3, r2, 0   ; mover
    shr         r3, r3, 8   ; shiftear
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    add         r3, r2, 0   ; mover
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    pop         r3
    pop         r2
    pop         r1

    ; escribir la direccion de memoria donde escribira
    push        r1
    push        r2
    push        r3
    li64        r1, DiskOutpudDir
    add         r3, r2, 0   ; mover
    shr         r3, r3, 24  ; shiftear
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    add         r3, r2, 0   ; mover
    shr         r3, r3, 16  ; shiftear
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    add         r3, r2, 0   ; mover
    shr         r3, r3, 8   ; shiftear
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    add         r3, r2, 0   ; mover
    and         r3, r3, 0FFh; mascara
    mwr8        r1, r3      ; escribir
    pop         r3
    pop         r2
    pop         r1

    ; activar trigger
    push        r1
    push        r2
    push        r3

    li64        r1, DiskReadFinish
    mov         r2, 0
    mwr8        r1, r2
    li64        r1, DiskReadTrigger
    add         r2, 0, 1
    mwr8        r1, r2
    li64        r1, DiskReadFinish

chloop:
    ifm8        02h, r1
    linm        r2, 02h
    sub         r3, 1, r2
    calc        r3
    li64        r3, echloop
    jifeq       r3
    li64        r3, chloop
    jmp         r3
echloop:
    pop         r3
    pop         r2
    pop         r1

    jmp         lnk

putmsg:
    push        lnk
    push        r0
    push        r1
    push        r2
    push        r3
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
    pop         r3
    pop         r2
    pop         r1
    pop         r0
    pop         lnk
    jmp         lnk         ; saltar al link