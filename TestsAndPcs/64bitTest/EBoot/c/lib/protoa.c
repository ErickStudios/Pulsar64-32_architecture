
// stdmem

long stdmem_memcpy(char* dst, char* src, long size) {
    long qued;
    char* tdst;
    char* tsrc;
    
    qued = size;
    tdst = dst;
    tsrc = src;
    while (qued != 0) {
        *tdst = *tsrc;
        tdst++;
        tsrc++;
        qued--;
    }
    return size;
}

long stdmem_memset(char* dst, char v, long size) {
    long qued;
    char* tdst;
    
    qued = size;
    tdst = dst;
    while (qued != 0) {
        *tdst = v;
        tdst++;
        qued--;
    }
    return size;
}


long stdmem_memcmp(char* dst, char* src, long size) {
    long dif;
    char* tdst;
    char* tsrc;
    long qued;
    dif = 0;
    tdst = dst;
    tsrc = src;
    qued = size;

    while (qued != 0) {
        if (*tdst != *tsrc) {
            dif++;
        }
        tdst++;
        tsrc++;
        qued--;
    }

    return dif;
}