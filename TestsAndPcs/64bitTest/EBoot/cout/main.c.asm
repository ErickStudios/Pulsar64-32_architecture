Table: reserve 48
entryBoot: reserve 8
main:
   enter 0
   laddr r0, Table
   laddr r1, __vend
   lalts64 r1
   mwr8 r0, r1
   laddr r0, UartAddr
   laddr r1, __uart
   lalts64 r1
   mwr64 r0, r1
   bl initdisplay
   add sp, sp, 0
   laddr r1, __vend
   lalts64 r1
   push r1
   bl puts
   add sp, sp, 8
   laddr r1, BootSectorLoader
   lalts64 r1
   push r1
   li64 r1, 0
   push r1
   bl readDisk
   add sp, sp, 16
   laddr r0, Table
   add r0, r0, 16
   laddr r1, drawPixel
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 8
   laddr r1, puts
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 24
   laddr r1, outPort
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 32
   laddr r1, inPort
   mwr64 r0, r1
   laddr r0, Table
   add r0, r0, 40
   laddr r1, readDisk
   mwr64 r0, r1
   laddr r0, entryBoot
   laddr r1, BootSectorLoader
   lalts64 r1
   mwr64 r0, r1
   laddr lnk, entryBoot lalts64 lnk bl lnk
   leave
   ret
