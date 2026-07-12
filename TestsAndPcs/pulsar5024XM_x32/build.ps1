# compilacion
node "$PSScriptRoot/../../Assembler/PulsarAssembly.js" "$PSScriptRoot/firmware.S" "$PSScriptRoot/program.hex"
node "$PSScriptRoot/../../Assembler/PulsarAssembly.js" "$PSScriptRoot/cassete.asm" "$PSScriptRoot/mmbootfs.hex"

# compilar verilog
iverilog -o "$PSScriptRoot/cpu" "$PSScriptRoot/cpu.v" "$PSScriptRoot/tb.v"

#C:\Users\erick\AppData\Local\Programs\Python\Python314\python.exe ../../p32vm.py -pc pulsar5024XM_x32 -mx > com1.txt