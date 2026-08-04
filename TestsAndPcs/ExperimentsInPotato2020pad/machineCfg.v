module tb;

// === Soldar Componentes ===
localparam  SimpleUartAddr = 32'h10000;

// === Bus Extern ===
wire        BusWrtEv;
wire [31:0] BusWrtA ;
wire [7:0]  BusWrtV ;

// === Exterior ===
reg clk =     0;
reg reset =   1;
reg quiet =   1;

always #5     clk = ~clk;

cpu uut(
    .reset  (reset),
    .clk    (clk),
    .quiet  (quiet),
    .mem_wrt_ene(BusWrtEv),
    .mem_wrt_addre(BusWrtA),
    .mem_wrt_vale(BusWrtV)
);

// Direction Checker
function chkMe;
input [31:0] dir;
begin
    chkMe = BusWrtEv  & (BusWrtA == dir);
end
endfunction

// Char Debugger
task debugChar;
input [7:0] char;
begin $write("%c", char); end
endtask

always @(BusWrtEv) begin
   if (chkMe(SimpleUartAddr)) begin
       debugChar(BusWrtV);
    end
end

initial begin
    $readmemh("FirmwareHex.hex", uut.memory); 
    #10       reset = 0;
    #1000000  $finish;
end

endmodule
