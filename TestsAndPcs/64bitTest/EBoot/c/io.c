char outPort(long port, char data) {
    char* portTmp;
    portTmp = port + 0x50000;
    *portTmp = data;
}
char inPort(long port, char* data) {
    char* portTmp;
    portTmp = port + 0x50000;
    *data = *portTmp;
}