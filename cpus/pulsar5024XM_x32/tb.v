module tb;

// ================= MACHINE REGISTERS =================
reg         clk = 0;
reg         reset = 1;
always #1   clk = ~clk;
wire        irq;
wire [31:0] irq_addr;
wire [7:0]  irq_data;
wire        irq1, irq2, irq3, irq4, irq5;
wire [31:0] addr1, addr2, addr3, addr4, addr5;
wire [7:0]  data1, data2, data3, data4, data5;
wire        irq_ack;
wire        irq_ack1, irq_ack2, irq_ack3, irq_ack4, irq_ack5;
reg  [7:0]  selectec_dev;

// ================= CPU ASIGNATION IRQS =================
reg         dev1_enable = 0;
reg         dev2_enable = 0;
reg         dev3_enable = 0;
reg         dev4_enable = 0;
reg         cassete_enable = 0;
reg  [7:0]  dev1_data = 0;
reg  [7:0]  dev2_data = 0;
reg  [7:0]  dev3_data = 0;
reg  [7:0]  dev4_data = 0;
reg  [7:0]  cassete_data = 0;

// ================= SERIAL COM1 PORT =================
reg         com1_rdnxtch = 0;
reg  [7:0]  com1_mode = 0;
reg  [7:0]  com1_next_cmd = 0;
reg         com1_next_char_is_cmd = 0;

// ================= CPU ASIGNATION IRQS =================
assign      irq =   irq1 |
                    irq2 |
                    irq3 |
                    irq4 |
                    irq5;
assign      irq_addr =  (selectec_dev == 1) ? addr1 :
                        (selectec_dev == 2) ? addr2 : 
                        (selectec_dev == 3) ? addr3 : 
                        (selectec_dev == 4) ? addr4 : 
                        (selectec_dev == 5) ? addr5 : 
                        32'b0;
assign      irq_data = (selectec_dev == 1) ? data1 :
                       (selectec_dev == 2) ? data2 : 
                       (selectec_dev == 3) ? data3 : 
                       (selectec_dev == 4) ? data4 : 
                       (selectec_dev == 5) ? data5 : 
                       8'b0;
assign      irq_ack1 = irq_ack & (selectec_dev == 1);
assign      irq_ack2 = irq_ack & (selectec_dev == 2);
assign      irq_ack3 = irq_ack & (selectec_dev == 3);
assign      irq_ack4 = irq_ack & (selectec_dev == 4);
assign      irq_ack5 = irq_ack & (selectec_dev == 5);

// ================= CHIP BUS =================

cpu uut(
    .clk            (clk),
    .reset          (reset),
    .irq            (irq),
    .irq_addr       (irq_addr),
    .irq_data       (irq_data),
    .irq_ack        (irq_ack)
);

// ================= DEVICES BUS =================

device #(.BASE_ADDR(32'h0)) alphaButton(
    .clk            (clk),
    .enable         (dev1_enable),
    .data_in        (dev1_data),
    .irq            (irq1),
    .irq_addr       (addr1),
    .irq_data       (data1),
    .irq_ack        (irq_ack1)
);

device #(.BASE_ADDR(32'h1)) betaButton(
    .clk            (clk),
    .enable         (dev2_enable),
    .data_in        (dev2_data),
    .irq            (irq2),
    .irq_addr       (addr2),
    .irq_data       (data2),
    .irq_ack        (irq_ack2)
);

device #(.BASE_ADDR(32'h2)) upButton(
    .clk            (clk),
    .enable         (dev3_enable),
    .data_in        (dev3_data),
    .irq            (irq3),
    .irq_addr       (addr3),
    .irq_data       (data3),
    .irq_ack        (irq_ack3)
);

device #(.BASE_ADDR(32'h3)) downButton(
    .clk            (clk),
    .enable         (dev4_enable),
    .data_in        (dev4_data),
    .irq            (irq4),
    .irq_addr       (addr4),
    .irq_data       (data4),
    .irq_ack        (irq_ack4)
);

device #(.BASE_ADDR(32'h4)) cassete(
    .clk            (clk),
    .enable         (cassete_enable),
    .data_in        (cassete_data),
    .irq            (irq5),
    .irq_addr       (addr5),
    .irq_data       (data5),
    .irq_ack        (irq_ack5)
);

always @(posedge clk) begin
    // reseteo del puerto serial
    if (reset) begin
        com1_next_cmd = 8'hFF;
        com1_next_char_is_cmd = 0;
        com1_mode = 8'hFF;
        com1_rdnxtch = 0;
    end

    // mandar comandos al com1
    if (uut.cpg.memory[4096] != 0) begin
        com1_next_cmd = uut.cpg.memory[4096];
        uut.cpg.memory[4096] = 0;
        com1_next_char_is_cmd = 1;
    end

    if (uut.cpg.memory[4095] == 0) begin 
        com1_rdnxtch <= 1;
    end
    
    else if (uut.cpg.memory[4095] != 0 && com1_rdnxtch) begin
        com1_rdnxtch <= 0;
        if (com1_next_char_is_cmd && com1_next_cmd == 8'h01) begin
            com1_mode = uut.cpg.memory[4095];
            com1_next_char_is_cmd = 0;
        end
        else begin 
            if (com1_mode == 1) $write("%c", uut.cpg.memory[4095]);
        end
        uut.cpg.memory[4095] <= 0;
    end
    if (irq1) 
        selectec_dev = 1;
    else if (irq2) 
        selectec_dev = 2;
    else if (irq3) 
        selectec_dev = 3;
    else if (irq4) 
        selectec_dev = 4;
    else if (irq5) 
        selectec_dev = 5;
    else 
        selectec_dev = 0;
end

initial begin
    $display("pulsar5024XM_x32 chip debug");
    $readmemh("program.hex", uut.cpg.memory);
    uut.quiet = 1;

    #10 reset = 0;

    #20 cassete_data = 0;
    #1 cassete_enable = 1;
    #2 cassete_enable = 0;

    /*#20 dev1_data = 8'd23;
    #1  dev1_enable = 1;
    #2  dev1_enable = 0;

    #30 dev2_data = 8'd46;
    #1  dev2_enable = 1;
    #2  dev2_enable = 0;

    #40 dev3_data = 8'd46;
    #1  dev3_enable = 1;
    #2  dev3_enable = 0;

    #50 dev4_data = 8'd46;
    #1  dev4_enable = 1;
    #2  dev4_enable = 0;*/

    #2000 $finish;
end

endmodule