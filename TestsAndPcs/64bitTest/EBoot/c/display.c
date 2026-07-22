// Include I/O functions for use
extern char outPort(long port, char data);
extern char inPort(long port, char* data);

// Debug Console Functions
extern char putc(char ch);
extern char puts(char* str);

extern char* nonvdisplay;

// Color Save For Screen
struct ColorRepresentation {
    char red;
    char green;
    char blue;
};

// Draw Pixel Function
char drawPixel(char x, char y, char color) {
    outPort(0x36A, x);
    outPort(0x36B, y);
    outPort(0x36C, color);
}

char idispTmpData;
short idispIndex;
struct ColorRepresentation idispCol;
char initdisplay() {
    // Check For A Display Screen Avaible
    inPort(0x360, &idispTmpData);


    // Init Configuration
    outPort(0x360, 0x00);   // Says to the display adapter 
                            //'Ok i go to set the curent config and if not exists create it'

    // Screen Resolution
    outPort(0x361, 255);   // 256 pixels by row
    outPort(0x366, 255);   // 256 rows in screen

    // Start Config
    outPort(0x360, 0x01);   // Aply Configuration

    // Will See that everything is black or a undefined color
    // We set the table

    idispIndex = 0;

    while (idispIndex != 256) {
        // Configure Color For Be Better
        idispCol.red = idispIndex >> 4;
        idispCol.red = idispCol.red & 3;
        idispCol.green = idispIndex >> 2;
        idispCol.green = idispCol.green & 3;
        idispCol.blue = idispIndex & 3;

        idispCol.red = idispCol.red * 64;
        idispCol.blue = idispCol.blue * 64;
        idispCol.green = idispCol.green * 64;

        // Set Color
        outPort(0x362, idispIndex);     // Configure Index To Set
        outPort(0x363, idispCol.red);   // Red Field
        outPort(0x364, idispCol.green); // Green Field
        outPort(0x365, idispCol.blue);  // Blue Field
        outPort(0x360, 0x02);           // Aply Color Config

        idispIndex = idispIndex + 1;
    }

    drawPixel(1,2,0xFF);
    return 0;
}