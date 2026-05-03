module cpu(
    input       clk,
    input       reset
);

// machine variables use for the runtime
reg  [7:0]      memory                  [0:64000];  // the memory
reg  [7:0]      pc;                                 // the program counter
reg  [31:0]     sp;                                 // the stack pointer
reg  [7:0]      reg8                    [0:15];     // registers8
reg  [15:0]     reg16                   [0:15];     // registers16
reg  [31:0]     reg32                   [0:15];     // registers32
reg  [7:0]      opcode;                             // current opcode
reg  [7:0]      mode;                               // mode of the operation
reg  [31:0]     currentPtrAddrs;                    // register of the current uint8_t* ptr
wire [7:0]      PXB1 = currentPtrAddrs  [31:24];    // byte 1 of PX
wire [7:0]      PXB2 = currentPtrAddrs  [23:16];    // byte 2 of PX
wire [7:0]      PXB3 = currentPtrAddrs  [15:8];     // byte 3 of PX
wire [7:0]      PXB4 = currentPtrAddrs  [7:0];      // byte 4 of PX
reg  [7:0]      OprOperator;                        // operator operation
reg  [7:0]      OprOperationBytes;                  // operation bytes length
reg  [7:0]      valueRegister;                      // DX = *(uint8_t*)PX
reg  [7:0]      op_id;                              // operation id
reg  [31:0]     a, b, result;                       // result
reg  [7:0]      ir;                                 // current opcode instruction

// every clock cycle
always @(posedge clk) begin
    // reset signal power on/restart computer
    if (reset) begin
        pc <= 0;
        sp <= 63000;
        ir <= 0;
    // tick of click
    end else begin
        // fetch instruction
        ir <= memory[pc];                           // current instruction
        pc <= pc + 1;                               // increment program counter

        case (ir)
            // LPX = Load Pointer eXpretion
            8'h01: begin
                // fetch mode
                mode = memory[pc];
                pc = pc + 1;
                // mode of operation
                case (mode)
                    // from inmediate
                    8'h20: begin
                        currentPtrAddrs = {
                            memory      [pc],       // blk1
                            memory      [pc+1],     // blk2
                            memory      [pc+2],     // blk3
                            memory      [pc+3]      // blk4
                        };
                        pc = pc + 4;                // increment pc
                        $display("INM32      LPX 0x%x", currentPtrAddrs);
                        pc = pc + 1;                // increment pc         
                    end
                    // from stack
                    8'h1A: begin
                        $display("STACK32    LPX");
                        currentPtrAddrs = {
                            memory      [sp],       // blk1
                            memory      [sp+1],     // blk2
                            memory      [sp+2],     // blk3
                            memory      [sp+3]      // blk4
                        };
                         sp = sp + 4;               // increment pc 
                    end
                endcase
            end
            // LDX = Load From Memory To Data RegiXter (Data Register = valueRegister beta name)
            8'h02: begin
                $display("REGISTER8  LDX");
                valueRegister = memory[currentPtrAddrs];
            end
            // PUS = Push Unity or regiSter
            8'h03: begin
                mode = memory[pc];
                pc = pc + 1;

                case (mode)
                    // push a register
                    8'h1F: begin
                        // the register to push
                        case (memory[pc]) 
                            // place the pointer address reigster (32 bits)
                            8'h00: begin
                                $display("REGISTER32 PUS $currentPtrAddrs");
                                sp = sp - 1;        // blk4 starts
                                memory[sp] = PXB4;  // blk4
                                sp = sp - 1;        // blk3 starts
                                memory[sp] = PXB3;  // blk3
                                sp = sp - 1;        // blk2 starts
                                memory[sp] = PXB2;  // blk2
                                sp = sp - 1;        // blk1 starts
                                memory[sp] = PXB1;  // blk1
                            end
                            // place the value saved register (8 bits)
                            8'h01: begin 
                                $display("REGISTER8  PUS $valueRegister");
                                sp = sp - 1;        // push a register
                                memory[sp] = valueRegister;
                            end
                        endcase
                        pc = pc + 1;
                    end
                endcase

                pc = pc + 1;
            end
            // OPR = Operation Propurse with Result
            8'h04: begin
                // fetch mode
                OprOperator = memory[pc];           // operator
                OprOperationBytes = memory[pc + 1]; // operation bytes len
                pc = pc + 2;                        // increment pc

                //a = stack[sp - 2];
                //b = stack[sp - 1];
                $write("ANONYMUS");
                if ((OprOperationBytes * 8) < 10)
                    $write("%0d ", OprOperationBytes * 8);
                else
                    $write("%0d", OprOperationBytes * 8);
                $write(" OPR %d\n", OprOperator);

                /*case (op_id)
                    8'h01: result <= a + b;
                    8'h02: result <= a - b;
                    8'h03: result <= a * b;
                    8'h04: result <= a / b;
                endcase*/

                //sp <= sp - 2;
                //stack[sp - 2] <= result;
                //sp <= sp - 1;
            end

        endcase
    end
end

endmodule