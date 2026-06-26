node ../../assembler/pulsarAsm.js test.S program.hex
iverilog -o cpu cpu.v tb.v
vvp cpu > pulsar32PcLog.log