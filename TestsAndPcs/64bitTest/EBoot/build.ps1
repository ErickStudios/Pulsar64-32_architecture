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
$utf8 = New-Object System.Text.UTF8Encoding($false)

$boot = Get-Content "$PSScriptRoot/asm/boot.asm" -Raw
$code = Get-Content "$COutsf/main.c.asm" -Raw

[System.IO.File]::WriteAllText(
    "$PSScriptRoot/out.asm",
    $boot + $code,
    $utf8
)

& $Launcher $Assembler "$PSScriptRoot/out.asm" "$PSScriptRoot/out.fd" -rbin