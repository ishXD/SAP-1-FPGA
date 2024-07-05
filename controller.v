module controller(
    input clk,
    input rst,
    input [3:0] opcode,
    output [11:0] out,
    output reg [2:0] stage  // Expose stage as output
);

localparam SIG_HLT_VALUE       = 11;
localparam SIG_PC_INC_VALUE    = 10;
localparam SIG_PC_EN_VALUE     = 9;
localparam SIG_MEM_LOAD_VALUE  = 8;
localparam SIG_MEM_EN_VALUE    = 7;
localparam SIG_IR_LOAD_VALUE   = 6;
localparam SIG_IR_EN_VALUE     = 5;
localparam SIG_A_LOAD_VALUE    = 4;
localparam SIG_A_EN_VALUE      = 3;
localparam SIG_B_LOAD_VALUE    = 2;
localparam SIG_ADDER_SUB_VALUE = 1;
localparam SIG_ADDER_EN_VALUE  = 0;

localparam OP_LDA = 4'b0000;
localparam OP_ADD = 4'b0001;
localparam OP_SUB = 4'b0010;
localparam OP_HLT = 4'b1111;

reg [11:0] ctrl_word;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= 0;
    end else begin
        if (stage == 5) begin
            stage <= 0;
        end else begin
            stage <= stage + 1;
        end
    end
end

always @(*) begin
    ctrl_word = 12'b0;

    case (stage)
        0: begin
            ctrl_word[SIG_PC_EN_VALUE] = 1;
            ctrl_word[SIG_MEM_LOAD_VALUE] = 1;
        end
        1: begin
            ctrl_word[SIG_PC_INC_VALUE] = 1;
        end
        2: begin
            ctrl_word[SIG_MEM_EN_VALUE] = 1;
            ctrl_word[SIG_IR_LOAD_VALUE] = 1;
        end
        3: begin
            case (opcode)
                OP_LDA: begin
                    ctrl_word[SIG_IR_EN_VALUE] = 1;
                    ctrl_word[SIG_MEM_LOAD_VALUE] = 1;
                end
                OP_ADD: begin
                    ctrl_word[SIG_IR_EN_VALUE] = 1;
                    ctrl_word[SIG_MEM_LOAD_VALUE] = 1;
                end
                OP_SUB: begin
                    ctrl_word[SIG_IR_EN_VALUE] = 1;
                    ctrl_word[SIG_MEM_LOAD_VALUE] = 1;
                end
                OP_HLT: begin
                    ctrl_word[SIG_HLT_VALUE] = 1;
                end
            endcase
        end
        4: begin
            case (opcode)
                OP_LDA: begin
                    ctrl_word[SIG_MEM_EN_VALUE] = 1;
                    ctrl_word[SIG_A_LOAD_VALUE] = 1;
                end
                OP_ADD: begin
                    ctrl_word[SIG_MEM_EN_VALUE] = 1;
                    ctrl_word[SIG_B_LOAD_VALUE] = 1;
                end
                OP_SUB: begin
                    ctrl_word[SIG_MEM_EN_VALUE] = 1;
                    ctrl_word[SIG_B_LOAD_VALUE] = 1;
                end
            endcase
        end
        5: begin
            case (opcode)
                OP_ADD: begin
                    ctrl_word[SIG_ADDER_EN_VALUE] = 1;
                    ctrl_word[SIG_A_LOAD_VALUE] = 1;
                end
                OP_SUB: begin
                    ctrl_word[SIG_ADDER_SUB_VALUE] = 1;
                    ctrl_word[SIG_ADDER_EN_VALUE] = 1;
                    ctrl_word[SIG_A_LOAD_VALUE] = 1;
                end
            endcase
        end
    endcase
end

assign out = ctrl_word;



endmodule
