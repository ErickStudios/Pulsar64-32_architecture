    org32               ; modo 32
dword       start       ; inicio firmware
    org64               ; modo 64
    .pic    start       ; uh
    miVariable: db 0    ; var
start:
    laddr   r0, miVariable  ; e pat assembler baya a a a a a a a a colocar como auto
    lv8     r1, r0          ; obtener eh
    add     r1, r1, 5       ; aña
    mwr8    r0, r1          ; escribir ah
    hlt                     ; congelar