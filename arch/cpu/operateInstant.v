// ============== function for opers ==============
// | A instant function for the operations regs   |
// | , inms, stack and other modes                |
// |                                              |
// | #FASTER #STARTER                             |
// ------------------------------------------------
function [31:0] operateInstant; input [3:0] modeOpr; input [7:0] bytesLen; begin
    case (modeOpr)
        4'h0: begin
            operateInstant = readINM(bytesLen, pc);
            pc = pc + bytesLen;
        end
        4'h1: begin
            gr.a = memory[pc];
            pc = pc + 1;

            case (gr.a)
                0: operateInstant = gr.result;
                1: operateInstant = gr.valueRegister;
                2: operateInstant = gr.currentPtrAddrs;
                default: operateInstant = 0;
            endcase
        end
        4'h2: begin
            operateInstant = readINM(bytesLen, sp);
            sp = sp + bytesLen;
        end
        default: begin while (1); end
    endcase
end endfunction