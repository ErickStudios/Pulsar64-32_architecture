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
extern char drawPixel(char x, char y, char color);

// EBoot Functions Structure
struct EBootPayloadTable {
    char*   vendorPtr;
    char    (*puts)     (char* str);
    char    (*drawPixel)(char x, char y, char color);
    char    (*outPort)  (long port, char data);
    char    (*inPort)   (long port, char* data);
    char    (*readDisk) (char* buffer, long lba);
};

// The Original Table
struct EBootPayloadTable Table;

extern char test(struct EBootPayloadTable* info);

long entryBoot;
// The Main Function
char main() {
    // Initialize Bases
    Table.vendorPtr =   __vend;
    UartAddr =          __uart;

    // Initialize Firmware
    initdisplay ();
    puts        (__vend);
    readDisk    (BootSectorLoader, 0);

    // Initialize Services
    Table.drawPixel =   drawPixel;
    Table.puts =        puts;
    Table.outPort =     outPort;
    Table.inPort =      inPort;
    Table.readDisk =    readDisk;

    test(&Table);
}

long drv;
char test(struct EBootPayloadTable* info) {
}