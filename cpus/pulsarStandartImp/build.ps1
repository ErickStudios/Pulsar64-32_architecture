node ../../assembler/pulsarAsm.js ../../js/firmware.S program.hex  
iverilog -o cpu cpu.v tb.v
vvp cpu