ReadDisktmpStatus: reserve 1
ReadDisktmpwaitCount: reserve 1
ReadDisktmpbuffer: reserve 8
ReadDisktmpInfo: reserve 4
ReadDiskByteReaded: reserve 1
ReadDiskTmpByteRead: reserve 2
readDisk:
   enter 8
   laddr r0, ReadDisktmpbuffer
   mov r1, [qword bp-0]
   mwr64 r0, r1
   li64 r1, 672
   push r1
   li64 r1, 1
   push r1
   bl outPort
   add sp, sp, 16
   laddr r0, ReadDisktmpwaitCount
   li64 r1, 20
   mwr8 r0, r1
while_9265:
   laddr r0, ReadDisktmpwaitCount
   lalts8 r0
   li64 r1, 0
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_5711
   laddr r0, ReadDisktmpwaitCount
   laddr r1, ReadDisktmpwaitCount
   lalts8 r1
   li64 r2, 1
   sub r1, r1, r2
   mwr8 r0, r1
   jmp while_9265
end_5711:
   li64 r2, 672
   push r2
   laddr r2, ReadDisktmpStatus
   push r2
   bl inPort
   add sp, sp, 16
if_6551:
   laddr r0, ReadDisktmpStatus
   lalts8 r0
   li64 r1, 255
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq endif_9690
   laddr r0, ReadDiskTmpByteRead
   li64 r1, 0
   mwr16 r0, r1
while_5755:
   laddr r0, ReadDiskTmpByteRead
   lalts16 r0
   li64 r1, 512
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_3121
   laddr r0, ReadDisktmpInfo
   mov r1, [qword bp-8]
   li64 r2, 8
   shr r1, r1, r2
   mwr8 r0, r1
   laddr r0, ReadDisktmpInfo
   laddr r1, ReadDisktmpInfo
   lalts8 r1
   li64 r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   laddr r0, ReadDisktmpInfo
   add r0, r0, 1
   mov r1, [qword bp-8]
   li64 r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   laddr r0, ReadDisktmpInfo
   add r0, r0, 2
   laddr r1, ReadDiskTmpByteRead
   lalts16 r1
   li64 r2, 8
   shr r1, r1, r2
   mwr8 r0, r1
   laddr r0, ReadDisktmpInfo
   add r0, r0, 2
   laddr r1, ReadDisktmpInfo
   add r1, r1, 2
   lalts8 r1
   li64 r2, 3
   and r1, r1, r2
   mwr8 r0, r1
   laddr r0, ReadDisktmpInfo
   add r0, r0, 3
   laddr r1, ReadDiskTmpByteRead
   lalts16 r1
   li64 r2, 255
   and r1, r1, r2
   mwr8 r0, r1
   li64 r2, 674
   push r2
   laddr r2, ReadDisktmpInfo
   lalts8 r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 675
   push r2
   laddr r2, ReadDisktmpInfo
   add r2, r2, 1
   lalts8 r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 676
   push r2
   laddr r2, ReadDisktmpInfo
   add r2, r2, 2
   lalts8 r2
   push r2
   bl outPort
   add sp, sp, 16
   li64 r2, 677
   push r2
   laddr r2, ReadDisktmpInfo
   add r2, r2, 3
   lalts8 r2
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
   laddr r2, ReadDiskByteReaded
   push r2
   bl inPort
   add sp, sp, 16
   laddr r0, ReadDisktmpbuffer
   deref r0
   laddr r1, ReadDiskByteReaded
   lalts8 r1
   mwr8 r0, r1
   laddr r0, ReadDiskTmpByteRead
   laddr r1, ReadDiskTmpByteRead
   lalts16 r1
   li64 r2, 1
   add r1, r1, r2
   mwr16 r0, r1
   laddr r0, ReadDisktmpbuffer
   laddr r1, ReadDisktmpbuffer
   lalts64 r1
   li64 r2, 1
   add r1, r1, r2
   mwr64 r0, r1
   jmp while_5755
end_3121:
endif_9690:
   leave
   ret
