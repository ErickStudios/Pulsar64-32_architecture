<div style="display: flex; justify-content: center;">
  <img src="./../logo.svg" alt="Logo" width="100">
</div>

# Como funcionan los vectors de memoria (modo 32 bits)

Esta informacion esta obsoleta para la mayoria de los casos y solo aplica al modo de 32 bits, para ver como se estructura las interrupciones y los servicios de irq que no sean del reset vector consulte [Tabla de Idt de 64 bits](./i64cpucfgtable.md#interruption-descriptor-table)

un vector de memoria es una direccion fija que el sistema desde los primeros segundos desde su arranque tiene previsto que haya algo especifico alli

los vectors de arranque en la arquitectura Pulsar 32/64 en su modo de 32 bits funcionan de la siguiente manera

| Desde  | Hasta | Nombre | Descripcion |
| ------------ | ------------ | ------------ | ------------ |
| 0x00000000 | 0x00000003 | vector de arranque | es la direccion de el codigo del firmware que se ejecuta en el primer instante de haberse encendido el chip
| 0x00000004 | cada vector ocupa 4 bytes y empiezan desde la direccion 0x00000003 y van ordenados por medio del indice de dispositivo | vectores de firmwares de los dispositivos de entrada y salida | son las direcciones a la ubicacion absoluta de el codigo de firmware que maneja cada dispositivo |

1. El vector de reset SIEMPRE está en 0x00000000
2. Cada vector ocupa exactamente 4 bytes (DWORD)
3. Los vectores deben estar alineados a 4 bytes
4. Los dispositivos usan un ID entero (0, 1, 2...)
5. La dirección del vector de un dispositivo es:
    ```
    vector_addr = 0x00000004 + (device_id * 4)
    ```

# Funcionamiento del sistema

Cuando ocurre una interrupción:

1. El dispositivo envía su device_id
2. El CPU calcula:
    ```
    vector_addr = 0x00000004 + (device_id * 4)
    ```
3. Lee un DWORD desde esa dirección
4. Salta a esa dirección (pc = vector)

    Ejemplo
    ```asm
    Assume-Org 0

    _reset_vector:
        Assume-Dword _init

    _device_vectors:
        Assume-Dword alpha_button_irq   ; device 0
        Assume-Dword beta_button_irq    ; device 1
        Assume-Dword up_button_irq      ; device 2
        Assume-Dword down_button_irq    ; device 3

    _init:
        ; código principal
        Hlt
    ```