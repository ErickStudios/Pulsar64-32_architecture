module tb;

// ================= MACHINE PARAMS =================
localparam UARTConAddr = 32'h100000;    // Uart COM1 Addr
localparam FirmwareSize= 32'h7FFF;         // Firmware Size

// ================= MACHINE REGISTERS =================
reg         SoftClock = 0;
reg         SoftReset = 1;
reg         HardReset = 0;
always #1   SoftClock = ~SoftClock;
reg         IrqBool;
reg  [31:0] IrqAddr;
reg  [7:0]  IrqData;
wire        IrqAck;
reg  [7:0]  selectec_dev;

wire [31:0] WrtedDir;
wire [7:0]  WrtedVal;
wire        WrtedEvL;

reg  [31:0] WrtExtDir;
reg  [7:0]  WrtExtVal;
reg         WrtExtAct;
wire        WrtSucces;

wire        RdrSucces;
reg         CanContinue = 0;
reg         CpuQuiet = 0;

reg  [7:0]  FirmwareROM [0:FirmwareSize];
reg  [31:0] FdROMCpyInd = 0;
reg         PcCpyFdFile = 0;
reg         PcCpyFdPending = 1;

// ================= CHIP BUS =================

cpu uut(
    .clk            (SoftClock),
    .reset          (SoftReset),
    .irq            (IrqBool),
    .irq_addr       (IrqAddr),
    .irq_data       (IrqData),
    .irq_ack        (IrqAck),
    .mem_wrt_addre  (WrtedDir),
    .mem_wrt_ene    (WrtedEvL),
    .mem_wrt_vale   (WrtedVal),
    .mem_wrt_addr   (WrtExtDir),
    .mem_wrt_val    (WrtExtVal),
    .mem_wrt_bool   (WrtExtAct),
    .mem_wrt_ack    (WrtSucces),
    .mem_rdr_ack    (RdrSucces),
    .quiet          (CpuQuiet)
);

// Direction Checker
function chkMe;
input [31:0] dir;
begin
    chkMe = WrtedEvL & WrtedDir == dir;
end
endfunction

// Char Debugger
task debugChar;
input [7:0] char;
begin $write("%c", char); end
endtask

// Continuer Of the Writing Blk
always @(WrtSucces) begin
    if (!HardReset) begin
        // Continue With Write For Send Signal
        if (WrtExtAct & WrtSucces & !CanContinue) begin
            WrtExtAct <= 0;
            CanContinue <= 1;
        end
    end
end

// Continue Unabled For Dont Repeat
always @(posedge SoftClock) begin
    // If Continue Its Actived
    if (CanContinue) begin
        CanContinue <= 0;

        // Routine For Coppy Rom
        if (PcCpyFdFile) begin
            FdROMCpyInd <= FdROMCpyInd + 1;
            WrtExtDir <= FdROMCpyInd;
            WrtExtAct <= 1;
            WrtExtVal <= FirmwareROM[FdROMCpyInd];

            if (FdROMCpyInd >= FirmwareSize - 1) begin
                PcCpyFdFile <= 0; 
                SoftReset <= 0;
            end
        end
    end
end

// Reset Function For The Machine
always @(posedge SoftClock or posedge HardReset) begin
    // Hard Reset
    if (HardReset) begin
        // Initialize reset coppy function
        FdROMCpyInd    <= 0;
        WrtExtAct      <= 0;
        PcCpyFdPending <= 0;
        PcCpyFdFile    <= 1;
        CanContinue    <= 1;
    end
end

// Serial COM1 multiplexor
always @(WrtedEvL) begin
    if (chkMe(UARTConAddr)) 
        debugChar(WrtedVal);
end

initial begin
    // Load Fd Image
    $display    ("pulsar5024XM_x32 chip debug");
    $readmemh   ("program.hex", FirmwareROM);

    // Initialize For First Time
    #10         HardReset = 1;
    #1          HardReset = 0;

    // Finish Simulation
    #1000000    $finish;
end

endmodule