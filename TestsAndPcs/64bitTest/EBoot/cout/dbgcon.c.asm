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
