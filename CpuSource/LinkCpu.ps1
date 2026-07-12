# Variables Del Script
$out = Join-Path $PSScriptRoot "BuildCpu/PackedCpu.v"

# Unir los archivos principales del CPU
Get-Content (Join-Path $PSScriptRoot "CompatibleExtenders/DeviceIrqLauncher.v") >  $out
Get-Content (Join-Path $PSScriptRoot "ExternalChips/AluIsa32.v")                >> $out
Get-Content (Join-Path $PSScriptRoot "ChipExternal.v")                          >> $out