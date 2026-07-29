__asm__("org32 Assume-org (8D00h - $) org64");

/*use32Addr*/

// EBoot Functions Structure
struct EBootPayloadTable {
    char*   vendorPtr;
    char    (*puts)     (char* str);
    char    (*drawPixel)(char x, char y, char color);
    char    (*outPort)  (long port, char data);
    char    (*inPort)   (long port, char* data);
    char    (*readDisk) (char* buffer, long lba);
    char    (*readSects)(char* buffer, long lba, long sects);
    char    (*activeDebug)();
};

struct __bootstrap1 {
    char    (*entry)(struct EBootPayloadTable* info);
};

struct SuperBlock {
    long     initCodeStart;
    long     initCodeSizeSec;
};

extern char* test;
extern char* bf;
extern struct SuperBlock* baf;
extern struct __bootstrap1* xd;

char EBoot_Main(struct EBootPayloadTable* inf) {
    bf = 0x20000;
    inf->readDisk(bf, 1);
    //char* x;
    //x = &baf->initCodeStart;
    //x = x + 7;
    //inf->puts(x);
    inf->readSects(0x20000, baf->initCodeStart, baf->initCodeSizeSec);
    inf->activeDebug();
    xd->entry(inf);
}

__asm__("bf: baf: reserve 8");
__asm__("xd: qword bf");

__asm__("align 512");

/*!use32Addr*/
__asm__("org32 Assume-org 0 org64");
__asm__("ab: dq (kernelEntry / 512)");
__asm__("cd: dq ((kernelEnd - kernelEntry) / 512)");
__asm__("align 512");
__asm__("org32 Assume-org (20000h - $) org64");

extern char* msg;

char kernelEntry(struct EBootPayloadTable* inf) {
    inf->puts(&msg);
    while (1 == 1) {}
}

char* msg = "hello world";

__asm__("align 512");
__asm__("kernelEnd:");