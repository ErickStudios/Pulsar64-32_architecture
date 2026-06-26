; ===========================================
;       FIRMWARE BY MARKARIAN AND THE
;       PULSAR PROJECT FOR MACHINE
;       'pulsar 5024XM x32 PC'
;
; firmware para la maquina pulsar5024XM de 32 
; bits
;
; ===========================================

Assume-Org          0

SERIAL_MODE_SWITCH  Equ  0x01

; ===========================================
;  VECTORS & FUNCS
;
; vectors de dispositivos, funciones, ints
; irqs, de reset, etc
;
; ===========================================

; ===========================================
; puntero a la funcion que se ejecuta cuando
; el cpu inicia, no es de la pc es del cpu
; en general
;
_reset_vector:      Dword _init

; ===========================================
; vectores de dispositivos y sus irqs que
; los atienden cada vez que lo requieren
;
_devices_vector:
    ; 00h-0Fh
    Dword           alpha_button_irq ; vector del boton 'A' o mas conocido como Alpha
    Dword           beta_button_irq ; vector del boton 'B' o mas conocido como Beta
    Dword           up_button_irq ; vector del boton 'Up'
    Dword           down_button_irq ; vector del boton 'Down'
    Dword           cassete_irq ; vector del dispositivo de la disquetera de cartuchos del mmfs0 (mounted/maped FileSystem 0)
    Dword           INT5_irq ; controlador de teclado
    Dword           0,0,0,0,0,0,0,0,0,0
    ; 10h-20h
    Dword           VideoServices ; putchar para imprimir un caracter
    Dword           put_msg ; print para imprimir un texto
    Dword           DiskServices ; servicios de disquete
    Dword           memcpy  ; memory copping para copiar un bloque de memoria a otro
    Dword           _init   ; reset the pc para reiniciar la pc
    Dword           0
    Dword           misc_int ; misc int para funciones mixtas
    Dword           0,0,0,0,0,0,0,0,0,0,0
    ; 21h-30h
    Dword           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; ===========================================
;  Mark3302 KY1 Char Map
;
; traducciones de indices de las teclas del KY1
; para traducirlos a caracteres ASCII
;
; ===========================================

    MAX_CHARS_S Equ 64
    Align       MAX_CHARS_S

char_map: 
    Byte 49,50,51,52,53,54,55,56,57,48  ; 1-0
    Byte 65,66,67,68,69,70,71,72,73,74  ; A-J
    Byte 75,76,77,78,79,80,81,82,83,84,1; K-T & Up
    Byte 85,86,87,88,89,90,2,3,4 ; U-Z & Left/Right & Down
    Align MAX_CHARS_S

; ===========================================
;  Mark3302 KY1 Keyboard
;
; buffer de espera de las teclas del teclado
; para almacenarlas y luego atraparlas
;
; ===========================================

    KEYBUF_SIZE Equ 128 ; equivale
    Align       KEYBUF_SIZE ; alineacion para asegurarse

KEYB_BUF:
    Byte        0 ; para desalinear
    Align       KEYBUF_SIZE ; truco ya que no existe la instruccion Dup

KEYB_SHEAD:
    Byte        0 ; el header del buffer
KEYB_STAIL:
    Byte        0 ; el tail del buffer

; ===========================================
;  Stack del firmware
;
; el stack del firmware solo para la inicializacion
; y pruebas de inio del dispositivo
;
; ===========================================

    STACK_SIZE  Equ 1024   ; el tamaño del stack
    Align       STACK_SIZE ; alineacion para asegurarse

STACK:
    Byte        0 ; para desalinear
    Align       STACK_SIZE  ; poner 1024 bytes en el stack
    
STACKSTART:

; ===========================================
;  STAGES FIRMWARE
;
; etapas del firmware sobre su boot
;
; ===========================================

; ===========================================
; inicializa el firmware
;
_init:
P0:
    cmpsb 4Ch, 2Bh      ; comparar valores
    jz P0               ; reintentar hasta que lo procese bien
    jl P0               ; COMO VA A SER MENOR ESE ERO HDP!!
P1:
    mov Ss, STACKSTART  ; configurar stack
    cmpsd ss, STACKSTART ; comparar si funciona
    jz P2               ; siguiente etapa
    jmp P1              ; si se configuro
P2:
    lea firmware_on_flag
    stosb 0

    ; inicializar la consola serial
    lea com1_cmd_mmio
    
    stosb SERIAL_MODE_SWITCH ; no esta lista la consola serial o cuando la apagas o
                            ; depues de un comando entonces haces que el proximo
                            ; Byte que envies sea el parametro con el que enviaste 
                            ; el comando
    mov near Ax, 0Eh        ; funcion
    mov near Bx, 1          ; caracter
    Int-Byte 10h            ; interrupcion
    call fixSerial          ; si no lo sabian si mandas un caracter en estado cuando
    call fixSerial          ; arregla la serial

    lea bootmsg             ; manda el mensaje
    call put_msg            ; pone el mensaje
    lea firmware_on_flag
    stosb 1
    lea sga_row_mmio
    stosb 45
    lea sga_col_mmio
    stosb 45
    lea sga_data_mmio
    stosb 0x22
    jmp C1

; ===========================================
; cuando el firmware espera a cargar el sector
; para bootear en el mmfs1
;
C1:
    lea Px
    jmp C2
C2:
    lea cassete_selected_mmfs ; la direccion
    stosb 0             ; parte alta
    stosb 0             ; mmfs0
    lea cassete_external_cmd ; comando
    stosb CASSETE_READ_SECTA ; lee un sector
    lea cassete_sector_read_cmd ; la direccion
    stosb 0             ; parte alta
    lea Px              ; un nop
    stosb 0             ; sector 0
C3:
    hlt                 ; espera
    lea cassete_readed_sector_finish ; la direccion
    lodsb               ; mover byte
    push near Out       ; leer
    cmpsb 1, Sp         ; verificar
    jz C4               ; se logro leer
    jmp C3              ; salta
C4:
    jmp cassete_external_sector ; salta al sector el codigo del bootloader
                        ; de 512 bytes

fixSerial:
    mov near Ax, 0Eh
    mov near Bx, 20h
    Int-Byte 10h
    jmp Sp              ; regresar

; ===========================================
;  MA3302/IO/MISC INT
;
; funcion del controlador MA3302 y asociados,
; junto con funciones de I/O y otras funciones
; mixtas que llegaran en el futuro (16h)
;
;   Ax: 01h - MA3302 KY1 keyget:
;       Ah-Byte: El Caracter ASCII de la tecla
;               sera retornado en este registro
;               asegurese de guardar su contenido
;               antes de usar esta funcion
;
;
; ===========================================

misc_int:
    ; MA3302 KY1 keyget - Leer el teclado
    cmpsb Ax, 01h       ; comparar
    jz readkey          ; ejecutar

misc_int_end:
    jmp Sp

keybuf_empty:
    lea KEYB_SHEAD      ; direccion
    lodsb               ; obtener
    mov near Al, Out    ; guardar
    lea KEYB_STAIL      ; direccion
    lodsb               ; obtener
    mov near Ah, Out    ; guardar
    push near       Al  ; head
    push near       Ah  ; tail
    cmpsb Sp,Sp         ; comparar
    jmp Sp              ; retornar

readkey_isempty:
    mov near Ah, 0  ; el resultado si no esta
    jmp readkey_end     ; finalizar
readkey:
    call keybuf_empty   ; verificar si el teclado esta vacio
    jz readkey_isempty  ; saltar si esta vacio
    lea KEYB_STAIL      ; leer el tail
    lodsb               ; obtener
    mov near Al, Out    ; obtener
    mov Ax, KEYB_BUF    ; direccion del buffer
    push Ax             ; poner en el stack AX
    push Al             ; poner en el stack Al
    Add-Dword-Sp-Sp     ; sumarlo
    lea Out             ; obtener resultado
    lodsb               ; obtener byte obtenido
    mov near Ah, Out    ; retornarlo
    lea KEYB_STAIL      ; direccion
    lodsb               ; obtener byte
    push near Out       ; guardar Out
    Add-Byte-Sp-Inm 1   ; añadir byte
    push near Out       ; guardar Out
    Mod-Byte-Sp-Inm KEYBUF_SIZE ; modular
    lea KEYB_STAIL      ; direccion
    stosb Out           ; obtener byte
    jmp misc_int_end    ; terminar

; ===========================================
;  DISPLAY INT
;
; funcion de el display (10h)
;
;   Ax: 0Eh - TTY Write:
;       Bx-Byte: El Caracter
;
;   Ax: 1Eh - TTY WriteMsg:
;       Bx-Dword: El mensaje terminado en null
;               que sera imprimido en la
;               consola
;
;   Ax: 03h - SGA Img Push
;       Bx-Dword: El puntero a la imagen comprimida que
;               Va a ser mostrada
;               en comandos de [repetidor/cmd, color?]
;               cualquier valor es aceptado como iterable
;               menos 00h que indica el fin de la imagen
;               y 0FFh que indica un salto de linea
;       Cx-Byte:  La posicion X de la imagen
;       Dx-Byte:  La posicion Y de la imagen
;
;
; ===========================================

VideoServices:
    ; TTY Write Function - Escribir un caracter
    cmpsb Ax, 0Eh       ; comparar
    jz TTY_WRITE        ; escribir

    ; TTY WriteMsg Function - Escribir un caracter
    cmpsb Ax, 1Eh       ; comparar
    jz VideoWapperWrtMsgCmpty ; escribir

    ; SGA Img Push Function - Imprimir una imagen en la pantalla
    cmpsb Ax, 03h       ; comparar
    jz SGA_IMG_PUSH     ; escribir

VideoServicesEnd:
    jmp Sp              ; regresar

; ===========================================
; imprime una imagen
;
SGA_IMG_PUSH:
    lea Bx              ; obtener direccion
    push Px             ; guardar
    lea SGA_IMG_X_ORIGN ; direccion
    stosb Cx            ; guardar
    mov near Bh, Cx     ; guardar
F10H_C1:
    lea Sp              ; xd
    lea sga_row_mmio    ; direccion
    stosb Dx            ; guardar
    lea Bx              ; obtener direccion
    push Px             ; guardar
    lodsb               ; obtener byte
    mov near Ax, Out    ; byte
    Add-Dword-Reg-Inm Px, 1 ; ver el color
    lea Out             ; revisar
    mov Bx, Out         ; saltar
    cmpsb Ax, 00h       ; si el valor es 0
    jz F10H_CEND        ; XD?!
    cmpsb Ax, 0FFh      ; si el valor es nueva linea
    jz F10H_CNL         ; nueva linea
    Add-Dword-Reg-Inm Bx, 1 ; saltar al siguiente punto
    mov Bx, Out         ; saltar
    lodsb               ; obtener
    mov near Al, Out    ; obtener
    mov near Ah, Ax     ; guardar

F10H_C2:
    lea sga_row_mmio    ; obtener direccion
    stosb Cx            ; cargar
    lea sga_col_mmio    ; obtener direccion
    stosb Dx            ; cargar
    lea sga_data_mmio   ; obtener direccion
    stosb Al            ; pintar pixel
    Add-Byte-Reg-Inm Cx, 1 ; añadir
    mov near Cx, Out    ; obtener
    push near       1   ; xd
    push near       Ah  ; a.
    Sub-Byte-Sp-Sp      ; arreglado
    mov near Ah, Out    ; obtener
    cmpsb Ah, 0         ; comparar
    Jmp-Dword-Greater F10H_C2 ; repetir
    jmp F10H_C1         ; saltar

F10H_CEND:
    lea   Sp            ; xd
    jmp VideoServicesEnd ; regresar

F10H_CNL:
    Add-Byte-Reg-Inm Dx, 1 ; añadir
    mov near Dx, Out    ; obtener
    mov near Cx, Bh ; cargar

    jmp F10H_C1     ; regresar

; ========== datos temporales de el dibujado de la imagen ==========
SGA_BYTE_SAVEDA:    Byte 0      ; guardado
SGA_IMG_X_SAVED:    Byte 0      ; guardado
SGA_IMG_X_SAVED2:   Byte 0      ; guardado
SGA_IMG_Y_SAVED:    Byte 0      ; guardado
SGA_IMG_X_ORIGN:    Byte 0      ; guardado

VideoWapperWrtMsgCmpty:
    lea Bx          ; el
    Int-Byte 11h    ; el int de put_msg
    jmp VideoServicesEnd ; regresar

; ===========================================
; manda un caracter a la consola serial
;
TTY_WRITE:
    push Px         ; poner dword
    lea com1_new_mmio ; el caracter a mandar
    stosb Bx        ; mandar
    lea Sp          ; restaurar la direccion
    jmp VideoServicesEnd ; regresar

; ===========================================
; pone un mensaje en la consola serial
;
put_msg:
    push Px          ; guardar dword

; ===========================================
; el loop de poner un mensaje en la consola
; serial
;
put_msg_loop:
    ; obtener caracter
    lodsb           ; obtiene el Byte
    push near Out   ; pone el Byte en el stack
    Cmp-Byte-Inm-Sp 0 ; compara con terminador
    jz put_msg_end ; si es igual terminar

    ; escrbir
    lodsb           ; obtiene el Byte
    push Ax         ; guardar Ax
    push Bx         ; guardar Bx
    mov near Ax, 0Eh ; teletipo
    mov near Bx, Out ; obtener byte
    Int-Byte 10h    ; servicio
    mov Bx, Sp      ; recuperar Bx
    mov Ax, Sp      ; recuperar Ax
    push Px         ; guarda la dword
    Add-Dword-Sp-Inm 1 ; suma la direccion de memoria
    lea Out         ; obtiene dword
    jmp put_msg_loop ; salta
    
; ===========================================
; el final del mensaje
;
put_msg_end:
    lea Sp          ; lee la dword
    jmp Sp          ; regresar

; ===========================================
;  DISK INT
;
; funcion de el disco (12h)
;
;   Ax: 02h - Read Sector Into Memory:
;       Bx-Word: El sector
;       Cx-Word: El Filesystem
;       Dx-Dword: Destino de la informacion leida
;
; ===========================================

DiskServices:
    ; Read Sector Into Memory - Leer sector a la memoria
    cmpsb Ax, 02h    ; comparar
    jz SECT_MEM_W   ; escribir

DiskServicesEnd:
    jmp Sp         ; regresar

SECT_MEM_W:
    ; obtener
    lea llbasect_sect_low ; la direccion
    stosw Bx        ; el sector
    lea llbasect_mmfs_low ; la direccion
    stosw Cx        ; el fs

    ; el sector
    lea cassete_selected_mmfs ; la direccion
    push Px         ; guardar px
    lea llbasect_mmfs_low ; el alto
    lodsb           ; obtener byte
    lea Sp          ; recuperar px
    stosb Out       ; parte alta
    push Px         ; guardar px
    lea llbasect_mmfs_high ; el bajo
    lodsb           ; obtener byte
    lea Sp          ; recuperar px    
    
    call readsec    ; llamar
    mov [Dword memcpy_src], Dword cassete_external_sector ; fuente
    mov [Dword memcpy_dst], Dword Dx ; destino
    mov [Dword memcpy_siz], Dword 512 ; tamaño
    Int-Byte 13h    ; el int de copiar memoria
    jmp DiskServicesEnd ; regresar

; ===========================================
;  MEMCPY FUNCTION
;
; copia datos de memoria a una ubicacion especifica
;
; ===========================================

memcpy:
    push Px
    push Out
M_LOOP:
M1:
    lea memcpy_src  ; source
    lodsd           ; obtener dword
    lea Out         ; source real
    lodsb           ; obtener byte
    push Out        ; guardar out
    lea memcpy_src  ; source
    lodsd           ; obtener dword
    push Out        ; poner out
    Add-Dword-Sp-Inm 1 ; sumarle out
    stosd Out       ; ponerlo
    Add-Dword-Sp-Inm 0 ; restaurar out
M2:
    push Out        ; guardar out
    lea memcpy_dst  ; destino
    lodsd           ; obtener dword
    lea Out         ; destino real
    Add-Dword-Sp-Inm 0 ; restaurar out
    stosb Out       ; pegar byte
    push Out        ; guardar out
    lea memcpy_dst  ; destino
    lodsd           ; obtener dword
    push Out        ; poner out
    Add-Dword-Sp-Inm 1 ; sumarle out
    stosd Out       ; ponerlo
    Add-Dword-Sp-Inm 0 ; restaurar out
M3:
    push Out        ; guardar out
    lea memcpy_siz  ; destino
    lodsd           ; obtener dword
    push 1          ; 1
    push Out        ; poner out
    Sub-Dword-Sp-Sp ; restarle a out
    stosd Out       ; ponerlo
    Add-Dword-Sp-Inm 0 ; restaurar out
    lea memcpy_siz  ; destino
    lodsd           ; obtener dword
    push Out         ; poner el out
    cmpsd 0, Sp     ; compara con terminador
    jz M4           ; si es igual terminar
    jmp M_LOOP      ; loopear
M4:
    Add-Dword-Sp-Inm 0 ; recuperar out
    lea Sp          ; recuperar px
    jmp Sp         ; retorno

; ===========================================
;  READ SECTOR FUNCTION
;
; lee un sector desde un sector especifico
;
; ===========================================

readsec:
    push Px
    push Out
RS2:
    lea cassete_readed_sector_finish ; la direccion
    stosb 0         ; byte 0
    lea cassete_external_cmd ; comando
    stosb CASSETE_READ_SECTA ; lee un sector
    lea cassete_sector_read_cmd ; la direccion
    push Px         ; guardar px
    lea llbasect_sect_low ; el alto
    lodsb           ; obtener byte
    lea Sp          ; recuperar px
    mov near Ax, Out ; ah
    stosb Out       ; parte alta
    push Px         ; guardar px
    lea llbasect_sect_high ; el bajo
    lodsb           ; obtener byte
    lea Sp          ; recuperar px
    mov near Bx, Out ; ah
    stosb Ax        ; xd
    mov near Ax, Ax ; xd
    stosb Bx        ; xd

RS3:
    hlt             ; espera
    lea cassete_readed_sector_finish ; la direccion
    lodsb           ; mover byte
    push near 1     ; 1
    push near Out   ; leer
    cmpsb Sp,Sp     ; verificar
    jz RS4          ; se logro leer
    jmp RS3         ; salta
RS4:
    Add-Dword-Sp-Inm 0 ; recuperar out
    lea Sp          ; recuperar px
    jmp Sp         ; retorno

; ===========================================
;  FUNC BUTTONS
;
; funciones para los botones de funciones de
; la PC,
; los botones son funciones de rapido acceso}
; para navegar entre menus, seleccionar cosas,
; para confirmacion y cuadros de dialogo, entre
; otras funciones
;
; ===========================================

; ===========================================
; boton 'A'
;
alpha_button_irq:
    push Px
    ; ... comming soon ...
    lea Sp
    jmp Sp

; ===========================================
; boton 'B'
;
beta_button_irq:
    push Px
    ; ... comming soon ...
    lea Sp
    jmp Sp

; ===========================================
; boton 'UP'
;
up_button_irq:
    push Px
    ; ... comming soon ...
    lea Sp
    jmp Sp

; ===========================================
; boton 'DOWN'
;
down_button_irq:
    push Px
    ; ... comming soon ...
    lea Sp
    jmp Sp

; ===========================================
;  SERIAL MMIO
;
; datos de MMIO para la consola serial y mas
; cosas relacionadas con la depuracion,
; la consola serial es una parte escencial
; de la depuracion de programas y mensajes
; de logs, ya que este PC al no haber pantalla
; necesita algo para expresarse
;
; ===========================================

SERIAL_DEFAULT_VAL  Equ 0 ; valor por defecto de el caracter o dato
                    ; para indicarle a la consola serial que
                    ; no este molestando el cpu y com1          

SERIAL_UNDEF_STATU  Equ 0xFF ; estado indefinido, si la consola serial no
                    ; funciona o el hardware no es compatible entonces
                    ; no existe puerto serial asi que nunca se actualizara

SERIAL_NON_CMD_SND  Equ 0 ; indica que no hay ningun comando que procesar y que deje
                    ; de procesar comandos hasta que actualizes esa direccion de
                    ; memoria osea la de 'serial_port_cmd'

    Align           0FFFh
; ========== caracter a mandar al puerto serial o datos de comando respectivo ==========
serial_char_send:   Byte SERIAL_DEFAULT_VAL ; caracter a mandar al puerto serial o datos
; ========== mandon de comandos al puerto serial ==========
serial_port_cmd:    Byte SERIAL_NON_CMD_SND
; ========== estado del puerto serial ==========
serial_port_status: Byte SERIAL_UNDEF_STATU

bootmsg: Byte 'b', 'o', 'o', 't', 'i', 'n', 'g', ' ', 'f', 'r', 'o',  'm', ' ', 'R', 'O', 'M', 10, 0
disk_inserted:      Byte 'c','a','s','s','e','t','e',' ','i','n','s','e','r','t','e','d', 10, 0

; ===========================================
;  CASSETE FUNCS
;
; funciones y MMIO para el cassete del disco
; principal A: alias fs0: blk0: etc
; la unidad principal del dispositivo por donde
; medio se insertan los OS, juegos baremetal
; entre otros programas de arranque post bios
;
; ===========================================

CASSETE_READ_DOT    Equ 12  ; lee un punto en el cassete
                    ; es una respuesta a una de las 
                    ; funciones del bios

CASSETE_READ_SECTA  Equ 18  ; lee un sector del cassete indexado desde
                    ; 0 a chorrocientos millones

CASSETE_WAITING_UE  Equ 24  ; que esta pendiente que se inserto un
                    ; cassete y le esta preguntando al firmware
                    ; que quieres que haga con ese cabron
                    ; osea en espaniol estandart, que el cassete
                    ; se ha insertado hace tiempo o justo ahora y tiene
                    ; pendiente que el bios haga algo con eso

; ===========================================
; variable que indica que va a hacer el cassete
; en la irq que se llamo actualmente
;
; cassete_external_cmd_alias_que_quieres_we:
    Align           2FFFh
cassete_external_cmd: Byte 0FFh

; ===========================================
; variables que indican que el cassete se leyo
; o no? que ya me confundi
;
    Align           4F00h
cassete_readed_sector_finish: Byte 0

; ===========================================
; variable que indica el sector que ha leido esa cosa
;
    Align           4FFFh
cassete_external_sector: 
    Byte            0,0
    Align 512

; ===========================================
;  Mark3302 Datas
;
; datos para el KY1 del controlador Markarian 3302
; que maneja el teclado integrado obligatorio de la
; SBC, estos datos son escritos por el hardware 
; devuelta al recibir algo externo que tiene que ver
; con controladores KY de el Markarian 3302
;
; ===========================================

    Align           5202h
; ========== dispositivo KY que envio el int ===========
MA3302_Current_KY:  Byte 0
; ========== indice de la tecla que se actualizo ===========
MA3302_KY1_KINDEX:  Byte 0
; ========== el estado de la tecla ===========
MA3302_KY1_KSTAT:   Byte 0

; ===========================================
; funcion interna de cassete no el de para 
; obtener funciones si no datos o mas cosas
;
cassete_irq:
    push Px
    push Out
    lea cassete_external_cmd

    lodsb           ; cargar
    push near Out   ; guardarlo
    cmpsb CASSETE_WAITING_UE, Sp
    jz cassete_fnc_inserted ; funcion de insertado
    
    lodsb           ; cargar
    push near Out   ; guardarlo
    cmpsb CASSETE_READ_SECTA, Sp
    jz cassete_fnc_read_sector

    jmp cassete_fnc_end

; ===========================================
; cuando leyo un sector
;
cassete_fnc_read_sector:
    lea cassete_readed_sector_finish
    stosb 1
    jmp cassete_fnc_end

; ===========================================
; cuando se inserto un cassete
;
cassete_fnc_inserted:
    lea disk_inserted ; manda el mensaje
    call put_msg     ; pone el mensaje
    jmp cassete_fnc_end

; ===========================================
; fin de la funcion de cassete
;
cassete_fnc_end:
    lea cassete_external_cmd
    stosb 0
    Add-Dword-Sp-Inm 0
    lea Sp
    jmp Sp

; ===========================================
;  Mark3302 INT
;
; el controlador Markarian 3302 soldado a la placa
; base obligatorio, permite el manejo del KY1
; (mas conocido como el puerto del teclado simple de
; teletipo para soporte basico y mecanografia, que
; el KY1 sirve para los 2 tanto electronica como para
; editar el teletipo serial COM1 aunque es una 
; caracteristica opcional que no siempre se implemente
; en todas las versiones de este firmware)
;
; en revisiones futuras de esta SBC se podra manejar mas 
; controladores tipo KY aunque solo soporte KY1
;
; ===========================================

INT5_irq:
    push Px         ; guardar
    push Out        ; guardar
    push Ax         ; guardar
    push Bx         ; guardar
    push Cx         ; guardar
    push Al         ; guardar
    push Ah         ; guardar

    lea MA3302_Current_KY ; direccion
    lodsb           ; obtener byte
    mov near Ax, Out; guardar

    ; MA3302.KY1 Controller - Controlador de teclado
    cmpsb Ax, 02Ch  ; controlador de KY1
    jz M3KY1_Hand   ; manejar

INT5_end:
    mov Ah, Sp      ; recuperar
    mov Al, Sp      ; recuperar
    mov Cx, Sp      ; recuperar
    mov Bx, Sp      ; recuperar
    mov Ax, Sp      ; recuperar
    mov Out, Sp     ; recuperar
    mov Px, Sp      ; recuperar
    jmp Sp         ; retorno

M3KY1_Hand:
    lea MA3302_KY1_KINDEX ; indice
    lodsb           ; obtener
    mov near Bx, Out; copiar indice
    mov Cx, char_map; mapa
    push Cx
    push Bx
    Add-Dword-Sp-Sp ; añadir
    mov Cx, Out     ; copiar
    lea Cx          ; direccion
    lodsb           ; obtener
    mov near Bx, Out; obtener byte

    call KEYB_BUF_FULL; verificar si esta vacio
    jz INT5_end     ; terminar

    mov Cx, KEYB_BUF; leer el buffer
    lea KEYB_SHEAD  ; obtener
    lodsb           ; obtener
    mov near Ax, Out; guardar
    push Cx         ; evitar el bug otra vez
    Add-Dword-Reg-Sp Ax ; guardar
    lea Out         ; el buffer y indice
    stosb Bx        ; guardar el indice de caracter
    call KEYB_BUF_CALCI ; calcular
    lea KEYB_SHEAD  ; direccion
    stosb Ax        ; guardar resultado

    jmp INT5_end    ; finalizar

; ((scancodeskey_head + 1) % KEYBUF_SIZE) == scancodeskey_tail
KEYB_BUF_FULL:
    lea KEYB_SHEAD  ; direccion
    lodsb           ; obtener byte
    Add-Byte-Reg-Inm Out, 1 ; añadir 1
    Mod-Byte-Reg-Inm Out, KEYBUF_SIZE ; modular
    lea KEYB_STAIL  ; obtener
    mov near Al, Out; guardar
    lodsb           ; obtener byte
    mov near Ax, Out; guardar
    push near Ax    ; para solucionar un bug
    cmpsb Al, Sp    ; comparar
    jmp Sp          ; retorno

; ((scancodeskey_head + 1) % KEYBUF_SIZE)
KEYB_BUF_CALCI:
    lea KEYB_SHEAD  ; direccion
    lodsb           ; obtener byte
    Add-Byte-Reg-Inm Out, 1 ; añadir 1
    Mod-Byte-Reg-Inm Out, KEYBUF_SIZE ; modular
    mov near Ax, Out; guardar
    jmp Sp          ; retorno

KEYB_BUF_EMPTY:
    lea KEYB_SHEAD  ; direccion
    lodsb           ; obtener
    mov near Ah, Out; header
    lea KEYB_STAIL  ; direccion
    lodsb           ; obtener
    mov near Al, Out; header
    Cmp-Byte-Reg-Reg Ah, Al; comparar head con tail
    jmp Sp          ; retorno


; ===========================================
;  DATA SECTION
;
; seccion de datos de los parametros de funciones
; del firmware
;
; ===========================================

; ===========================================
; datos de memcpy
;
    Align           7200h
memcpy_src: Dword 0
memcpy_dst: Dword 0
memcpy_siz: Dword 0

; ===========================================
; datos de load sector
;
    Align           720Dh
llbasect_sect_low:  Byte 0
llbasect_sect_high: Byte 0

; ===========================================
; datos de load mmfs
;
llbasect_mmfs_low:  Byte 0
llbasect_mmfs_high: Byte 0

; ===========================================
; datos de guardado del pixel
;
    Align 7FFFh
old_pix_x: Byte 0
old_pix_y: Byte 0
firmware_on_flag:   Byte 0

; ===========================================
;  OFITIAL MMIO
;
; vectores de io de mmio para los dispositivos
; reales del PC
;
; ===========================================

    Align           64000
basic_buttons_mmio: 
  Byte 0,0,0,0 ; boton A, B, arriba y abajo
cassete_mmio: 
  Byte 0   ; mmio del cassete
sga_data_mmio:      
  Byte 0   ; al ultimo de configurar el SGA row y SGA col se pone el color para esto
sga_row_mmio: 
  Byte 0   ; posicion y de la SGA
sga_col_mmio: 
  Byte 0   ; posicion x de la SGA
com1_new_mmio:      
  Byte 0   ; nuevo MMIO del com1
com1_cmd_mmio:      
  Byte 0   ; nuevo MMIO del com1
cassete_sector_read_cmd: Byte 0 ; escribir 2 veces para completar el word
cassete_selected_mmfs: Byte 0   ; disco seleccionado , start = (fs * 512) + sector