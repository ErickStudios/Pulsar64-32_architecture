// MK/HK ATB X1-64302 Simulated In Verilog
// 
// The First Named Test That Boots up!!!
// Si la Primera que enciende
module tb;

// === Solsar Placa ===
localparam  BusCOBStart =         32'h0001;

// === Soldar Componentes en la Placa ===
localparam  BoardSerialOffset =   32'h0000;
localparam  BoardKeybOffset   =   32'h1000;

// === Bus Extern ===
wire        BusWrtEv; // Event Activation
wire [31:0] BusWrtA ; // Addr:Part0
wire [31:0] BusWrtA2; // Addr:Part1
wire [7:0]  BusWrtV ; // Value8
wire [63:0] BusWrtV2; // Full Valu

// === Bis Dev ===
reg         BusKReady = 0;

// === Exterior ===
reg clk =     0;	  // Clock
reg reset =   1;	  // Reset Soft
reg quiet =   1;	  // Quiet
always #5 clk = ~clk; // Clock Steps

cpu uut(
    .reset  (reset),
    .clk    (clk),
    .quiet  (quiet),
    .mem_wrt_ene(BusWrtEv),
    .mem_wrt_addre(BusWrtA),
    .mem_buquasar64(BusWrtA2),
    .mem_wrt_vale(BusWrtV),
    .mem_wrt_vale_fx(BusWrtV2)
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
	if (BusWrtEv) begin
		// MMIO region
		if (BusWrtA2 == BusCOBStart) begin
			// SerialConsole
			if (BusWrtA == BoardSerialOffset) debugChar(BusWrtV2[7:0]);
			// Keyb
			if (BusWrtA == BoardKeybOffset) BusKReady = 1;
		end
	end
end

reg [8*100:0] line; // buffer de 100 chars
integer fd, ret;

initial begin
    $readmemh("FirmwareHex.hex", uut.memory); 
    #10       reset = 0;

    forever begin
    	#10;
    	@(posedge BusKReady);
    	$write("[PCInput] :: ");
    	fd = $fopen("DrvBus164302.hex","r");
    	ret = $fgets(line, fd); // lee 1 línea con todo y \
    	$display("linea: %s", line);
    	$fclose(fd);
    	BusKReady = 0;
    end
    //#1000000  $finish;
end

endmodule
