#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

$SHELL "$SCRIPT_DIR/CpuSource/LinkCpu.sh"
