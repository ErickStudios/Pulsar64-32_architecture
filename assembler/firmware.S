Assume-Org          0

SERIAL_MODE_SWITCH  Equ  0x01

_reset_vector:
    Assume-Dword    _init
_devices_vector:
    _alphaBtn_vec_ptr:
        Assume-Dword alpha_button_irq
    _betaBtn_vec_ptr:
        Assume-Dword beta_button_irq
    _upBtn_vec_ptr:
        Assume-Dword up_button_irq
    _downBtn_vec_ptr:
        Assume-Dword down_button_irq 
_init:
    ; inicializar la consola serial
    Lea-Dword       serial_port_cmd
    Out-Byte        SERIAL_MODE_SWITCH
                              ; no esta lista la consola serial o cuando la apagas o
                              ; depues de un comando entonces haces que el proximo
                              ; byte que envies sea el parametro con el que enviaste 
                              ; el comando
    Add-Byte-Inm-Inm 1, 0     ; el modo de limpiar com1 y por ahora directamente 
                              ; le puedes poner el modo de print out
    Jmp-Word-Call   put_char  ; mandrlo
    Jmp-Dword-Call  fixSerial ; si no lo sabian si mandas un caracter en estado cuando

    Jmp-Dword-Call  fixSerial
    Lea-Dword       bootmsg
    Jmp-Dword-Call  put_msg
loop:
    Hlt
    Jmp-Word-Clasic loop

fixSerial:
    Add-Byte-Inm-Inm ' ', 0
    Jmp-Word-Clasic put_char

; ================= funcs =================

; put a character
put_char:
    Push-Dword      Px
    Lea-Dword       serial_char_send
    Out-Byte        0
    Out-Byte        Out
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

put_msg:
    Push-Dword      Px
put_msg_loop:
    Mov-Byte
    Push-Byte       Out
    Cmp-Byte-Inm-Sp 0
    Mov-Byte
    Jmp-Word-Zero   put_msg_end
    Jmp-Dword-Call  put_char
    Push-Dword      Px
    Add-Dword-Sp-Inm 1
    Lea-Dword       Out
    Jmp-Dword-Clasic put_msg_loop
put_msg_end:
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp


; ================= irqs =================
; the irqs

alpha_button_irq:
    Push-Dword      Px
    Lea-Dword       25
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp
beta_button_irq:
    Push-Dword      Px
    Lea-Dword       30
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp
up_button_irq:
    Push-Dword      Px
    Lea-Dword       35
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp
down_button_irq:
    Push-Dword      Px
    Lea-Dword       40
    Lea-Dword       Sp
    Jmp-Dword-Clasic Sp

Assume-Fill         0xFFF

; ================= serial =================
; the serial console

; send char
serial_char_send:
    Assume-Byte     0
; command sender
serial_port_cmd:
    Assume-Byte     0
; serial status
serial_port_status:
    Assume-Byte     0

bootmsg:
    Assume-Byte     'b', 'o', 'o', 't', 'i', 'n', 'g', ' ', 'f', 'r', 'o',  'm', ' ', 'R', 'O', 'M', 10, 0