node ../../assembler/pulsarAsm.js ../../assembler/firmware.S program.hex  
iverilog -o cpu cpu.v tb.v
vvp cpu > pulsar32PcLog.log