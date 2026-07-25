UartAddr: reserve 8
putc:
   enter 0
   laddr r0, UartAddr
   deref r0
   mov r1, [qword bp-0]
   mwr8 r0, r1
   leave
   ret
putstmp1: reserve 1
putstmp2: reserve 8
puts:
   enter 0
   laddr r0, putstmp2
   mov r1, [qword bp-0]
   mwr64 r0, r1
while_565:
   laddr r0, putstmp2
   deref r0
   lalts8 r0
   li64 r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_7898
   laddr r0, putstmp1
   laddr r1, putstmp2
   deref r1
   lalts8 r1
   mwr8 r0, r1
   laddr r1, putstmp1
   lalts8 r1
   push r1
   bl putc
   add sp, sp, 8
   laddr r0, putstmp2
   laddr r1, putstmp2
   lalts64 r1
   li64 r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_565
end_7898:
   leave
   ret
