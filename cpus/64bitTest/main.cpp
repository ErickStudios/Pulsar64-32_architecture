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

void writeMem(Vcpu &cpu, uint32_t addr, uint8_t value)
{
    cpu.mem_wrt_addr = addr;
    cpu.mem_wrt_val = value;
    cpu.mem_wrt_bool = 1;

    for (size_t ona = 0; ona < 10; ona++) {
        cpu.clk = 0;
        cpu.eval();
        cpu.clk = 1;
        cpu.eval();
    }

    cpu.mem_wrt_bool = 0;

    cpu.clk = 0;
    cpu.eval();
    cpu.clk = 1;
    cpu.eval();
}

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

    Vcpu cpu;

    cpu.clk = 0;
    cpu.reset = 1;

    cpu.irq = 0;
    cpu.irq_addr = 0;
    cpu.irq_data = 0;

    cpu.mem_wrt_bool = 0;
    cpu.mem_rdr_bool = 0;

    std::ifstream file("program.bin", std::ios::binary);

    if (!file) {
        printf("No se pudo abrir program.bin\n");
        return 1;
    }

    std::vector<uint8_t> program(
        (std::istreambuf_iterator<char>(file)),
        std::istreambuf_iterator<char>()
    );

    printf("Programa: %zu bytes\n", program.size());

    for (uint32_t i = 0; i < program.size(); i++) {
        writeMem(cpu, i, program[i]);
    }

    cpu.eval();

    // algunos ciclos con reset
    for (int i = 0; i < 4; i++) {
        cpu.clk = !cpu.clk;
        cpu.eval();
        cpu.clk = !cpu.clk;
        cpu.eval();
    }

    cpu.reset = 0;

    auto lit = 1000;

    while (!Verilated::gotFinish() && lit) {
        #ifndef NON_GUI1

        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) lit = 0;
        }
        #endif
        cpu.clk = 0;
        cpu.eval();

        cpu.clk = 1;
        cpu.eval();

        // aquí puedes revisar salidas
        if (cpu.dev_wrt_en) {
            printf("Escribiendo dispositivo %08x = %02x\n",
                   cpu.dev_wrt_addr,
                   cpu.dev_wrt_val);
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