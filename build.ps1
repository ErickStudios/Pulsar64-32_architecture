Get-Content arch/motherboard/device.v   >   arch/cpu.v
Get-Content arch/components/alu.v       >>  arch/cpu.v
Get-Content arch/arch.v                 >>  arch/cpu.v

node assembler/pulsarAsm.js tests/liteCap.s tests/lc.dec -d