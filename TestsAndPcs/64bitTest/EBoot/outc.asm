; CrtStruct
Table: reserve 48; Declare
entryBoot: reserve 8; Declare
main:
   enter 0
   ; ChgPrimRe
   laddr r0, Table; LoadValue
   ; Field
   ; ChgSecRe
   laddr r1, __vend; LoadValue
   lalts64 r1; Get
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, UartAddr; LoadValue
   ; ChgSecRe
   laddr r1, __uart; LoadValue
   lalts64 r1; Get
   mwr64 r0, r1; Store
   li64 r1, initdisplay; LoadFlat
bl r1
   add sp, sp, 0; Call
   laddr r1, __vend; LoadValue
   lalts64 r1; Get
   push r1
li64 r1, puts; LoadFlat
bl r1
   add sp, sp, 8; Call
   laddr r1, BootSectorLoader; LoadValue
   lalts64 r1; Get
   push r1
   li64 r1, 0; LoadFlat
   push r1
li64 r1, readDisk; LoadFlat
bl r1
   add sp, sp, 16; Call
   ; ChgPrimRe
   laddr r0, Table; LoadValue
   add r0, r0, 16; Field
   ; ChgSecRe
   li64 r1, drawPixel; LoadFlat
   mwr64 r0, r1; Store
   ; ChgPrimRe
   laddr r0, Table; LoadValue
   add r0, r0, 8; Field
   ; ChgSecRe
   li64 r1, puts; LoadFlat
   mwr64 r0, r1; Store
   ; ChgPrimRe
   laddr r0, Table; LoadValue
   add r0, r0, 24; Field
   ; ChgSecRe
   li64 r1, outPort; LoadFlat
   mwr64 r0, r1; Store
   ; ChgPrimRe
   laddr r0, Table; LoadValue
   add r0, r0, 32; Field
   ; ChgSecRe
   li64 r1, inPort; LoadFlat
   mwr64 r0, r1; Store
   ; ChgPrimRe
   laddr r0, Table; LoadValue
   add r0, r0, 40; Field
   ; ChgSecRe
   li64 r1, readDisk; LoadFlat
   mwr64 r0, r1; Store
   laddr r1, Table; LoadValue
   push r1
li64 r1, test; LoadFlat
bl r1
   add sp, sp, 8; Call
   leave
   ret; Function
drv: reserve 8; Declare
test:
   enter 0
   ; ChgPrimRe
   laddr r0, __vend; LoadValue
   lalts64 r0; Get
   push r0
mov r0, [qword bp-0]; LoadParameter
add r0, r0, 8; Field
deref r0; Desreference
bl r0
   add sp, sp, 8; Call
   leave
   ret; Function
portTmp: reserve 8; Declare
outPort:
   enter 8
   ; ChgPrimRe
   laddr r0, portTmp; LoadValue
   ; ChgSecRe
   mov r1, [qword bp-0]; LoadParameter
   ; ChgTerRe
   li64 r2, 327680; LoadFlat
   add r1, r1, r2; Add
   mwr64 r0, r1; Store
   ; ChgPrimRe
   laddr r0, portTmp; LoadValue
   deref r0; Desreference
   ; ChgSecRe
   mov r1, [qword bp-8]; LoadParameter
   mwr8 r0, r1; Store
   leave
   ret; Function
inPort:
   enter 8
   ; ChgPrimRe
   laddr r0, portTmp; LoadValue
   ; ChgSecRe
   mov r1, [qword bp-0]; LoadParameter
   ; ChgTerRe
   li64 r2, 327680; LoadFlat
   add r1, r1, r2; Add
   mwr64 r0, r1; Store
   ; ChgPrimRe
   mov r0, [qword bp-8]; LoadParameter
   ; ChgSecRe
   laddr r1, portTmp; LoadValue
   deref r1; Desreference
   lalts8 r1; Get
   mwr8 r0, r1; Store
   leave
   ret; Function
; CrtStruct
ReadDisktmpStatus: reserve 1; Declare
ReadDisktmpwaitCount: reserve 1; Declare
ReadDisktmpbuffer: reserve 8; Declare
ReadDisktmpInfo: reserve 4; Declare
ReadDiskByteReaded: reserve 1; Declare
ReadDiskTmpByteRead: reserve 2; Declare
readDisk:
   enter 8
   ; ChgPrimRe
   laddr r0, ReadDisktmpbuffer; LoadValue
   ; ChgSecRe
   mov r1, [qword bp-0]; LoadParameter
   mwr64 r0, r1; Store
   li64 r1, 672; LoadFlat
   push r1
   li64 r1, 1; LoadFlat
   push r1
li64 r1, outPort; LoadFlat
bl r1
   add sp, sp, 16; Call
   ; ChgPrimRe
   laddr r0, ReadDisktmpwaitCount; LoadValue
   ; ChgSecRe
   li64 r1, 20; LoadFlat
   mwr8 r0, r1; Store
while_3417:; Label
   ; ChgPrimRe
   laddr r0, ReadDisktmpwaitCount; LoadValue
   lalts8 r0; Get
   ; ChgSecRe
   li64 r1, 0; LoadFlat
   cmp r2, r0, r1; Compare
   cmp r2, r2, 0 jifeq end_1206; JumpFalse
   ; ChgPrimRe
   laddr r0, ReadDisktmpwaitCount; LoadValue
   ; ChgSecRe
   laddr r1, ReadDisktmpwaitCount; LoadValue
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 1; LoadFlat
   sub r1, r1, r2; Sub
   mwr8 r0, r1; Store
   jmp while_3417; Jump
end_1206:; Label
   li64 r2, 672; LoadFlat
   push r2
   laddr r2, ReadDisktmpStatus; LoadValue
   push r2
li64 r2, inPort; LoadFlat
bl r2
   add sp, sp, 16; Call
if_8287:; Label
   ; ChgPrimRe
   laddr r0, ReadDisktmpStatus; LoadValue
   lalts8 r0; Get
   ; ChgSecRe
   li64 r1, 255; LoadFlat
   cmp r2, r0, r1; Compare
   cmp r2, r2, 0 jifeq endif_2585; JumpFalse
   ; ChgPrimRe
   laddr r0, ReadDiskTmpByteRead; LoadValue
   ; ChgSecRe
   li64 r1, 0; LoadFlat
   mwr16 r0, r1; Store
while_3952:; Label
   ; ChgPrimRe
   laddr r0, ReadDiskTmpByteRead; LoadValue
   lalts16 r0; Get
   ; ChgSecRe
   li64 r1, 512; LoadFlat
   cmp r2, r0, r1; Compare
   cmp r2, r2, 0 jifeq end_777; JumpFalse
   ; ChgPrimRe
   laddr r0, ReadDisktmpInfo; LoadValue
   ; Field
   ; ChgSecRe
   mov r1, [qword bp-8]; LoadParameter
   ; ChgTerRe
   li64 r2, 8; LoadFlat
   shr r1, r1, r2; Shr
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDisktmpInfo; LoadValue
   ; Field
   ; ChgSecRe
   laddr r1, ReadDisktmpInfo; LoadValue
   ; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 255; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDisktmpInfo; LoadValue
   add r0, r0, 1; Field
   ; ChgSecRe
   mov r1, [qword bp-8]; LoadParameter
   ; ChgTerRe
   li64 r2, 255; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDisktmpInfo; LoadValue
   add r0, r0, 2; Field
   ; ChgSecRe
   laddr r1, ReadDiskTmpByteRead; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 8; LoadFlat
   shr r1, r1, r2; Shr
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDisktmpInfo; LoadValue
   add r0, r0, 2; Field
   ; ChgSecRe
   laddr r1, ReadDisktmpInfo; LoadValue
   add r1, r1, 2; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 3; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDisktmpInfo; LoadValue
   add r0, r0, 3; Field
   ; ChgSecRe
   laddr r1, ReadDiskTmpByteRead; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 255; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   li64 r2, 674; LoadFlat
   push r2
   laddr r2, ReadDisktmpInfo; LoadValue
   ; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 675; LoadFlat
   push r2
   laddr r2, ReadDisktmpInfo; LoadValue
   add r2, r2, 1; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 676; LoadFlat
   push r2
   laddr r2, ReadDisktmpInfo; LoadValue
   add r2, r2, 2; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 677; LoadFlat
   push r2
   laddr r2, ReadDisktmpInfo; LoadValue
   add r2, r2, 3; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 672; LoadFlat
   push r2
   li64 r2, 129; LoadFlat
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 672; LoadFlat
   push r2
   li64 r2, 152; LoadFlat
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 672; LoadFlat
   push r2
   li64 r2, 128; LoadFlat
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 673; LoadFlat
   push r2
   laddr r2, ReadDiskByteReaded; LoadValue
   push r2
li64 r2, inPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   ; ChgPrimRe
   laddr r0, ReadDisktmpbuffer; LoadValue
   deref r0; Desreference
   ; ChgSecRe
   laddr r1, ReadDiskByteReaded; LoadValue
   lalts8 r1; Get
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDiskTmpByteRead; LoadValue
   ; ChgSecRe
   laddr r1, ReadDiskTmpByteRead; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 1; LoadFlat
   add r1, r1, r2; Add
   mwr16 r0, r1; Store
   ; ChgPrimRe
   laddr r0, ReadDisktmpbuffer; LoadValue
   ; ChgSecRe
   laddr r1, ReadDisktmpbuffer; LoadValue
   lalts64 r1; Get
   ; ChgTerRe
   li64 r2, 1; LoadFlat
   add r1, r1, r2; Add
   mwr64 r0, r1; Store
   jmp while_3952; Jump
end_777:; Label
endif_2585:; Label
   leave
   ret; Function
UartAddr: reserve 8; Declare
putc:
   enter 0
   ; ChgPrimRe
   laddr r0, UartAddr; LoadValue
   deref r0; Desreference
   ; ChgSecRe
   mov r1, [qword bp-0]; LoadParameter
   mwr8 r0, r1; Store
   leave
   ret; Function
putstmp1: reserve 1; Declare
putstmp2: reserve 8; Declare
puts:
   enter 0
   ; ChgPrimRe
   laddr r0, putstmp2; LoadValue
   ; ChgSecRe
   mov r1, [qword bp-0]; LoadParameter
   mwr64 r0, r1; Store
while_5475:; Label
   ; ChgPrimRe
   laddr r0, putstmp2; LoadValue
   deref r0; Desreference
   lalts8 r0; Get
   ; ChgSecRe
   li64 r1, 0; LoadFlat
   cmp r2, r0, r1; Compare
   cmp r2, r2, 0 jifeq end_5368; JumpFalse
   ; ChgPrimRe
   laddr r0, putstmp1; LoadValue
   ; ChgSecRe
   laddr r1, putstmp2; LoadValue
   deref r1; Desreference
   lalts8 r1; Get
   mwr8 r0, r1; Store
   laddr r1, putstmp1; LoadValue
   lalts8 r1; Get
   push r1
li64 r1, putc; LoadFlat
bl r1
   add sp, sp, 8; Call
   ; ChgPrimRe
   laddr r0, putstmp2; LoadValue
   ; ChgSecRe
   laddr r1, putstmp2; LoadValue
   lalts64 r1; Get
   ; ChgTerRe
   li64 r2, 1; LoadFlat
   add r1, r1, r2; Add
   mwr64 r0, r1; Store
   jmp while_5475; Jump
end_5368:; Label
   leave
   ret; Function
; CrtStruct
drawPixel:
   enter 16
   li64 r0, 874; LoadFlat
   push r0
   mov r0, [qword bp-0]; LoadParameter
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   li64 r0, 875; LoadFlat
   push r0
   mov r0, [qword bp-8]; LoadParameter
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   li64 r0, 876; LoadFlat
   push r0
   mov r0, [qword bp-16]; LoadParameter
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   leave
   ret; Function
idispTmpData: reserve 1; Declare
idispIndex: reserve 2; Declare
idispCol: reserve 3; Declare
initdisplay:
   enter 0
   li64 r0, 864; LoadFlat
   push r0
   laddr r0, idispTmpData; LoadValue
   push r0
li64 r0, inPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   li64 r0, 864; LoadFlat
   push r0
   li64 r0, 0; LoadFlat
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   li64 r0, 865; LoadFlat
   push r0
   li64 r0, 255; LoadFlat
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   li64 r0, 870; LoadFlat
   push r0
   li64 r0, 255; LoadFlat
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   li64 r0, 864; LoadFlat
   push r0
   li64 r0, 1; LoadFlat
   push r0
li64 r0, outPort; LoadFlat
bl r0
   add sp, sp, 16; Call
   ; ChgPrimRe
   laddr r0, idispIndex; LoadValue
   ; ChgSecRe
   li64 r1, 0; LoadFlat
   mwr16 r0, r1; Store
while_632:; Label
   ; ChgPrimRe
   laddr r0, idispIndex; LoadValue
   lalts16 r0; Get
   ; ChgSecRe
   li64 r1, 256; LoadFlat
   cmp r2, r0, r1; Compare
   cmp r2, r2, 0 jifeq end_5919; JumpFalse
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   ; Field
   ; ChgSecRe
   laddr r1, idispIndex; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 4; LoadFlat
   shr r1, r1, r2; Shr
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   ; Field
   ; ChgSecRe
   laddr r1, idispCol; LoadValue
   ; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 3; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   add r0, r0, 1; Field
   ; ChgSecRe
   laddr r1, idispIndex; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 2; LoadFlat
   shr r1, r1, r2; Shr
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   add r0, r0, 1; Field
   ; ChgSecRe
   laddr r1, idispCol; LoadValue
   add r1, r1, 1; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 3; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   add r0, r0, 2; Field
   ; ChgSecRe
   laddr r1, idispIndex; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 3; LoadFlat
   and r1, r1, r2; And
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   ; Field
   ; ChgSecRe
   laddr r1, idispCol; LoadValue
   ; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 64; LoadFlat
   mul r1, r1, r2; Mul
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   add r0, r0, 2; Field
   ; ChgSecRe
   laddr r1, idispCol; LoadValue
   add r1, r1, 2; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 64; LoadFlat
   mul r1, r1, r2; Mul
   mwr8 r0, r1; Store
   ; ChgPrimRe
   laddr r0, idispCol; LoadValue
   add r0, r0, 1; Field
   ; ChgSecRe
   laddr r1, idispCol; LoadValue
   add r1, r1, 1; Field
   lalts8 r1; Get
   ; ChgTerRe
   li64 r2, 64; LoadFlat
   mul r1, r1, r2; Mul
   mwr8 r0, r1; Store
   li64 r2, 866; LoadFlat
   push r2
   laddr r2, idispIndex; LoadValue
   lalts16 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 867; LoadFlat
   push r2
   laddr r2, idispCol; LoadValue
   ; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 868; LoadFlat
   push r2
   laddr r2, idispCol; LoadValue
   add r2, r2, 1; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 869; LoadFlat
   push r2
   laddr r2, idispCol; LoadValue
   add r2, r2, 2; Field
   lalts8 r2; Get
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   li64 r2, 864; LoadFlat
   push r2
   li64 r2, 2; LoadFlat
   push r2
li64 r2, outPort; LoadFlat
bl r2
   add sp, sp, 16; Call
   ; ChgPrimRe
   laddr r0, idispIndex; LoadValue
   ; ChgSecRe
   laddr r1, idispIndex; LoadValue
   lalts16 r1; Get
   ; ChgTerRe
   li64 r2, 1; LoadFlat
   add r1, r1, r2; Add
   mwr16 r0, r1; Store
   jmp while_632; Jump
end_5919:; Label
   ; ChgPrimRe
   li64 r0, 0; LoadFlat
   leave
   ret; ExitFunction
   leave
   ret; Function
