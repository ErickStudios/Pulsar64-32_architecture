module alu(
    input       [7:0]   opcode,
    input       [31:0]  a,
    input       [31:0]  b,
    input               aluActive,
    input               clk,
    output reg  [31:0]  result
);

always @(posedge clk) begin
    if (aluActive == 1) begin
        case(opcode)
            8'h01: result = a + b;
            8'h02: result = a - b;
            8'h03: result = a * b;
            8'h04: result = a / b;
            8'h05: result = a & b;
            8'h06: result = a | b;
            8'h07: result = a ^ b;
            default: result = 0;
        endcase
    end
end

endmodule