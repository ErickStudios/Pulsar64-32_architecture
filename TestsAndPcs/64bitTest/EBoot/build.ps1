$ProjectDir ="$PSScriptRoot/../../.."
$AsmTools   ="$ProjectDir/Assembler"
$Assembler  ="$AsmTools/PulsarAssembly.js"
$CCompiler  ="$AsmTools/Pulsar64C.js"
$Launcher   ="node"
$CFiles     ="$PSScriptRoot/c"
$COutsf     ="$PSScriptRoot/cout"

& $Launcher "$AsmTools/pulsarToolchain.js" `
        --c                                 `
            "$CFiles/main.c"                `
            "$CFiles/io.c"                  `
            "$CFiles/disk.c"                `
            "$CFiles/dbgcon.c"              `
            "$CFiles/display.c"             `
            -out "$PSScriptRoot/outc.asm"   `
        --asm                               `
            "$PSScriptRoot/asm/boot.asm"    `
            "$PSScriptRoot/outc.asm"        `
            "$PSScriptRoot/asm/bottom.asm"  `
            -out "$PSScriptRoot/out.fd"     `
            -f flat