Table: reserve 64
ent: reserve 8
activeDebug:
   enter 0
   mov r4, 8
   sub sp, sp, r4
   mov r0, 32
   push r0
   mov r0, 1
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
activeDebug__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
entryBoot: reserve 8
main:
   enter 0
   mov r4, 8
   sub sp, sp, r4
   laddr r0, Table
   laddr r1, __vend
   lalts64 r1
   mwr8 r0, r1
   laddr r0, UartAddr
   laddr r1, __uart
   lalts64 r1
   mwr64 r0, r1
   li64 r1, initdisplay
   bl r1
   add sp, sp, 0
   laddr r1, __vend
   lalts64 r1
   push r1
   li64 r1, puts
   bl r1
   add sp, sp, 8
   laddr r1, BootSectorLoader
   lalts64 r1
   push r1
   mov r1, 0
   push r1
   li64 r1, readDisk
   bl r1
   add sp, sp, 16
   laddr r0, Table
   add r0, r0, 16
   li64 r1, drawPixel
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 8
   li64 r1, puts
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 24
   li64 r1, outPort
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 32
   li64 r1, inPort
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 40
   li64 r1, readDisk
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 48
   li64 r1, readSects
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 56
   li64 r1, activeDebug
   mwr64 r0, r1
   laddr r0, ent
   laddr r1, BootSectorLoader
   lalts64 r1
   mwr64 r0, r1
   laddr r0, Table
   push r0
   laddr r0, ent
   deref r0
   bl r0
   add sp, sp, 8
main__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
drv: reserve 8
test:
   enter 0
   mov r4, 8
   sub sp, sp, r4
test__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
outPort:
   enter 8
   mov r4, 16
   sub sp, sp, r4
   mov r0, 40
   sub r0, bp, r0
   mov r1, [qword bp-0]
   li32 r2, 327680
   add r1, r1, r2
   mwr64 r0, r1
   mov r0, 40
   sub r0, bp, r0
   deref r0
   mov r1, [qword bp-8]
   mwr8 r0, r1
outPort__stdend:
   mov r4, 16
   add sp, sp, r4
   leave
   ret
inPort:
   enter 8
   mov r4, 16
   sub sp, sp, r4
   mov r0, 40
   sub r0, bp, r0
   mov r1, [qword bp-0]
   li32 r2, 327680
   add r1, r1, r2
   mwr64 r0, r1
   mov r0, [qword bp-8]
   mov r1, 40
   sub r1, bp, r1
   deref r1
   lalts8 r1
   mwr8 r0, r1
inPort__stdend:
   mov r4, 16
   add sp, sp, r4
   leave
   ret
readDisk:
   enter 8
   mov r4, 41
   sub sp, sp, r4
   mov r0, 57
   sub r0, bp, r0
   mov r1, [qword bp-8]
   mwr64 r0, r1
   mov r0, 42
   sub r0, bp, r0
   mov r1, [qword bp-0]
   mwr64 r0, r1
   li16 r1, 672
   push r1
   mov r1, 1
   push r1
   li64 r1, outPort
   bl r1
   add sp, sp, 16
   mov r0, 34
   sub r0, bp, r0
   mov r1, 20
   mwr8 r0, r1
   push lnk
while_3742:
   mov r0, 34
   sub r0, bp, r0
   lalts8 r0
   mov r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_4236
   mov r0, 34
   sub r0, bp, r0
   mov r1, 34
   sub r1, bp, r1
   lalts8 r1
   mov r2, 1
   sub r1, r1, r2
   mwr8 r0, r1
   jmp while_3742
end_4236:
   pop lnk
   li16 r2, 672
   push r2
   mov r2, 33
   sub r2, bp, r2
   push r2
   li64 r2, inPort
   bl r2
   add sp, sp, 16
if_3092:
   mov r0, 33
   sub r0, bp, r0
   lalts8 r0
   mov r1, 255
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq endif_9869
   mov r0, 49
   sub r0, bp, r0
   mov r1, 0
   mwr16 r0, r1
   push lnk
while_6803:
   mov r0, 49
   sub r0, bp, r0
   lalts16 r0
   li16 r1, 512
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_2295
   mov r0, 46
   sub r0, bp, r0
   mov r1, 57
   sub r1, bp, r1
   lalts64 r1
   mov r2, 8
   shr r1, r1, r2
   mwr8 r0, r1
   mov r0, 46
   sub r0, bp, r0
   mov r1, 46
   sub r1, bp, r1
   lalts8 r1
   mov r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   mov r0, 46
   sub r0, bp, r0
   add r0, r0, 1
   mov r1, 57
   sub r1, bp, r1
   lalts64 r1
   mov r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   mov r0, 46
   sub r0, bp, r0
   add r0, r0, 2
   mov r1, 49
   sub r1, bp, r1
   lalts16 r1
   mov r2, 8
   shr r1, r1, r2
   mwr8 r0, r1
   mov r0, 46
   sub r0, bp, r0
   add r0, r0, 2
   mov r1, 46
   sub r1, bp, r1
   add r1, r1, 2
   lalts8 r1
   mov r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   mov r0, 46
   sub r0, bp, r0
   add r0, r0, 3
   mov r1, 49
   sub r1, bp, r1
   lalts16 r1
   mov r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   li16 r2, 674
   push r2
   mov r2, 46
   sub r2, bp, r2
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 675
   push r2
   mov r2, 46
   sub r2, bp, r2
   add r2, r2, 1
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 676
   push r2
   mov r2, 46
   sub r2, bp, r2
   add r2, r2, 2
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 677
   push r2
   mov r2, 46
   sub r2, bp, r2
   add r2, r2, 3
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 672
   push r2
   mov r2, 129
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 672
   push r2
   mov r2, 152
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 672
   push r2
   mov r2, 128
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 673
   push r2
   mov r2, 47
   sub r2, bp, r2
   push r2
   li64 r2, inPort
   bl r2
   add sp, sp, 16
   mov r0, 42
   sub r0, bp, r0
   deref r0
   mov r1, 47
   sub r1, bp, r1
   lalts8 r1
   mwr8 r0, r1
   mov r0, 49
   sub r0, bp, r0
   mov r1, 49
   sub r1, bp, r1
   lalts16 r1
   mov r2, 1
   add r1, r1, r2
   mwr16 r0, r1
   mov r0, 42
   sub r0, bp, r0
   mov r1, 42
   sub r1, bp, r1
   lalts64 r1
   mov r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_6803
end_2295:
   pop lnk
endif_9869:
readDisk__stdend:
   mov r4, 41
   add sp, sp, r4
   leave
   ret
readSects:
   enter 16
   mov r4, 32
   sub sp, sp, r4
   mov r0, 48
   sub r0, bp, r0
   mov r1, [qword bp-0]
   mwr64 r0, r1
   mov r0, 56
   sub r0, bp, r0
   mov r1, [qword bp-16]
   mwr64 r0, r1
   mov r0, 64
   sub r0, bp, r0
   mov r1, [qword bp-8]
   mwr64 r0, r1
   push lnk
while_1116:
   mov r0, 56
   sub r0, bp, r0
   lalts64 r0
   mov r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_4127
   mov r1, 48
   sub r1, bp, r1
   lalts64 r1
   push r1
   mov r1, 64
   sub r1, bp, r1
   lalts64 r1
   push r1
   li64 r1, readDisk
   bl r1
   add sp, sp, 16
   mov r0, 64
   sub r0, bp, r0
   mov r1, 64
   sub r1, bp, r1
   lalts64 r1
   mov r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   mov r0, 56
   sub r0, bp, r0
   mov r1, 56
   sub r1, bp, r1
   lalts64 r1
   mov r2, 1
   sub r1, r1, r2
   mwr64 r0, r1
   mov r0, 48
   sub r0, bp, r0
   mov r1, 48
   sub r1, bp, r1
   lalts64 r1
   li16 r2, 512
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_1116
end_4127:
   pop lnk
readSects__stdend:
   mov r4, 32
   add sp, sp, r4
   leave
   ret
UartAddr: reserve 8
putc:
   enter 0
   mov r4, 8
   sub sp, sp, r4
   laddr r0, UartAddr
   deref r0
   mov r1, [qword bp-0]
   mwr8 r0, r1
putc__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
puts:
   enter 0
   mov r4, 16
   sub sp, sp, r4
   mov r0, 32
   sub r0, bp, r0
   mov r1, [qword bp-0]
   mwr64 r0, r1
   push lnk
while_1429:
   mov r0, 32
   sub r0, bp, r0
   deref r0
   lalts8 r0
   mov r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_6974
   mov r1, 32
   sub r1, bp, r1
   deref r1
   lalts8 r1
   push r1
   li64 r1, putc
   bl r1
   add sp, sp, 8
   mov r0, 32
   sub r0, bp, r0
   mov r1, 32
   sub r1, bp, r1
   lalts64 r1
   mov r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_1429
end_6974:
   pop lnk
puts__stdend:
   mov r4, 16
   add sp, sp, r4
   leave
   ret
drawPixel:
   enter 16
   mov r4, 8
   sub sp, sp, r4
   li16 r0, 874
   push r0
   mov r0, [qword bp-0]
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
   li16 r0, 875
   push r0
   mov r0, [qword bp-8]
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
   li16 r0, 876
   push r0
   mov r0, [qword bp-16]
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
drawPixel__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
initdisplay:
   enter 0
   mov r4, 14
   sub sp, sp, r4
   li16 r0, 864
   push r0
   mov r0, 20
   sub r0, bp, r0
   push r0
   li64 r0, inPort
   bl r0
   add sp, sp, 16
   li16 r0, 864
   push r0
   mov r0, 0
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
   li16 r0, 865
   push r0
   mov r0, 255
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
   li16 r0, 870
   push r0
   mov r0, 255
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
   li16 r0, 864
   push r0
   mov r0, 1
   push r0
   li64 r0, outPort
   bl r0
   add sp, sp, 16
   mov r0, 22
   sub r0, bp, r0
   mov r1, 0
   mwr16 r0, r1
   push lnk
while_3181:
   mov r0, 22
   sub r0, bp, r0
   lalts16 r0
   li16 r1, 256
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_2847
   mov r0, 19
   sub r0, bp, r0
   mov r1, 22
   sub r1, bp, r1
   lalts16 r1
   mov r2, 4
   shr r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   mov r1, 19
   sub r1, bp, r1
   lalts8 r1
   mov r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   add r0, r0, 1
   mov r1, 22
   sub r1, bp, r1
   lalts16 r1
   mov r2, 2
   shr r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   add r0, r0, 1
   mov r1, 19
   sub r1, bp, r1
   add r1, r1, 1
   lalts8 r1
   mov r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   add r0, r0, 2
   mov r1, 22
   sub r1, bp, r1
   lalts16 r1
   mov r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   mov r1, 19
   sub r1, bp, r1
   lalts8 r1
   mov r2, 64
   mul r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   add r0, r0, 2
   mov r1, 19
   sub r1, bp, r1
   add r1, r1, 2
   lalts8 r1
   mov r2, 64
   mul r1, r1, r2
   mwr8 r0, r1
   mov r0, 19
   sub r0, bp, r0
   add r0, r0, 1
   mov r1, 19
   sub r1, bp, r1
   add r1, r1, 1
   lalts8 r1
   mov r2, 64
   mul r1, r1, r2
   mwr8 r0, r1
   li16 r2, 866
   push r2
   mov r2, 22
   sub r2, bp, r2
   lalts16 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 867
   push r2
   mov r2, 19
   sub r2, bp, r2
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 868
   push r2
   mov r2, 19
   sub r2, bp, r2
   add r2, r2, 1
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 869
   push r2
   mov r2, 19
   sub r2, bp, r2
   add r2, r2, 2
   lalts8 r2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   li16 r2, 864
   push r2
   mov r2, 2
   push r2
   li64 r2, outPort
   bl r2
   add sp, sp, 16
   mov r0, 22
   sub r0, bp, r0
   mov r1, 22
   sub r1, bp, r1
   lalts16 r1
   mov r2, 1
   add r1, r1, r2
   mwr16 r0, r1
   jmp while_3181
end_2847:
   pop lnk
   mov r0, 0
   jmp initdisplay__stdend
initdisplay__stdend:
   mov r4, 14
   add sp, sp, r4
   leave
   ret
