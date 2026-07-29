    org32
dword       start
    org64
    .pic    safe
    miVariable: byte 24
    miVariable2: word 12
start:
    org32
    dbgAc64
    org64
safe:
    laddr   r0, miVariable
    lv8     r0, r1

    laddr   r2, miVariable2
    lv16    r2, r3

    add     r1, r1, r3
    mwr8    r0, r1
    mwr8    r2, r1

    hlt