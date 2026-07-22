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
