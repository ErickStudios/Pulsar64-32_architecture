#include "obj_dir/Vcpu.h"

#define NON_GUI1

#ifndef NON_GUI1
#include <SDL2/SDL.h>
#endif

#include "verilated.h"
#include <fstream>
#include <iostream>
#include <vector>
#include <cstdint>
#include <cstdio>

const int W = 256;
const int H = 256;

uint32_t framebuffer[W * H];

// Types Definition For 64 Bit Arch
using num_t  = int64_t;
using unum_t = uint64_t;

// Misc Types Definition Organization
using addr_t = unum_t;

using flat = std::vector<uint8_t>;

// Vector Definiton
struct vec_t {
    num_t   ix;
    num_t   iy;
    num_t   iz;

    // Normal Constructor
    vec_t() : ix(), iy(),iz() {};
    // Constructor Params
    vec_t(num_t x, num_t y, num_t z) : ix(x), iy(y),iz(z) {};
    // Constructor Base From Other
    vec_t(const vec_t& v) : ix(v.ix), iy(v.iy), iz(v.iz) {}
};

// Struct That Represents A Face
struct face_t {
    vec_t   _ve1;
    vec_t   _ve2;
    vec_t   _ve3;
    vec_t   _ve4;
    
    face_t()
        : _ve1{},
          _ve2{},
          _ve3{},
          _ve4{}
    {}
};

// Set Write Propertys Of The Cpu
void cpuWrtPropertys(Vcpu &cpu, uint32_t addr, uint8_t value) 
{
    cpu.mem_wrt_addr = addr;
    cpu.mem_wrt_val = value;
    cpu.mem_wrt_bool = 1;
}

// Returns If The Cpu finish to Write
uint8_t cpuWrtFinish(Vcpu &cpu) {
    return ((cpu.mem_wrt_ack & cpu.mem_wrt_bool));
}

// Eval The Cpu In Specific Time
void cpuEvalClk(Vcpu &cpu, uint8_t clkV) {
    cpu.clk = clkV;
    cpu.eval();
}

// Step The Cpu
void cpuStep(Vcpu &cpu) {
    cpuEvalClk(cpu, 0);
    cpuEvalClk(cpu, 1);
}

// Write A Value In The Memory Of The Cpu
void writeMem(Vcpu &cpu, uint32_t addr, uint8_t value)
{
    // Set Cpu Write Indicator
    cpuWrtPropertys(cpu, addr, value);

    // While To The Cpu Finish To Write
    while (!cpuWrtFinish(cpu)) {
        cpuStep(cpu);
    }

    cpu.mem_wrt_bool = 0;

    cpuStep(cpu);
}

// Load A Firmware To The Ram
void loadFirmware(Vcpu &cpu, std::vector<uint8_t>& program) {
    // Load Program
    for (uint32_t i = 0; i < program.size(); i++)
        writeMem(cpu, i, program[i]);

    cpu.eval();
}

// Set Irq Params Of Cpu
void CpuIrqSet(Vcpu &cpu, int ac, int ad, int da) {
    cpu.irq_addr = ad;
    cpu.irq_data = da;
    cpu.irq = ac;
}

// Launch And Stop Irq Of Cpu
void CpuIrqLaunch(Vcpu &cpu, int addr) {
    CpuIrqSet(cpu, 1, addr, 0);
    cpuStep(cpu);
    CpuIrqSet(cpu, 0, 0, 0);
    cpuStep(cpu);
}

// Disk Controller Writer
struct DiskController
{
    // Disk Controller Params
    uint16_t    diskFsMgr       = 0;
    uint16_t    diskSector      = 0;
    uint32_t    diskOutpudDir   = 0;

    // Cpu Access Pointer
    Vcpu&       cpuConected;

    // Disk Raw Data
    flat&       disk;

    // Write Sector To The Disk Ram
    void WriteSectorToRam() {
        //printf("ReadSector %0d Of Disk %0d", diskSector, diskFsMgr);
        flat sub(disk.begin() + diskSector * 512, disk.begin() + (diskSector + 1) * 512);
        for (uint32_t i = diskOutpudDir; (i - diskOutpudDir) < sub.size(); i++) {
            //printf("byte %0d of 512 to %0d\n", i - diskOutpudDir, i);
            writeMem(cpuConected, i, sub[i - diskOutpudDir]);
        }
        writeMem(cpuConected, 0x1C, 1);

    }

    // Resets The Variables Of Controller
    void ResetController() {
        diskFsMgr = 0;
        diskSector = 0;
        diskOutpudDir = 0;
    }

    // Constructor
    DiskController(Vcpu& cpu, flat& disk) : 
        diskFsMgr(),
        diskSector(),
        diskOutpudDir(),
        cpuConected(cpu),
        disk(disk)
    {
    }
};

int main() {
    #ifndef NON_GUI1
    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window* window = SDL_CreateWindow(
        "Pulsar32&64 - 64 bit test (Verilator C++ Display)",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        W * 2, H * 2,
        0
    );

    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, 0);

    SDL_Texture* texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        W, H
    );
    #endif

    std::ifstream diska("test.img", std::ios::binary);
    if (!diska) 
        return 2;
    std::vector<uint8_t> DiskOp(
        (std::istreambuf_iterator<char>(diska)),
        std::istreambuf_iterator<char>()
    );

    Vcpu            cpu;
    DiskController  diskController0(cpu, DiskOp);
    
    auto            MemWrtedValue = &cpu.mem_wrt_vale;
    auto            MemWrtedAc =    &cpu.mem_wrt_ene;
    auto            MemWrtedAddr =  &cpu.mem_wrt_addre;

    diskController0.ResetController();

    //cpu.quiet = 1;
    cpu.clk = 0;
    cpu.reset = 1;

    cpu.irq = 0;
    cpu.irq_addr = 0;
    cpu.irq_data = 0;

    cpu.mem_wrt_bool = 0;
    cpu.mem_rdr_bool = 0;

    std::ifstream file("program.bin", std::ios::binary);

    if (!file)
        return 1;
    
    std::vector<uint8_t> program(
        (std::istreambuf_iterator<char>(file)),
        std::istreambuf_iterator<char>()
    );

    printf("Programa: %zu bytes\n", program.size());

    loadFirmware(cpu, program);

    // algunos ciclos con reset
    for (int i = 0; i < 4; i++) {
        cpu.clk = !cpu.clk;
        cpu.eval();
        cpu.clk = !cpu.clk;
        cpu.eval();
    }

    cpu.reset = 0;

    auto lit = 6800;

    bool replicated = false;

    while (!Verilated::gotFinish() && lit) {
        lit--;
        #ifndef NON_GUI1

        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) lit = 0;
        }
        #endif
        cpuStep(cpu);

        // When The Cpu Writes A Mem Direction
        if (*MemWrtedAc & !replicated) {
            /*printf("Escrito en memoria %0x dato %0x\n",
                *MemWrtedAddr,
                *MemWrtedValue);*/

            // DiskController0 File System To Select
            if (*MemWrtedAddr == 0x18) {
                diskController0.diskFsMgr = (
                    diskController0.diskFsMgr << 8
                ) | *MemWrtedValue;
            }

            // DiskController0 Sector To Select
            if (*MemWrtedAddr == 0x19) {
                diskController0.diskSector = (
                    diskController0.diskSector << 8
                ) | *MemWrtedValue;
            }

            // DiskController0 Direction To Write To Select
            if (*MemWrtedAddr == 0x1A) {
                diskController0.diskOutpudDir = (
                    diskController0.diskOutpudDir << 8
                ) | *MemWrtedValue;
            }

            // DiskController0 Trigger Wrt
            if (*MemWrtedAddr == 0x1B) {
                //cpu.quiet = 1;
                diskController0.WriteSectorToRam();
                diskController0.ResetController();
                cpu.quiet = 0;
                printf("lit %d\n", lit);
            }

            replicated = true;
        }

        // For Avoid Bugs
        else if (cpu.mem_wrt_ene & replicated) {
            replicated = false;
        }

        #ifndef NON_GUI1

        SDL_UpdateTexture(texture, nullptr, framebuffer, W * 4);

        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, nullptr, nullptr);
        SDL_RenderPresent(renderer);
        #endif

    }

    #ifndef NON_GUI1

    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    #endif

}