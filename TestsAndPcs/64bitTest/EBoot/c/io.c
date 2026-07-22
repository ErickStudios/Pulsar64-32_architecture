char* portTmp;
char outPort(long port, char data) {
    portTmp = port + 0x50000;
    *portTmp = data;
}
char inPort(long port, char* data) {
    portTmp = port + 0x50000;
    *data = *portTmp;
}