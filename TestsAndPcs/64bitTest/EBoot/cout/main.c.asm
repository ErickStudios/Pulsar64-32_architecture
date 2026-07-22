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
