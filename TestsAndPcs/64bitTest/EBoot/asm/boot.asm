    org32
    dd      start
vendorReal: 
    db 'E','B','o','o','t',0
start:
    dbgAc64
    org64
    mov     r0, 0
    calc    r0
    li64    sp, TOS
    bl      main
halt: hlt
__uart: dq 100000h
__vend: dq vendorReal
    align 8 reserve 128
TOS: