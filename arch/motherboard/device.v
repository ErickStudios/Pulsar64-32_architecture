module device #(
    parameter BASE_ADDR = 32'h3000
)(
    input               clk,
    input               enable,
    input               reset,
    input [7:0]         data_in,
    
    output reg          irq,
    output reg [31:0]   irq_addr,
    output reg [7:0]    irq_data,
    input               irq_ack,

    input               wrt_en,
    input [31:0]        wrt_addr,
    input [7:0]         wrt_val
);

reg  [7:0]              device_buffer;
reg                     active;

always @(posedge clk) begin
    if (reset) begin
        irq <= 0;
        active <= 0;
        irq_addr <= 0;
        irq_data <= 0;
        device_buffer <= 0;
    end else begin
        if (wrt_en && (wrt_addr == BASE_ADDR)) begin
            device_buffer <= wrt_val;
        end
        
        if (enable)
            active <= 1;
        if (active && !irq) begin
            irq <= 1;
            irq_addr <= BASE_ADDR;
            irq_data <= data_in;
        end

        if (irq && irq_ack) begin
            irq <= 0;
            active <= 0;
        end
    end
end
endmodule