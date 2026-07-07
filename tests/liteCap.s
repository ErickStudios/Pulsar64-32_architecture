    org32
Dword start
    org64
start:
    li64    r0, 0DEADh
    li64    r1, mn
    mwr16   r1, r0

    ifm16   02h, r1
    linm    r0, 02h
    
    add     r0, r0, 1

mn:
    Word    0