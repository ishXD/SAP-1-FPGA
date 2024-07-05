module testbench();

    reg CLK;
    reg rst;
    wire hlt;
    wire clk;
    wire [7:0] pc_out;
    wire [7:0] ir_out;
    wire [7:0] reg_a_out;
    wire [7:0] reg_b_out;
    wire load_b;
    wire load_a;
    wire [7:0] adder_out;
    wire [7:0] memory_out;
    wire [3:0] opcode;
    wire [11:0] ctrl_word;
    wire [2:0] stage;
    

    top uut (
        .CLK(CLK),
        .rst(rst)
    );
    wire[4:0] bus_en = {ctrl_word[9],ctrl_word[7],ctrl_word[5],ctrl_word[3],ctrl_word[0]};
    reg[7:0] bus;
    
    always @(*) begin
        case (bus_en)
            5'b00001: bus = adder_out;
            5'b00010: bus = reg_a_out;
            5'b00100: bus = ir_out;
            5'b01000: bus = memory_out;
            5'b10000: bus = pc_out;
            default: bus = 8'b0;
        endcase
    end
    
    // Generate clock signal
    integer i;
    initial begin
        CLK = 0;
        for (i = 0; i < 128; i=i+1) begin
            #1 CLK = ~CLK;
        end
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        #10 rst = 0;
        
        // Monitor signals
        $monitor("Time: %0t | CLK: %b | rst: %b | hlt: %b | opcode: %b | ctrl_word: %b | pc_out: %h | ir_out: %h | reg_a_out: %b | reg_b_out: %b | adder_out: %h | memory_out: %h",
                 $time, CLK, rst, hlt, opcode, ctrl_word, pc_out, ir_out, reg_a_out, reg_b_out, adder_out, memory_out);

        
        // Wait for the system to stabilize
        #100;
        
        #200 $finish;
    end


assign clk = uut.clock_inst.clk_out;
assign hlt = uut.clock_inst.hlt;

assign pc_out = uut.pc_out;
assign ir_out = uut.ir_out;
assign memory_out = uut.memory_out;

assign reg_a_out = uut.reg_a_out;
assign reg_b_out = uut.reg_b_out;
assign adder_out = uut.adder_out;

assign load_a = uut.reg_a_inst.load;
assign load_b = uut.reg_b_inst.load;

assign opcode = uut.controller_inst.opcode;
assign ctrl_word = uut.controller_inst.out;
assign stage = uut.stage;


endmodule
