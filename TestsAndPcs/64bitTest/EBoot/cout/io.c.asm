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
