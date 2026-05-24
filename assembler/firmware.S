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
;           VECTORS & FUNCS
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
_reset_vector:
    Assume-Dword    _init

; ===========================================
; vectores de dispositivos y sus irqs que
; los atienden cada vez que lo requieren
;
_devices_vector:
    _alphaBtn_vec_ptr:
        Assume-Dword alpha_button_irq
    _betaBtn_vec_ptr:
        Assume-Dword beta_button_irq
    _upBtn_vec_ptr:
        Assume-Dword up_button_irq
    _downBtn_vec_ptr:
        Assume-Dword down_button_irq
    _cassete_vec_ptr:
        Assume-Dword cassete_irq

Assume-Fill         0x1F0

; ===========================================
; vectors de funciones del firmware
;
_vectors:
    Assume-Word     put_char
    Assume-Word     put_msg
    Assume-Word     put_msg

; ===========================================
;           STAGES FIRMWARE
;
; etapas del firmware sobre su boot
;
; ===========================================

; ===========================================
; inicializa el firmware
;
_init:
    Lea-dword       firmware_on_flag
    Out-Byte        0

    ; inicializar la consola serial
    Lea-Dword       serial_port_cmd
    Out-Byte        SERIAL_MODE_SWITCH
                                ; no esta lista la consola serial o cuando la apagas o
                                ; depues de un comando entonces haces que el proximo
                                ; byte que envies sea el parametro con el que enviaste 
                                ; el comando
    Add-Byte-Inm-Inm 1, 0       ; el modo de limpiar com1 y por ahora directamente 
                                ; le puedes poner el modo de print out
    Jmp-Word-Call   put_char    ; mandrlo
    Jmp-Dword-Call  fixSerial   ; si no lo sabian si mandas un caracter en estado cuando

    Jmp-Dword-Call  fixSerial   ; arregla la serial
    Lea-Dword       bootmsg     ; manda el mensaje
    Jmp-Dword-Call  put_msg     ; pone el mensaje
    Lea-dword       firmware_on_flag
    Out-Byte        1
    Lea-Dword       alpha_mmio
    Out-Byte        1
    Lea-Dword       beta_mmio
    Out-Byte        2
    Lea-Dword       up_mmio
    Out-Byte        3

; ===========================================
; el loop que el firmware tiene para ser un
; os pequeño en si mismo y esperar eventos
;
loop:
    Hlt                         ; espera
    Jmp-Word-Clasic loop        ; salta

fixSerial:
    Add-Byte-Inm-Inm ' ', 0
    Jmp-Word-Clasic put_char

; ===========================================
;           SERIAL FUNCS
;
; funciones para la consola serial y el puerto
; de depuracion de la PC
;
; ===========================================

; ===========================================
; manda un caracter a la consola serial
;
put_char:
    Push-Dword      Px          ; poner dword
    Lea-Dword       serial_char_send ; el caracter a mandar
    Out-Byte        0           ; actualizar
    Out-Byte        Out         ; mandar
    Lea-Dword       Sp          ; restaurar la direccion
    Jmp-Dword-Clasic Sp         ; regresar

; ===========================================
; pone un mensaje en la consola serial
;
put_msg:
    Push-Dword      Px          ; guardar dword

; ===========================================
; el loop de poner un mensaje en la consola
; serial
;
put_msg_loop:
    Mov-Byte                    ; obtiene el byte
    Push-Byte       Out         ; pone el byte en el stack
    Cmp-Byte-Inm-Sp 0           ; compara con terminador
    Mov-Byte                    ; obtiene el byte
    Jmp-Word-Zero   put_msg_end ; si es igual terminar
    Jmp-Dword-Call  put_char    ; pone el caracter en la consola serial
    Push-Dword      Px          ; guarda la dword
    Add-Dword-Sp-Inm 1          ; suma la direccion de memoria
    Lea-Dword       Out         ; obtiene dword
    Jmp-Dword-Clasic put_msg_loop ; salta
    
; ===========================================
; el final del mensaje
;
put_msg_end:
    Lea-Dword       Sp          ; lee la dword
    Jmp-Dword-Clasic Sp         ; regresar

; ===========================================
;           FUNC BUTTONS
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
    Push-Dword      Px
    ; ... comming soon ...
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

; ===========================================
; boton 'B'
;
beta_button_irq:
    Push-Dword      Px
    ; ... comming soon ...
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

; ===========================================
; boton 'UP'
;
up_button_irq:
    Push-Dword      Px
    ; ... comming soon ...
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

; ===========================================
; boton 'DOWN'
;
down_button_irq:
    Push-Dword      Px
    ; ... comming soon ...
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

Assume-Fill         0xFFF

; ===========================================
;           SERIAL MMIO
;
; datos de MMIO para la consola serial y mas
; cosas relacionadas con la depuracion,
; la consola serial es una parte escencial
; de la depuracion de programas y mensajes
; de logs, ya que este PC al no haber pantalla
; necesita algo para expresarse
;
; ===========================================

SERIAL_DEFAULT_VAL  Equ 0       ; valor por defecto de el caracter o dato
                                ; para indicarle a la consola serial que
                                ; no este molestando el cpu y com1          

SERIAL_UNDEF_STATU  Equ 0xFF    ; estado indefinido, si la consola serial no
                                ; funciona o el hardware no es compatible entonces
                                ; no existe puerto serial asi que nunca se actualizara

SERIAL_NON_CMD_SND  Equ 0       ; indica que no hay ningun comando que procesar y que deje
                                ; de procesar comandos hasta que actualizes esa direccion de
                                ; memoria osea la de 'serial_port_cmd'

; ===========================================
; caracter a mandar al puerto serial o datos
; de comando respectivo
;
serial_char_send:
    Assume-Byte     SERIAL_DEFAULT_VAL
; ===========================================
; mandon de comandos al puerto serial
;
serial_port_cmd:
    Assume-Byte     SERIAL_NON_CMD_SND
; ===========================================
; estado del puerto serial
;
serial_port_status:
    Assume-Byte     SERIAL_UNDEF_STATU

Assume-Fill     0x1FFF

bootmsg:
    Assume-Byte     'b', 'o', 'o', 't', 'i', 'n', 'g', ' ', 'f', 'r', 'o',  'm', ' ', 'R', 'O', 'M', 10, 0
disk_inserted:
    Assume-Byte     'c','a','s','s','e','t','e',' ','i','n','s','e','r','t','e','d', 10, 0

; ===========================================
;           CASSETE FUNCS
;
; funciones y MMIO para el cassete del disco
; principal A: alias fs0: blk0: etc
; la unidad principal del dispositivo por donde
; medio se insertan los OS, juegos baremetal
; entre otros programas de arranque post bios
;
; ===========================================

Assume-Fill     0x2FFF

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
cassete_external_cmd:
    Assume-Byte 0xFF

Assume-Fill 0x4F00

; ===========================================
; variables que indican que el cassete se leyo
; o no? que ya me confundi
;
cassete_readed_sector_finish:
    Assume-Byte 0

Assume-Fill 0x4F02

; ===========================================
; variable que indica el sector a leer con read
; sector
;
cassete_readed_sector_finish:
    Assume-Word 0

; ===========================================
; variable que indica el sector que ha leido esa cosa
;
Assume-Fill 0x4FFF
;cassete_external_sector_lo_que_lello_este_men:
cassete_external_sector:
    Assume-Fill 0x51FF

; ===========================================
; funcion interna de cassete no el de para 
; obtener funciones si no datos o mas cosas
;
cassete_irq:
    Push-Dword      Px
    Push-Dword      Out
    Lea-Dword       cassete_external_cmd

    Mov-Byte
    Push-Byte       Out
    Cmp-Byte-Inm-Sp CASSETE_WAITING_UE
    Jmp-Word-Zero   cassete_fnc_inserted
    
    Mov-Byte
    Push-Byte       Out
    Cmp-Byte-Inm-Sp CASSETE_READ_SECTA
    Jmp-Word-Zero   cassete_fnc_read_sector

    Jmp-Dword-Clasic cassete_fnc_end

; ===========================================
; cuando leyo un sector
;
cassete_fnc_read_sector:
    Lea-Dword       cassete_readed_sector_finish
    Out-Byte        1
    Jmp-Dword-Clasic cassete_fnc_end

; ===========================================
; cuando se inserto un cassete
;
cassete_fnc_inserted:
    Lea-Dword       disk_inserted ; manda el mensaje
    Jmp-Dword-Call  put_msg     ; pone el mensaje
    Jmp-Dword-Clasic cassete_fnc_end

; ===========================================
; fin de la funcion de cassete
;
cassete_fnc_end:
    Add-Dword-Sp-Inm 0
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

Assume-Fill 0x6FFF

Assume-Byte 'p', 'o', 'r', ' ', 'q', 'u', 'e', ' ', 'l', 'l', 'e', 'g', 'a', 's','t','e',' ','a','q','u','i','?'
Assume-Fill 0x7220

Assume-Byte 'd','a','a',' ','d','a',' ','d','a',' ','d','a','a',' ','d','a',' ','d','a',' ','d','a','a',' '

Assume-Fill 0x7FFF

firmware_on_flag:
    Assume-Byte     0

Assume-Fill 64000
alpha_mmio:
    Assume-Byte     0
beta_mmio:
    Assume-Byte     0
up_mmio:
    Assume-Byte     0
down_mmio:
    Assume-Byte     0
cassete_mmio:
    Assume-Byte     0