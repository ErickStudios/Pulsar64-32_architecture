org32 Assume-org (8D00h - $) org64
EBoot_Main:
   enter 0
   mov r4, 8
   sub sp, sp, r4
   li32 r0, bf
   li32 r1, 131072
   mwr64 r0, r1
   li32 r0, bf
   lalts64 r0
   push r0
   mov r0, 1
   push r0
   mov r0, [qword bp-0]
   add r0, r0, 40
   deref r0
   bl r0
   add sp, sp, 16
   li32 r0, 131072
   push r0
   li32 r0, baf
   deref r0
   lalts64 r0
   push r0
   li32 r0, baf
   deref r0
   add r0, r0, 8
   lalts64 r0
   push r0
   mov r0, [qword bp-0]
   add r0, r0, 48
   deref r0
   bl r0
   add sp, sp, 24
   mov r0, [qword bp-0]
   add r0, r0, 56
   deref r0
   bl r0
   add sp, sp, 0
   mov r0, [qword bp-0]
   push r0
   li32 r0, xd
   deref r0
   deref r0
   bl r0
   add sp, sp, 8
EBoot_Main__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
bf: baf: reserve 8
xd: qword bf
align 512
org32 Assume-org 0 org64
ab: dq (kernelEntry / 512)
cd: dq ((kernelEnd - kernelEntry) / 512)
align 512
org32 Assume-org (20000h - $) org64
kernelEntry:
   enter 0
   mov r4, 8
   sub sp, sp, r4
   laddr r0, msg
   push r0
   mov r0, [qword bp-0]
   add r0, r0, 8
   deref r0
   bl r0
   add sp, sp, 8
   push lnk
while_5139:
   mov r0, 1
   mov r1, 1
   cmp r2, r0, r1
   cmp r2, r2, 0 jifeq end_8488
   jmp while_5139
end_8488:
   pop lnk
kernelEntry__stdend:
   mov r4, 8
   add sp, sp, r4
   leave
   ret
msg: db 068h,065h,06ch,06ch,06fh,020h,077h,06fh,072h,06ch,064h,00h
align 512
kernelEnd:
