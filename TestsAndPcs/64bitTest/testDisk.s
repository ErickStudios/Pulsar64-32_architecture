    org64
    s1          equ 8200h
    s1dot5      equ 4200h
    s2          equ 9000h
    jmp         (start + s1)

    Align       20h
    dw          (end / 512) ; cantidad de sectores
start:
    ; cargar direccion
    li64        r0, 0       ; fs 
    li64        r1, 1       ; sector
    li64        r2, s1dot5  ; direccion donde escribira
    int         14h

    li64        r0, s1dot5
    ifm16       02h, r0
    linm        r1, 02h ; sector donde empieza
    add         r0, r0, 2
    ifm16       02h, r0
    linm        r3, 02h ; tamaño en sectores

    li64        r0, s2
loop:
    push        r0
    push        r1
    push        r2
    push        r3

    add         r2, r0, 0   ; donde lo hara
    add         r0, 0, 0    ; mover
    int         14h         ; leer disco

    pop         r3
    pop         r2
    pop         r1
    pop         r0

    ; sumar la direccion
    add         r0, r0, 255
    add         r0, r0, 255
    add         r0, r0, 2

    ; sumar y restar los registros
    add         r1, r1, 1
    sub         r3, r3, 1
    sub         r4, r3, 0
    calc        r4

    li64        lnk, (loop + s1)
    jipos       lnk
    li64        lnk, s2
    jmp         lnk

    align       512
buildroot:
    dw      (init / 512) ; donde inicia init
    dw      ((endinit - init) / 512) ; tamaño

    align   512
init:
    hlt
    li64        r0, 0       ; fs 
    li64        r1, 0       ; sector
    li64        r2, 8200h   ; direccion donde escribira
    int         14h         ; funcion para lanzar funciones desde el anillo 0
    Align       1024

endinit:

end: