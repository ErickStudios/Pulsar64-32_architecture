// Include I/O functions for use
extern char outPort(long port, char data);
extern char inPort(long port, char* data);

// A Field Of Casting Convertor Of Disk
struct DiskAddrInfo {
    char Top;
    char Bottom;
    char Head;
    char Tail;
};

// Read The Disk
char ReadDisktmpStatus;
char ReadDisktmpwaitCount;
char* ReadDisktmpbuffer;
struct DiskAddrInfo ReadDisktmpInfo;
char ReadDiskByteReaded;
short ReadDiskTmpByteRead;
// 0x2A2 = Top, 0x2A3 = Bottom, 0x244 = Head, 0x245 = Tail
// Top:Bottom+(Head & 0x2 << 8):Tail
char readDisk(char* buffer, long lba) {
    ReadDisktmpbuffer = buffer;

    outPort(0x2A0, 1); // Init Motor

    ReadDisktmpwaitCount = 20;

    // The Disk Needs Time For Notify
    while (ReadDisktmpwaitCount != 0) {
        // Decrement Counter
        ReadDisktmpwaitCount = ReadDisktmpwaitCount - 1;
    }

    // Check If The Motor Has Not Error
    inPort(0x2A0, &ReadDisktmpStatus);

    // If Not Errors
    if (ReadDisktmpStatus != 0xFF) {
        ReadDiskTmpByteRead = 0;
        while (ReadDiskTmpByteRead != 512) {
            // Top Of The disk sector
            ReadDisktmpInfo.Top = lba >> 8;
            ReadDisktmpInfo.Top = ReadDisktmpInfo.Top & 255;

            // Bottom Of The disk sector
            ReadDisktmpInfo.Bottom = lba & 255;

            // Configure Params For Disk Reading
            ReadDisktmpInfo.Head = ReadDiskTmpByteRead >> 8;
            ReadDisktmpInfo.Head = ReadDisktmpInfo.Head & 3;
            ReadDisktmpInfo.Tail = ReadDiskTmpByteRead & 255;

            // Write Top And Bottom
            outPort(0x2A2, ReadDisktmpInfo.Top);
            outPort(0x2A3, ReadDisktmpInfo.Bottom);

            // Write Head And Tail
            outPort(0x2A4, ReadDisktmpInfo.Head);
            outPort(0x2A5, ReadDisktmpInfo.Tail);

            // Read A Byte On The Disk
            outPort(0x2A0, 0x81); // Indicates the motor to put down the pencil
            outPort(0x2A0, 0x98); // Indicates the motor to read the interruptors in the pos 8 times
            outPort(0x2A0, 0x80); // Indicates the motor to put up the pencil

            inPort(0x2A1, &ReadDiskByteReaded); // Read The Outpud
            *ReadDisktmpbuffer = ReadDiskByteReaded;

            // Next Byte
            ReadDiskTmpByteRead = ReadDiskTmpByteRead + 1;
            ReadDisktmpbuffer = ReadDisktmpbuffer + 1;
        }
    }
}