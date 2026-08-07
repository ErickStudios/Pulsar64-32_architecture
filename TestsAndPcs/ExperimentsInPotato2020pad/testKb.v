module test_kbd;
reg clk=0;
always #5 clk=~clk;

reg [7:0] old_id=8'hFF;
integer fd, ret;
reg [7:0] id, ch;
reg [20:0] div=0;

always @(posedge clk) begin
  div <= div+1;
  if(div==0) begin
    fd = $fopen("DrvBus164302.hex","r");
    if(fd) begin
      ret = $fscanf(fd,"%h", id);
      ret = $fscanf(fd,"%h", ch);
      $fclose(fd);
      if(id != 8'hFF) begin
        if(id != old_id) begin
          $display("LEIDA ID=%h CHAR=%c", id, ch);
          old_id = id;
        end
      end else begin
        old_id = 8'hFF;
      end
    end
  end
end
endmodule
