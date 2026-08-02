#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$SCRIPT_DIR/BuildCpu/PackedCpu.v"

cat "$SCRIPT_DIR/CompatibleExtenders/DeviceIrqLauncher.v" > $out
printf "\n\n " >> $out
cat "$SCRIPT_DIR/ExternalChips/AluIsa32.v" >> $out
printf "\n\n" >> $out
cat "$SCRIPT_DIR/ChipExternal.v" >> $out
