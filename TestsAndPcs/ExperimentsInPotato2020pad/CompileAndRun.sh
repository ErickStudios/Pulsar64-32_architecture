#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLS_PATH="$SCRIPT_DIR/../../Assembler"
Tool2In1="$TOOLS_PATH/pulsarToolchain.js"
Launch="$(command -v node)"

cp "$TOOLS_PATH/../CpuSource/BuildCpu/PackedCpu.v" "$SCRIPT_DIR/PCCore.v"

$Launch $Tool2In1 --asm    \
        "$SCRIPT_DIR/BasicContinuation.s" \
        -out "$SCRIPT_DIR/FirmwareHex.hex" -f hex
echo "DIR: $SCRIPT_DIR"
echo "Tool: $Tool2In1"
echo "Node: $Launch"

iverilog -o "$SCRIPT_DIR/machine" "$SCRIPT_DIR/PCCore.v" "$SCRIPT_DIR/machineCfg.v"
vvp "$SCRIPT_DIR/machine"
