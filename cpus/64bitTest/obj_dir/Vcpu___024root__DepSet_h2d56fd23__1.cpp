// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcpu.h for the primary calling header

#include "Vcpu__pch.h"
#include "Vcpu___024root.h"

VL_INLINE_OPT void Vcpu___024root___nba_sequent__TOP__1(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___nba_sequent__TOP__1\n"); );
    // Init
    IData/*31:0*/ __Vdly__cpu__DOT__pc;
    __Vdly__cpu__DOT__pc = 0;
    // Body
    Verilated::runFlushCallbacks();
    __Vdly__cpu__DOT__pc = vlSelf->cpu__DOT__i32nextPc;
    vlSelf->cpu__DOT__FirstCycleFromReset = 0U;
    vlSelf->cpu__DOT__pc = __Vdly__cpu__DOT__pc;
    vlSelf->cpu__DOT__selectedinm64 = vlSelf->__Vdly__cpu__DOT__selectedinm64;
    if (vlSelf->__Vdlyvset__cpu__DOT__memory__v0) {
        vlSelf->cpu__DOT__memory[vlSelf->__Vdlyvdim0__cpu__DOT__memory__v0] 
            = vlSelf->__Vdlyvval__cpu__DOT__memory__v0;
    }
    if (vlSelf->__Vdlyvset__cpu__DOT__inms64__v0) {
        vlSelf->cpu__DOT__inms64[vlSelf->__Vdlyvdim0__cpu__DOT__inms64__v0] = 0ULL;
    }
    if (vlSelf->__Vdlyvset__cpu__DOT__i64bytes__v0) {
        vlSelf->cpu__DOT__i64bytes[0U] = vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v0;
    }
    if (vlSelf->__Vdlyvset__cpu__DOT__i64bytes__v1) {
        vlSelf->cpu__DOT__i64bytes[1U] = vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v1;
        vlSelf->cpu__DOT__i64bytes[2U] = vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v2;
        vlSelf->cpu__DOT__i64bytes[3U] = vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v3;
    }
}

void Vcpu___024root___nba_sequent__TOP__0(Vcpu___024root* vlSelf);

void Vcpu___024root___eval_nba(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcpu___024root___nba_sequent__TOP__0(vlSelf);
        Vcpu___024root___nba_sequent__TOP__1(vlSelf);
    }
}

void Vcpu___024root___eval_triggers__act(Vcpu___024root* vlSelf);
void Vcpu___024root___eval_act(Vcpu___024root* vlSelf);

bool Vcpu___024root___eval_phase__act(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vcpu___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vcpu___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vcpu___024root___eval_phase__nba(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vcpu___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__nba(Vcpu___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__act(Vcpu___024root* vlSelf);
#endif  // VL_DEBUG

void Vcpu___024root___eval(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vcpu___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("cpu.v", 261, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vcpu___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("cpu.v", 261, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vcpu___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vcpu___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vcpu___024root___eval_debug_assertions(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((vlSelf->irq & 0xfeU))) {
        Verilated::overWidthError("irq");}
    if (VL_UNLIKELY((vlSelf->mem_wrt_bool & 0xfeU))) {
        Verilated::overWidthError("mem_wrt_bool");}
    if (VL_UNLIKELY((vlSelf->mem_rdr_bool & 0xfeU))) {
        Verilated::overWidthError("mem_rdr_bool");}
}
#endif  // VL_DEBUG
