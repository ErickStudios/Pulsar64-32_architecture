// Addr Of Uart
char* UartAddr;

// Character Put
char putc(char x) {
    *UartAddr = x;
}

// String Put
char puts(char* msg) {
    char* putstmp2;
    putstmp2 = msg;
    while (*putstmp2 != 0) {
        putc(*putstmp2);
        putstmp2++;
    }
}