$ProjectDir ="$PSScriptRoot/../../.."
$AsmTools   ="$ProjectDir/Assembler"
$Assembler  ="$AsmTools/PulsarAssembly.js"
$CCompiler  ="$AsmTools/Pulsar64C.js"
$Launcher   ="node"
$CFiles     ="$PSScriptRoot/c"
$COutsf     ="$PSScriptRoot/cout"

#             "$CFiles/lib/protoa.c"          `
function Ata {
& $Launcher "$AsmTools/pulsarToolchain.js" `
        --c                                 `
            "$CFiles/main.c"                `
            "$CFiles/io.c"                  `
            "$CFiles/disk.c"                `
            "$CFiles/dbgcon.c"              `
            "$CFiles/display.c"             `
            -out "$PSScriptRoot/outc.asm"   `
        --c                                 `
            "$CFiles/tests/bootstrap.c"     `
            -out "$PSScriptRoot/outc2.asm"  `
        --asm                               `
            "$PSScriptRoot/asm/boot.asm"    `
            "$PSScriptRoot/outc.asm"        `
            "$PSScriptRoot/asm/bottom.asm"  `
            -out "$PSScriptRoot/out.fd"     `
            -f flat                         `
        --asm                               `
            "$PSScriptRoot/outc2.asm"       `
            -out "$PSScriptRoot/../test.img"`
            -f flat
}

& $Launcher "$AsmTools/pulsarToolchain.js" `
        --asm                               `
            "$PSScriptRoot/outc2.asm"       `
            -out "$PSScriptRoot/../test.img"`
            -f flat

Ata