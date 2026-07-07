// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcpu.h for the primary calling header

#include "Vcpu__pch.h"
#include "Vcpu___024root.h"

VL_ATTR_COLD void Vcpu___024root___eval_static__TOP(Vcpu___024root* vlSelf);

VL_ATTR_COLD void Vcpu___024root___eval_static(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_static\n"); );
    // Body
    Vcpu___024root___eval_static__TOP(vlSelf);
}

VL_ATTR_COLD void Vcpu___024root___eval_static__TOP(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_static__TOP\n"); );
    // Body
    vlSelf->cpu__DOT__i32nextPc = 0U;
    vlSelf->cpu__DOT__i64pend = 0U;
    vlSelf->cpu__DOT__i64inmba = 0U;
    vlSelf->cpu__DOT__i64bysiz = 0U;
    vlSelf->cpu__DOT__i64opr = 0U;
    vlSelf->cpu__DOT__i64runinbg = 0U;
    vlSelf->cpu__DOT__i64irqsft = 0xffffffffffffffffULL;
    vlSelf->cpu__DOT__i64perms = 0xffffffffffffffffULL;
    vlSelf->cpu__DOT__xpc = 0ULL;
}

VL_ATTR_COLD void Vcpu___024root___eval_initial(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
}

VL_ATTR_COLD void Vcpu___024root___eval_final(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vcpu___024root___eval_settle(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__act(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcpu___024root___dump_triggers__nba(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcpu___024root___ctor_var_reset(Vcpu___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcpu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->irq = VL_RAND_RESET_I(1);
    vlSelf->irq_addr = VL_RAND_RESET_I(32);
    vlSelf->irq_data = VL_RAND_RESET_I(8);
    vlSelf->irq_ack = VL_RAND_RESET_I(1);
    vlSelf->mem_wrt_val = VL_RAND_RESET_I(8);
    vlSelf->mem_wrt_addr = VL_RAND_RESET_I(32);
    vlSelf->mem_wrt_bool = VL_RAND_RESET_I(1);
    vlSelf->mem_rdr_val = VL_RAND_RESET_I(8);
    vlSelf->mem_rdr_addr = VL_RAND_RESET_I(32);
    vlSelf->mem_rdr_bool = VL_RAND_RESET_I(1);
    vlSelf->dev_wrt_en = VL_RAND_RESET_I(1);
    vlSelf->dev_wrt_addr = VL_RAND_RESET_I(32);
    vlSelf->dev_wrt_val = VL_RAND_RESET_I(8);
    vlSelf->mem_wrt_ene = VL_RAND_RESET_I(1);
    vlSelf->mem_wrt_addre = VL_RAND_RESET_I(32);
    vlSelf->mem_wrt_vale = VL_RAND_RESET_I(8);
    vlSelf->mem_wrt_ack = VL_RAND_RESET_I(1);
    vlSelf->mem_rdr_ack = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 2000000; ++__Vi0) {
        vlSelf->cpu__DOT__memory[__Vi0] = VL_RAND_RESET_I(8);
    }
    vlSelf->cpu__DOT__pc = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__sp = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__currentPtrAddrs = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__a = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__b = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__tempReg = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__result = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r0 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r1 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r2 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r3 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r4 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r5 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r6 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__r7 = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__i32nextPc = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__ir = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__mode = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__operationModes = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__flags = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__OprOperator = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__OprOperationBytes = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__valueRegister = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__offset = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__irq_vector = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__paused = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__CWFDD = VL_RAND_RESET_I(2);
    vlSelf->cpu__DOT__CWFDM = VL_RAND_RESET_I(2);
    vlSelf->cpu__DOT__FirstCycleFromReset = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__in64Bit = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->cpu__DOT__inms64[__Vi0] = VL_RAND_RESET_Q(64);
    }
    vlSelf->cpu__DOT__selectedinm64 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__i64CpuTbl = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64a = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64b = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64memre = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64temp = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__xsp = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64lnk = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x0 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x1 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x2 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x3 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x4 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x5 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__x6 = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64as = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64bs = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64cs = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64ds = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64es = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64fs = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64gs = VL_RAND_RESET_Q(64);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->cpu__DOT__i64bytes[__Vi0] = VL_RAND_RESET_I(8);
    }
    vlSelf->cpu__DOT__i64pend = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__i64inmba = VL_RAND_RESET_I(4);
    vlSelf->cpu__DOT__i64bysiz = VL_RAND_RESET_I(4);
    vlSelf->cpu__DOT__i64opr = VL_RAND_RESET_I(4);
    vlSelf->cpu__DOT__i64runinbg = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__i64proMemStart = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64proMemEnd = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__aluA = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__aluB = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__aluResult = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__aluState = VL_RAND_RESET_I(2);
    vlSelf->cpu__DOT__aluActive = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__i = VL_RAND_RESET_I(32);
    vlSelf->cpu__DOT__i64irqsft = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64perms = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__xpc = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT__i64srhelperEx = VL_RAND_RESET_Q(64);
    vlSelf->cpu__DOT____Vlvbound_h0326829d__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h2b8ba7ae__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h2ab45358__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h2ab468a5__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_hb655dcef__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_hf3b9d3de__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_ha9edd24f__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8a4516e8__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acd03a6__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acd1833__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acc67c4__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acd7351__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8ad3f2a6__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8ad3c5b3__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_ha9edd24f__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8a4516e8__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acd03a6__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acd1833__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acc67c4__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8acd7351__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8ad3f2a6__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h8ad3c5b3__1 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_haebc3523__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT____Vlvbound_h11e7610a__0 = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__alu0__DOT__fpu_a_sig = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__alu0__DOT__fpu_a_exp = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__alu0__DOT__fpu_a_mat = VL_RAND_RESET_I(23);
    vlSelf->cpu__DOT__alu0__DOT__fpu_b_sig = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__alu0__DOT__fpu_b_exp = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__alu0__DOT__fpu_b_mat = VL_RAND_RESET_I(23);
    vlSelf->cpu__DOT__alu0__DOT__fpu_r_sig = VL_RAND_RESET_I(1);
    vlSelf->cpu__DOT__alu0__DOT__fpu_r_exp = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__alu0__DOT__fpu_r_mat = VL_RAND_RESET_I(23);
    vlSelf->cpu__DOT__alu0__DOT__exp_diff = VL_RAND_RESET_I(8);
    vlSelf->cpu__DOT__alu0__DOT__mat_a_ext = VL_RAND_RESET_I(25);
    vlSelf->cpu__DOT__alu0__DOT__mat_b_ext = VL_RAND_RESET_I(25);
    vlSelf->cpu__DOT__alu0__DOT__sum_mat = VL_RAND_RESET_I(25);
    vlSelf->cpu__DOT__alu0__DOT__mul_mat = VL_RAND_RESET_Q(48);
    vlSelf->cpu__DOT__alu0__DOT__div_mat = VL_RAND_RESET_Q(48);
    vlSelf->__Vdlyvdim0__cpu__DOT__memory__v0 = 0;
    vlSelf->__Vdlyvval__cpu__DOT__memory__v0 = VL_RAND_RESET_I(8);
    vlSelf->__Vdlyvset__cpu__DOT__memory__v0 = 0;
    vlSelf->__Vdly__cpu__DOT__selectedinm64 = VL_RAND_RESET_I(8);
    vlSelf->__Vdlyvdim0__cpu__DOT__inms64__v0 = 0;
    vlSelf->__Vdlyvset__cpu__DOT__inms64__v0 = 0;
    vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v0 = VL_RAND_RESET_I(8);
    vlSelf->__Vdlyvset__cpu__DOT__i64bytes__v0 = 0;
    vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v1 = VL_RAND_RESET_I(8);
    vlSelf->__Vdlyvset__cpu__DOT__i64bytes__v1 = 0;
    vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v2 = VL_RAND_RESET_I(8);
    vlSelf->__Vdlyvval__cpu__DOT__i64bytes__v3 = VL_RAND_RESET_I(8);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
}
