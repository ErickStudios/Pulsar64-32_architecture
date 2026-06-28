<div style="display: flex; justify-content: center;">
  <img src="./../logo.svg" alt="Logo" width="100">
</div>

# Tabla de Configuracion del CPU

El CPU en modo 64 bits es un modo nuevo, mas seguro y mas limpio, para lograr esto se creo la **abla de Configuracion del CPU** que contiene:

0. la [Interruption Description Table](#interruption-descriptor-table)
1. la [CPU Levels Perms Description Table](#cpu-levels-perms-descriptor-table)
2. la [CPU Memory Regions Descriptor Table](#cpu-memory-regions-descriptor-table)

cada una indicada con un puntero de tipo Qword (puntero de 64 bits) a su direccion de la tabla correspondiente, situando los punteros a las respectivas tablas en el orden en el que se menciono anteriormente en el listado, cada puntero es calculado por la ecuacion

$$
addr=(CPUTable+(offset*8))
$$

Que, una vez calculada la direccion por el offset con respecto a la tabla de CPU, se lee un entero de 64 bits sin signo desde esa region de memoria indicada

# Interruption Descriptor Table

Cada descriptor de interrupcion mide 16 bytes y consta por 2 enteros de 32 bits y uno de 64, los primeros dos enteros indican

1. El modo del CPU en el que entra la interrupcion al ser llamada
2. el indice de la paleta de permiso que usa con respecto a la lista almacenada en el [CPU Levels Perms Description Table](#cpu-levels-perms-descriptor-table) y obtiene su elemento calculando su indice (que el primer elemento es siempre el numero 0)

y el entero de 64 bits es el que apunta a la direccion de memoria donde se encuentra la funcion y su rutina de ejecucion

# CPU Levels Perms Descriptor Table

Cada descriptor de permisos del cpu esta representado por 2 enteros de 16 bits que se usan en el siguiente orden de la manera listada a continuacion

1. El indice de la regin de memoria que usara dentro de la lista de la [CPU Memory Regions Descriptor Table](#cpu-memory-regions-descriptor-table) que contiene el inicio y fin de la region
2. Lo que tiene permitido hacer, si el bit esta activado significa que puede, y si no, significa que no puede, asegurese que el firmware tenga todos los privilegios posibles

# CPU Memory Regions Descriptor Table

Cada descriptor tiene 2 enteros de 64 bits que indican el inicio y fin de la memoria que puede usar el **CPU Levels Perms Porfile** esto se puede tambien configurar para que sea invertido el orden o tenga permitido tambien escribir ya que se pueden configurar las dos cosas por separado