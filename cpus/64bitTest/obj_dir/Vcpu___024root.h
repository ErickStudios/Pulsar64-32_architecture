// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vcpu.h for the primary calling header

#ifndef VERILATED_VCPU___024ROOT_H_
#define VERILATED_VCPU___024ROOT_H_  // guard

#include "verilated.h"


class Vcpu__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vcpu___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(clk,0,0);
        VL_IN8(reset,0,0);
        VL_IN8(irq,0,0);
        VL_IN8(irq_data,7,0);
        VL_OUT8(irq_ack,0,0);
        VL_IN8(mem_wrt_val,7,0);
        VL_IN8(mem_wrt_bool,0,0);
        VL_OUT8(mem_rdr_val,7,0);
        VL_IN8(mem_rdr_bool,0,0);
        VL_OUT8(dev_wrt_en,0,0);
        VL_OUT8(dev_wrt_val,7,0);
        VL_OUT8(mem_wrt_ene,0,0);
        VL_OUT8(mem_wrt_vale,7,0);
        VL_OUT8(mem_wrt_ack,0,0);
        VL_OUT8(mem_rdr_ack,0,0);
        CData/*7:0*/ cpu__DOT__ir;
        CData/*7:0*/ cpu__DOT__mode;
        CData/*7:0*/ cpu__DOT__operationModes;
        CData/*7:0*/ cpu__DOT__flags;
        CData/*7:0*/ cpu__DOT__OprOperator;
        CData/*7:0*/ cpu__DOT__OprOperationBytes;
        CData/*7:0*/ cpu__DOT__valueRegister;
        CData/*0:0*/ cpu__DOT__paused;
        CData/*1:0*/ cpu__DOT__CWFDD;
        CData/*1:0*/ cpu__DOT__CWFDM;
        CData/*0:0*/ cpu__DOT__FirstCycleFromReset;
        CData/*0:0*/ cpu__DOT__in64Bit;
        CData/*7:0*/ cpu__DOT__selectedinm64;
        CData/*0:0*/ cpu__DOT__i64pend;
        CData/*3:0*/ cpu__DOT__i64inmba;
        CData/*3:0*/ cpu__DOT__i64bysiz;
        CData/*3:0*/ cpu__DOT__i64opr;
        CData/*0:0*/ cpu__DOT__i64runinbg;
        CData/*1:0*/ cpu__DOT__aluState;
        CData/*0:0*/ cpu__DOT__aluActive;
        CData/*7:0*/ cpu__DOT____Vlvbound_h0326829d__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h2b8ba7ae__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h2ab45358__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h2ab468a5__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_hb655dcef__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_hf3b9d3de__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_ha9edd24f__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8a4516e8__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acd03a6__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acd1833__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acc67c4__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acd7351__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8ad3f2a6__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8ad3c5b3__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_ha9edd24f__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8a4516e8__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acd03a6__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acd1833__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acc67c4__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8acd7351__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8ad3f2a6__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_h8ad3c5b3__1;
        CData/*7:0*/ cpu__DOT____Vlvbound_haebc3523__0;
        CData/*7:0*/ cpu__DOT____Vlvbound_h11e7610a__0;
        CData/*0:0*/ cpu__DOT__alu0__DOT__fpu_a_sig;
        CData/*7:0*/ cpu__DOT__alu0__DOT__fpu_a_exp;
        CData/*0:0*/ cpu__DOT__alu0__DOT__fpu_b_sig;
        CData/*7:0*/ cpu__DOT__alu0__DOT__fpu_b_exp;
        CData/*0:0*/ cpu__DOT__alu0__DOT__fpu_r_sig;
    };
    struct {
        CData/*7:0*/ cpu__DOT__alu0__DOT__fpu_r_exp;
        CData/*7:0*/ cpu__DOT__alu0__DOT__exp_diff;
        CData/*7:0*/ __Vdlyvval__cpu__DOT__memory__v0;
        CData/*0:0*/ __Vdlyvset__cpu__DOT__memory__v0;
        CData/*7:0*/ __Vdly__cpu__DOT__selectedinm64;
        CData/*3:0*/ __Vdlyvdim0__cpu__DOT__inms64__v0;
        CData/*0:0*/ __Vdlyvset__cpu__DOT__inms64__v0;
        CData/*7:0*/ __Vdlyvval__cpu__DOT__i64bytes__v0;
        CData/*0:0*/ __Vdlyvset__cpu__DOT__i64bytes__v0;
        CData/*7:0*/ __Vdlyvval__cpu__DOT__i64bytes__v1;
        CData/*0:0*/ __Vdlyvset__cpu__DOT__i64bytes__v1;
        CData/*7:0*/ __Vdlyvval__cpu__DOT__i64bytes__v2;
        CData/*7:0*/ __Vdlyvval__cpu__DOT__i64bytes__v3;
        CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
        CData/*0:0*/ __VactContinue;
        VL_IN(irq_addr,31,0);
        VL_IN(mem_wrt_addr,31,0);
        VL_IN(mem_rdr_addr,31,0);
        VL_OUT(dev_wrt_addr,31,0);
        VL_OUT(mem_wrt_addre,31,0);
        IData/*31:0*/ cpu__DOT__pc;
        IData/*31:0*/ cpu__DOT__sp;
        IData/*31:0*/ cpu__DOT__currentPtrAddrs;
        IData/*31:0*/ cpu__DOT__a;
        IData/*31:0*/ cpu__DOT__b;
        IData/*31:0*/ cpu__DOT__tempReg;
        IData/*31:0*/ cpu__DOT__result;
        IData/*31:0*/ cpu__DOT__r0;
        IData/*31:0*/ cpu__DOT__r1;
        IData/*31:0*/ cpu__DOT__r2;
        IData/*31:0*/ cpu__DOT__r3;
        IData/*31:0*/ cpu__DOT__r4;
        IData/*31:0*/ cpu__DOT__r5;
        IData/*31:0*/ cpu__DOT__r6;
        IData/*31:0*/ cpu__DOT__r7;
        IData/*31:0*/ cpu__DOT__i32nextPc;
        IData/*31:0*/ cpu__DOT__offset;
        IData/*31:0*/ cpu__DOT__irq_vector;
        IData/*31:0*/ cpu__DOT__aluA;
        IData/*31:0*/ cpu__DOT__aluB;
        IData/*31:0*/ cpu__DOT__aluResult;
        IData/*31:0*/ cpu__DOT__i;
        IData/*22:0*/ cpu__DOT__alu0__DOT__fpu_a_mat;
        IData/*22:0*/ cpu__DOT__alu0__DOT__fpu_b_mat;
        IData/*22:0*/ cpu__DOT__alu0__DOT__fpu_r_mat;
        IData/*24:0*/ cpu__DOT__alu0__DOT__mat_a_ext;
        IData/*24:0*/ cpu__DOT__alu0__DOT__mat_b_ext;
        IData/*24:0*/ cpu__DOT__alu0__DOT__sum_mat;
        IData/*20:0*/ __Vdlyvdim0__cpu__DOT__memory__v0;
        IData/*31:0*/ __VactIterCount;
        QData/*63:0*/ cpu__DOT__i64CpuTbl;
        QData/*63:0*/ cpu__DOT__i64a;
        QData/*63:0*/ cpu__DOT__i64b;
        QData/*63:0*/ cpu__DOT__i64memre;
        QData/*63:0*/ cpu__DOT__i64temp;
        QData/*63:0*/ cpu__DOT__xsp;
        QData/*63:0*/ cpu__DOT__i64lnk;
        QData/*63:0*/ cpu__DOT__x0;
        QData/*63:0*/ cpu__DOT__x1;
        QData/*63:0*/ cpu__DOT__x2;
        QData/*63:0*/ cpu__DOT__x3;
        QData/*63:0*/ cpu__DOT__x4;
        QData/*63:0*/ cpu__DOT__x5;
        QData/*63:0*/ cpu__DOT__x6;
    };
    struct {
        QData/*63:0*/ cpu__DOT__i64as;
        QData/*63:0*/ cpu__DOT__i64bs;
        QData/*63:0*/ cpu__DOT__i64cs;
        QData/*63:0*/ cpu__DOT__i64ds;
        QData/*63:0*/ cpu__DOT__i64es;
        QData/*63:0*/ cpu__DOT__i64fs;
        QData/*63:0*/ cpu__DOT__i64gs;
        QData/*63:0*/ cpu__DOT__i64proMemStart;
        QData/*63:0*/ cpu__DOT__i64proMemEnd;
        QData/*63:0*/ cpu__DOT__i64irqsft;
        QData/*63:0*/ cpu__DOT__i64perms;
        QData/*63:0*/ cpu__DOT__xpc;
        QData/*63:0*/ cpu__DOT__i64srhelperEx;
        QData/*47:0*/ cpu__DOT__alu0__DOT__mul_mat;
        QData/*47:0*/ cpu__DOT__alu0__DOT__div_mat;
        VlUnpacked<CData/*7:0*/, 2000000> cpu__DOT__memory;
        VlUnpacked<QData/*63:0*/, 16> cpu__DOT__inms64;
        VlUnpacked<CData/*7:0*/, 4> cpu__DOT__i64bytes;
    };
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vcpu__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vcpu___024root(Vcpu__Syms* symsp, const char* v__name);
    ~Vcpu___024root();
    VL_UNCOPYABLE(Vcpu___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
