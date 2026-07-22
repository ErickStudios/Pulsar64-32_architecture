$ProjectDir ="$PSScriptRoot/../../.."
$AsmTools   ="$ProjectDir/Assembler"
$Assembler  ="$AsmTools/PulsarAssembly.js"
$CCompiler  ="$AsmTools/Pulsar64C.js"
$Launcher   ="node"
$CFiles     ="$PSScriptRoot/c"
$COutsf     ="$PSScriptRoot/cout"

function CompileFile($file) {
    & $Launcher $CCompiler "$CFiles/$file" "$COutsf/$file.asm"
}

CompileFile "main.c"
CompileFile "io.c"
CompileFile "disk.c"
CompileFile "dbgcon.c"
CompileFile "display.c"

$utf8 = New-Object System.Text.UTF8Encoding($false)

$boot = Get-Content "$PSScriptRoot/asm/boot.asm" -Raw
$code = Get-Content "$COutsf/main.c.asm" -Raw
$code = $code + (Get-Content "$COutsf/io.c.asm" -Raw)
$code = $code + (Get-Content "$COutsf/disk.c.asm" -Raw)
$code = $code + (Get-Content "$COutsf/dbgcon.c.asm" -Raw)
$code = $code + (Get-Content "$COutsf/display.c.asm" -Raw)

$bottom = Get-Content "$PSScriptRoot/asm/bottom.asm" -Raw

[System.IO.File]::WriteAllText(
    "$PSScriptRoot/out.asm",
    $boot + $code + $bottom,
    $utf8
)

& $Launcher $Assembler "$PSScriptRoot/out.asm" "$PSScriptRoot/out.fd" -rbin