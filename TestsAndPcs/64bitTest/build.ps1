& "$PSScriptRoot/EBoot/build.ps1"

node "$PSScriptRoot/../../Assembler/PulsarAssembly.js" "$PSScriptRoot/test.S" "$PSScriptRoot/program.hex"
iverilog -o "$PSScriptRoot/cpu" "$PSScriptRoot/cpu.v" "$PSScriptRoot/tb.v"
#vvp "$PSScriptRoot/cpu" > "$PSScriptRoot/pulsar32PcLog.log"