    org32
    dd      start
vendorReal: 
    db 'E','B','o','o','t',13,10,0
nonvdisplay:
    db 'N','o',' ','d','i','s','p','l','a','y',13,10,0
start:
    dbgAc64
    org64
    mov     r0, 0
    calc    r0
    li64    sp, TOS
    bl      main
halt: hlt
__uart:             dq 100000h
__portStartAddr:    dq 50000h

__vend: dq vendorReal
    align 8 reserve 128
TOS:
Table: reserve 8
entryBoot: reserve 8
main:
   enter 0
   li64 r0, Table
   li64 r1, __vend
   lv64 r1, r1
   mwr8 r0, r1
   li64 r0, UartAddr
   li64 r1, __uart
   lv64 r1, r1
   mwr64 r0, r1
   bl initdisplay
   add sp, sp, 0
   li64 r1, __vend
   lv64 r1, r1
   push r1
   bl puts
   add sp, sp, 8
   li64 r1, BootSectorLoader
   lv64 r1, r1
   push r1
   li64 r1, 0
   push r1
   bl readDisk
   add sp, sp, 16
   li64 r0, entryBoot
   li64 r1, BootSectorLoader
   lv64 r1, r1
   mwr64 r0, r1
   li64 lnk, entryBoot lv64 lnk, lnk bl lnk
   leave
   ret
portTmp: reserve 8
outPort:
   enter 8
   li64 r0, portTmp
   mov r1, [qword bp-0]
   li64 r2, 327680
   add r1, r1, r2
   mwr64 r0, r1
   li64 r0, portTmp
   mov r0, [qword r0]
   mov r1, [qword bp-8]
   mwr8 r0, r1
   leave
   ret
inPort:
   enter 8
   li64 r0, portTmp
   mov r1, [qword bp-0]
   li64 r2, 327680
   add r1, r1, r2
   mwr64 r0, r1
   mov r0, [qword bp-8]
   li64 r1, portTmp
   mov r1, [qword r1]
   lv8 r1, r1
   mwr8 r0, r1
   leave
   ret
ReadDisktmpStatus: reserve 1
ReadDisktmpwaitCount: reserve 1
ReadDisktmpbuffer: reserve 8
ReadDisktmpInfo: reserve 4
ReadDiskByteReaded: reserve 1
ReadDiskTmpByteRead: reserve 2
readDisk:
   enter 8
   li64 r0, ReadDisktmpbuffer
   mov r1, [qword bp-0]
   mwr64 r0, r1
   li64 r1, 672
   push r1
   li64 r1, 1
   push r1
   bl outPort
   add sp, sp, 16
   li64 r0, ReadDisktmpwaitCount
   li64 r1, 20
   mwr8 r0, r1
while_4529:
   li64 r0, ReadDisktmpwaitCount
   lv8 r0, r0
   li64 r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_6784
   li64 r0, ReadDisktmpwaitCount
   li64 r1, ReadDisktmpwaitCount
   lv8 r1, r1
   li64 r2, 1
   sub r1, r1, r2
   mwr8 r0, r1
   jmp while_4529
end_6784:
   li64 r2, 672
   push r2
   li64 r2, ReadDisktmpStatus
   push r2
   bl inPort
   add sp, sp, 16
if_9732:
   li64 r0, ReadDisktmpStatus
   lv8 r0, r0
   li64 r1, 255
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq endif_5596
   li64 r0, ReadDiskTmpByteRead
   li64 r1, 0
   mwr16 r0, r1
while_9731:
   li64 r0, ReadDiskTmpByteRead
   lv16 r0, r0
   li64 r1, 512
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_636
   li64 r0, ReadDisktmpInfo
   mov r1, [qword bp-8]
   li64 r2, 8
   shr r1, r1, r2
   mwr8 r0, r1
   li64 r0, ReadDisktmpInfo
   li64 r1, ReadDisktmpInfo
   lv8 r1, r1
   li64 r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   li64 r0, ReadDisktmpInfo
   add r0, r0, 1
   mov r1, [qword bp-8]
   li64 r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   li64 r0, ReadDisktmpInfo
   add r0, r0, 2
   li64 r1, ReadDiskTmpByteRead
   lv16 r1, r1
   li64 r2, 8
   shr r1, r1, r2
   mwr8 r0, r1
   li64 r0, ReadDisktmpInfo
   add r0, r0, 2
   li64 r1, ReadDisktmpInfo
   add r1, r1, 2
   lv8 r1, r1
   li64 r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   li64 r0, ReadDisktmpInfo
   add r0, r0, 3
   li64 r1, ReadDiskTmpByteRead
   lv16 r1, r1
   li64 r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   li64 r2, 674
   push r2
   li64 r2, ReadDisktmpInfo
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 675
   push r2
   li64 r2, ReadDisktmpInfo
   add r2, r2, 1
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 676
   push r2
   li64 r2, ReadDisktmpInfo
   add r2, r2, 2
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 677
   push r2
   li64 r2, ReadDisktmpInfo
   add r2, r2, 3
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 672
   push r2
   li64 r2, 129
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 672
   push r2
   li64 r2, 152
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 672
   push r2
   li64 r2, 128
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 673
   push r2
   li64 r2, ReadDiskByteReaded
   push r2
   bl inPort
   add sp, sp, 16
   li64 r0, ReadDisktmpbuffer
   mov r0, [qword r0]
   li64 r1, ReadDiskByteReaded
   lv8 r1, r1
   mwr8 r0, r1
   li64 r0, ReadDiskTmpByteRead
   li64 r1, ReadDiskTmpByteRead
   lv16 r1, r1
   li64 r2, 1
   add r1, r1, r2
   mwr16 r0, r1
   li64 r0, ReadDisktmpbuffer
   li64 r1, ReadDisktmpbuffer
   lv64 r1, r1
   li64 r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_9731
end_636:
endif_5596:
   leave
   ret
UartAddr: reserve 8
putc:
   enter 0
   li64 r0, UartAddr
   mov r0, [qword r0]
   mov r1, [qword bp-0]
   mwr8 r0, r1
   leave
   ret
putstmp1: reserve 1
putstmp2: reserve 8
puts:
   enter 0
   li64 r0, putstmp2
   mov r1, [qword bp-0]
   mwr64 r0, r1
while_9810:
   li64 r0, putstmp2
   mov r0, [qword r0]
   lv8 r0, r0
   li64 r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_379
   li64 r0, putstmp1
   li64 r1, putstmp2
   mov r1, [qword r1]
   lv8 r1, r1
   mwr8 r0, r1
   li64 r1, putstmp1
   lv8 r1, r1
   push r1
   bl putc
   add sp, sp, 8
   li64 r0, putstmp2
   li64 r1, putstmp2
   lv64 r1, r1
   li64 r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_9810
end_379:
   leave
   ret
drawPixel:
   enter 16
   li64 r0, 874
   push r0
   mov r0, [qword bp-0]
   push r0
   bl outPort
   add sp, sp, 16
   li64 r0, 875
   push r0
   mov r0, [qword bp-8]
   push r0
   bl outPort
   add sp, sp, 16
   li64 r0, 876
   push r0
   mov r0, [qword bp-16]
   push r0
   bl outPort
   add sp, sp, 16
   leave
   ret
idispTmpData: reserve 1
idispIndex: reserve 2
idispCol: reserve 3
initdisplay:
   enter 0
   li64 r0, 864
   push r0
   li64 r0, idispTmpData
   push r0
   bl inPort
   add sp, sp, 16
   li64 r0, 864
   push r0
   li64 r0, 0
   push r0
   bl outPort
   add sp, sp, 16
   li64 r0, 865
   push r0
   li64 r0, 255
   push r0
   bl outPort
   add sp, sp, 16
   li64 r0, 870
   push r0
   li64 r0, 255
   push r0
   bl outPort
   add sp, sp, 16
   li64 r0, 864
   push r0
   li64 r0, 1
   push r0
   bl outPort
   add sp, sp, 16
   li64 r0, idispIndex
   li64 r1, 0
   mwr16 r0, r1
while_9635:
   li64 r0, idispIndex
   lv16 r0, r0
   li64 r1, 256
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_9412
   li64 r0, idispCol
   li64 r1, idispIndex
   lv16 r1, r1
   li64 r2, 4
   shr r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   li64 r1, idispCol
   lv8 r1, r1
   li64 r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   add r0, r0, 1
   li64 r1, idispIndex
   lv16 r1, r1
   li64 r2, 2
   shr r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   add r0, r0, 1
   li64 r1, idispCol
   add r1, r1, 1
   lv8 r1, r1
   li64 r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   add r0, r0, 2
   li64 r1, idispIndex
   lv16 r1, r1
   li64 r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   li64 r1, idispCol
   lv8 r1, r1
   li64 r2, 64
   mul r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   add r0, r0, 2
   li64 r1, idispCol
   add r1, r1, 2
   lv8 r1, r1
   li64 r2, 64
   mul r1, r1, r2
   mwr8 r0, r1
   li64 r0, idispCol
   add r0, r0, 1
   li64 r1, idispCol
   add r1, r1, 1
   lv8 r1, r1
   li64 r2, 64
   mul r1, r1, r2
   mwr8 r0, r1
   li64 r2, 866
   push r2
   li64 r2, idispIndex
   lv16 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 867
   push r2
   li64 r2, idispCol
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 868
   push r2
   li64 r2, idispCol
   add r2, r2, 1
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 869
   push r2
   li64 r2, idispCol
   add r2, r2, 2
   lv8 r2, r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 864
   push r2
   li64 r2, 2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r0, idispIndex
   li64 r1, idispIndex
   lv16 r1, r1
   li64 r2, 1
   add r1, r1, r2
   mwr16 r0, r1
   jmp while_9635
end_9412:
   li64 r2, 1
   push r2
   li64 r2, 2
   push r2
   li64 r2, 255
   push r2
   bl drawPixel
   add sp, sp, 24
   li64 r0, 0
   leave
   ret
   leave
   ret
BootSectorLoader: dq 8D00h
