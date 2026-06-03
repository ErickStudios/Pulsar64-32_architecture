; =====================================
;       BOOTSECTOR CODE
;
; el codigo de inicio del disco
; =====================================

Assume-Org              0x4FFF          ; donde el bios guarda el codigo del bootsector

; =================== rutinas del firmware ===================
PRINT_FNC_PTR           Equ 0x1F2       ; puntero al puntero de la funcion de mensaje
MEMCPY_FNC_PTR          Equ 0x1F4       ; puntero al puntero de la funcion de memcpy
L_LBA_SECTOR_FUNC_PTR   Equ 0x1F6       ; puntero al puntero de la funcion de loadSectorLBA

; =================== cargador de sectores ===================
LOADED_SECTOR_ADDR      Equ 0x4FFF      ; donde inicia el sector
LLBASEC_SECT_PTR        Equ 29197       ; el parametro de funcion de no se que

; =================== parametros de memcpy ===================
MEMCPY_SRC_PTR          Equ 29184       ; source
MEMCPY_DST_PTR          Equ 29188       ; destino
MEMCPY_SIZ_PTR          Equ 29192       ; source

; =================== variables para el stage2 ===================
SECTOR_READ_MMIO        Equ 64010       ; sector mmio
SAFE_ZONE_STAGE2        Equ 95001       ; zona segura para el stage2

; =================== tabla de particion ===================
_start:
    Jmp-Word-Clasic     _l              ; jump label
    Assume-Fill         8               ; alinear
    Assume-Byte         'C','A','S','S','E','T','E','0',' ',' ',' ',' '
    Assume-Dword        0               ; cantidad de sectores, 0=indefinido
    Assume-Byte         'F','L','A','T','2',' ',' ',' ' ; nombre del fs

; =================== codigo fuente ===================
_l:
    ; imprimir identificador
    Lea-Word            PRINT_FNC_PTR   ; el print func
    Mov-Word                            ; obtener el byte
    Lea-Word            msg             ; la frase
    Jmp-Dword-Call      Out             ; saltar
    
    ; copiar el sector
    Lea-Word            MEMCPY_SRC_PTR  ; direccion
    Out-Dword           0x4FFF          ; fuente
    Lea-Word            MEMCPY_DST_PTR  ; direccion
    Out-Dword           SAFE_ZONE_STAGE2; destino
    Lea-Word            MEMCPY_SIZ_PTR  ; direccion
    Out-Dword           512             ; tamaño
    Lea-Word            MEMCPY_FNC_PTR  ; copiar
    Mov-Word                            ; obtener el byte
    Lea-Word            msg             ; la frase
    Jmp-Dword-Call      Out             ; saltar
    Jmp-Dword-Clasic    [C1 In SAFE_ZONE_STAGE2] ; saltar
C1:
    ; leer sector
    Lea-Dword           LLBASEC_SECT_PTR; el sector
    Out-Word            1               ; sector 1
    Lea-Word            L_LBA_SECTOR_FUNC_PTR ; copiar
    Mov-Word                            ; obtener el byte
    Jmp-Dword-Call      Out             ; saltar
    Jmp-Dword-Clasic    [ SECTOR2_CODE Out SECTOR2 ] ; sector2
    
msg:
    Assume-Byte         'm','m','f','s','0',0

; =================== final del sector ===================
_end:
    Assume-Fill         510             ; llenar a 510
    Assume-Byte         'O','K'

; =====================================
;       STAGE2 CODE
;
; el codigo de la etapa 2 del arranque
; del disco
; =====================================

SECTOR2:
test:
    Assume-Byte 'm','m','f','s','1',0
SECTOR2_CODE:
    ; imprimir identificador
    Lea-Word            PRINT_FNC_PTR   ; el print func
    Mov-Word                            ; obtener el byte
    Lea-Dword           [test Out SECTOR2] ; la frase
    Jmp-Dword-Call      Out             ; saltar
    Hlt