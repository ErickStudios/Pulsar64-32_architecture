    
    ; =============================================
    ; una prueba ligera para la version
    ; lite de Pulsar64 de scratch para probar
    ; las capacidades de los dispositivos conectados
    ; todo esto esta subido a la cuenta llamada
    ; 'TypeScripterAutist42' donde se sube y
    ; comparte todos estos binarios en formato
    ; decimal ya compilados, este firmware usa
    ; como suposicion la maquina del proyecto 
    ; 'https://scratch.mit.edu/projects/1362842566/'
    ; que usa en su placa base el mapa de memoria
    ; (maped MMIO) listado en el siguiente bloque de
    ; comentario a continuacion
    ; =============================================

    ; SECTION .GPIO
    ;   PENCOLOR: 0x1B000
    ;   PENX:     0x1B001
    ;   PENY:     0x1B021

    org32
_fdhdr: dword   start

    org64
    PENCOLOR equ 1B000h
    PENX     equ 1B001h
    PENY     equ 1B002h

    ; entrada de start para el
    ; programa de el firmware
start:
    li32    sp, TOS ; configurar stack
    cmp     r0, 0, 0

    push    0           ; posicion X
    push    0           ; posicion Y
    push    50          ; half color
    bl      putpixel    ; funcion de poner pixel
    add     sp, sp, 24  ; limpiar stack

    li32    r1, img     ; verificar
    mov     r2, 5
    mov     r3, 5       ; contador

drawloop:
    push    r1          ; guardar
    push    r2          ; guardar r2

    mov     r4, 5       ; mover
drawrowloop:
    push    r0
    push    r1
    push    r2

    push    r4
    push    r3
    mov     r5, r1
    add     r5, r5, r4
    sub     r5, r5, 5
    mov     r0, [byte r5]
    mul     r0, r0, 50
    push    r0
    bl      putpixel
    add     sp, sp, 24  ; limpiar stack
    
    pop     r2
    pop     r1
    pop     r0

    inc     r4          ; incrementar
    push    r0
    sub     r0, r4, 12
    calc    r0
    pop     r0
    jifeq   drawrowloopnext
    jmp     drawrowloop
drawrowloopnext:

    pop     r2          ; recuperar r2
    pop     r1          ; recuperar
    add     r1, r1, 7   ; añadir
    dec     r2          ; decrementar
    inc     r3          ; incrementar

    cmp     r0, r2, 0   ; comparar con 0
    jifeq   drawloopend
    jmp     drawloop

drawloopend:

    hlt

    ; funcion para pintar un pixel en la
    ; pantalla de display con funciones
    ; de la VRAM externa a el CPU, que
    ; esta separada de la SRAM por lo que no
    ; esta dentro de la SRAM que el procesador
    ; ya tiene embebida dentro de si mismo
putpixel:
    enter   16          ; parametros puestos

    ; parametros de posicion X, Y y color
    mov     r0, [qword bp-0]
    mov     r1, [qword bp-8]
    mov     r2, [qword bp-16]

    li32    r6, PENX
    mwr8    r6, r0
    li32    r6, PENY
    mwr8    r6, r1
    li32    r6, PENCOLOR
    mwr8    r6, r2
    leave
    ret

    ; el stack para poder hacer funcionar
    ; mejor la PC y no sea tan dificil mandar
    ; y guardar cosas en las cosas
    reserve 128
TOS:

    ; imagen de un corazon pos namas
    ; por que si, esta en formato binario
    ; por byte
img:db 0,1,1,0,1,1,0
    db 1,1,1,0,1,1,1
    db 0,1,1,1,1,1,0
    db 0,0,1,1,1,0,0
    db 0,0,0,1,0,0,0
IMG_COLS       equ 7
IMG_ROWS       equ 5