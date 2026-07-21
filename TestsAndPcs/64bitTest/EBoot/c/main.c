// Variables used for hings
extern char* __uart;
extern char* __vend;

// EBoot Functions Structure
struct EBootPayloadTable {
    char* vendorPtr;
};

// Addr Of Uart
char* UartAddr;

// The Original Table
struct EBootPayloadTable Table;

char xa;

// The Main Function
char main() {
    Table.vendorPtr = __vend;
    UartAddr = __uart;
    puts(__vend);
    halt();
}

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

// codigo suelto inacesible