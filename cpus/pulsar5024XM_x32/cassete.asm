Assume-Org              0x4FFF          ; donde el bios guarda el codigo del bootsector

VECTORS_DIR             Equ 0x1F0       ; direccion de los vectors
PRINT_FNC_PTR           Equ 0x1F2       ; puntero al puntero de la funcion de mensaje

_start:
    Jmp-Word-Clasic     _l              ; jump label
Assume-Fill             8               ; alinear

oem_label:
    Assume-Byte         'C','A','S','S','E','T','E','0',' ',' ',' ',' '
_info:
    Assume-Dword        1               ; cantidad de sectores
    Assume-Byte         'F','L','A','T','2',' ',' ',' ' ; nombre del fs

_l:
    Lea-Word            PRINT_FNC_PTR   ; el print func
    Mov-Word                            ; obtener el byte
    Lea-Word            msg             ; la frase
    Jmp-Dword-Call      Out             ; saltar
    Hlt                                 ; ta tada ta, ta tada!

msg:
    Assume-Byte         'C','A','S','S','E','T','E','0',0

_end:
    Assume-Fill         510             ; llenar a 510
    Assume-Byte         'O','K'