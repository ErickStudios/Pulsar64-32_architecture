![pulsar5024XM_x32](../logo.png)

# Como funcionan los vectors de memoria

un vector de memoria es una direccion fija que el sistema desde los primeros segundos desde su arranque tiene previsto que haya algo especifico alli

los vectors de arranque en el chip `pulsar5024XM_x32` son

| Desde  | Hasta | Nombre | Descripcion |
| ------------ | ------------ | ------------ | ------------ |
| 0x00000000 | 0x00000003 | vector de arranque | es la direccion de el codigo del firmware que se ejecuta en el primer instante de haberse encendido el chip
| 0x00000003 | alineado a 4 bytes desde 0x00000003 | vectores de firmwares de los dispositivos de entrada y salida | son las direcciones a la ubicacion absoluta de el codigo de firmware que maneja cada dispositivo |