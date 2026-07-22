// Variables used for hings
extern char* __uart;
extern char* __vend;
extern char* BootSectorLoader;
extern char* UartAddr;

// Include I/O functions for use
extern char outPort(long port, char data);
extern char inPort(long port, char* data);

// Include Disk Functions
extern char readDisk(char* buffer, long lba);

// Debug Console Functions
extern char putc(char ch);
extern char puts(char* str);

// Include Screen Functions
extern char initdisplay();

// EBoot Functions Structure
struct EBootPayloadTable {
    char* vendorPtr;
};

// The Original Table
struct EBootPayloadTable Table;

long entryBoot;
// The Main Function
char main() {
    Table.vendorPtr = __vend;
    UartAddr = __uart;
    
    initdisplay();
    puts(__vend);
    readDisk(BootSectorLoader, 0);

    entryBoot = BootSectorLoader;
    __asm__ ("li64 lnk, entryBoot lv64 lnk, lnk bl lnk");
}

// codigo suelto inacesible