cat arch/motherboard/device.v   >   arch/cpu.v
cat arch/cpu/generalRegisters.v >>  arch/cpu.v
cat arch/cpu/managment.v        >>  arch/cpu.v
cat arch/cpu/modes.v            >>  arch/cpu.v
cat arch/arch.v                 >>  arch/cpu.v

iverilog -o cpu arch/cpu.v