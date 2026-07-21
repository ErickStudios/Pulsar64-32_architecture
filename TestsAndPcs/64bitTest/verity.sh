node ../../Assembler/PulsarAssembly.js test2.S program.bin -rbin
node ../../Assembler/PulsarAssembly.js testDisk.S test.img -rbin

verilator \
    --cc cpu.v \
    --top-module cpu \
    --exe main.cpp \
    --build \
    --Wno-WIDTH \
    --CFLAGS "$(sdl2-config --cflags)" \
    --LDFLAGS "$(sdl2-config --libs)"

 #./obj_dir/Vcpuv