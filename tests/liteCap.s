    
    ; =============================================
    ; capacidades de la version Lite que esta
    ; disponible en scratch como proyecto por
    ; el usuario TypeScripterAutist42
    ;
    ; la version lite de Pulsar no tiene otro
    ; modo mas que el de 64 bits ademas tampoco
    ; tiene interrupciones para el firmware
    ; 
    ; Es una version inestable que hace calculos
    ; complejos de forma incorrecta pero aqui
    ; esta este ejemplo para probar su capacidad
    ; de Memoria y Alu basica
    ; =============================================

    org32                   ; modo 32
dd  start                 ; inicio del firmware
    org64                   ; modo nativo de 64 bits
start:
    ; NOTA: para entrar a 64 bits no es necesaria
    ;       la instruccion dbgAc64 de hecho no se recomienda
    ;       ya que esta version no tiene la ISA de 32 bits
    ;       y arranca directamente en la de 64 bits, asi
    ;       que ese conjunto ni existe y aparte ya esta en
    ;       el modo en el que queremos que este por que no
    ;       tiene opcion

    ; probar escritura
    li64    r0, 0DEADh      ; valor al azar
    li64    r1, mn          ; memoria
    mwr16   r1, r0          ; escribir memoria

    ; probar lectura y alu
    lv16    r1, r0          ; obtener valor
    add     r0, r0, 1       ; NOTA: las operaciones complejas
                            ; tanto de alu como generales o no
                            ; aritmeticas que sean complejas
                            ; NO van a funcionar en la version de
                            ; scratch de esta implementacion de
                            ; diseño de la rama lite de nuestros
                            ; procesadores, para avisar
                            
mn: dw    0                 ; definir variable de 16 bits