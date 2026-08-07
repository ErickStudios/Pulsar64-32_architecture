#!/bin/sh
FILE="DrvBus164302.hex"
TMP="${FILE}.tmp"

# Inicializa en FF
printf "ff\n00\n" > "$FILE"

echo "hk BD X1-64302 listo, ',' para salir" >&2
stty -echo -icanon min 1 time 0
trap 'stty sane; exit' INT TERM EXIT

ID=0
while true; do
  CHAR=$(dd if=/dev/tty bs=1 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n')
  [ -z "$CHAR" ] && continue

  # ',' = salir (2c)
  if [ "$CHAR" = "2c" ]; then
    stty sane
    echo "saliendo" >&2
    exit 0
  fi

  # enter = 0a, espacio = 20, etc. Pasalo directo como hex
  ID=$(( (ID + 1) & 255 ))
  if [ $ID -eq 255 ]; then ID=1; fi

  printf "%02x\n%s\n" $ID $CHAR > "$TMP"
  mv "$TMP" "$FILE"

  # espera a que Verilog lo consuma y lo ponga en FF
  # tu Verilog debe poner FF
 done
