    org32
    dd      main
main:
    ; inicializacion basica para esta prueba
    dbgAc64
    org64
    li64    sp, Stack   ; configurar el stack
    cmp     r0, 0, 0    ; comparar
    
    push    20          ; set x
    push    5           ; set y
    bl      myAdd       ; añdir
    add     sp, sp, 16

    hlt

myAdd:
    ; crear stack frame y poner bp al principio de los parametros
    enter   (1*8)                   ; crear params frame

    ; obtener parametros
    mov     r0, [qword bp-(0*8)]    ; get x
    mov     r1, [qword bp-(1*8)]    ; get y

    ; operacion
    add     r0, r0, r1              ; operar

    ; salir de la funcion
    leave                           ; salir del contexto
    ret                             ; regresar

    Align   128
    Byte    0
    Align   128
Stack: