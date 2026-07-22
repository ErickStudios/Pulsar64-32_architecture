// Addr Of Uart
char* UartAddr;

// Character Put
char putc(char x) {
    *UartAddr = x;
}

// String Put
char putstmp1;
char* putstmp2;
char puts(char* msg) {
    putstmp2 = msg;
    while (*putstmp2 != 0) {
        putstmp1 = *putstmp2;
        putc(putstmp1);
        putstmp2 = putstmp2 + 1;
    }
}