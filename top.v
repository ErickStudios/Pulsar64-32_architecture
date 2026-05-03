module top(
    input clk,
    input btn_blue_sky
);

    cpu uut(
        .clk(clk),
        .reset(btn_blue_sky)
    );

endmodule