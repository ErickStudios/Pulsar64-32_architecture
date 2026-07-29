
npx esbuild "$PSScriptRoot/Assembler/Pulsar3264toolchain.js" --bundle --platform=node --format=esm "--outfile=$PSScriptRoot/Assembler/pulsarToolchain.js"

& "$PSScriptRoot/CpuSource/LinkCpu.ps1"

& "$PSScriptRoot/TestsAndPcs/pulsar5024XM_x32/build.ps1"
& "$PSScriptRoot/TestsAndPcs/64bitTest/build.ps1"

node "$PSScriptRoot/Assembler/pulsarToolchain.js" `
    --asm                                        `
        "$PSScriptRoot/tests/scratch1.s"        `
    -out "$PSScriptRoot/tests/scratch1.dec" -f decimal