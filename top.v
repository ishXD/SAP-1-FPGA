module top (
    input CLK,
    input rst
);

wire hlt;
wire clk;
reg [7:0] bus;
wire [7:0] pc_out;
wire [7:0] ir_out;
wire [7:0] reg_a_out;
wire [7:0] reg_b_out;
wire [7:0] adder_out;
wire [7:0] memory_out;
wire [3:0] opcode;
wire[11:0] ctrl_word;
wire inc;
wire load;
wire load_a;
wire load_b;
wire sub;
wire memory_load;
wire [2:0] stage;  

always @(*) begin
	if (ctrl_word[5]) begin
		bus = ir_out;
	end else if (ctrl_word[0]) begin
		bus = adder_out;
	end else if (ctrl_word[3]) begin
		bus = reg_a_out;
	end else if (ctrl_word[7]) begin
		bus = memory_out;
	end else if (ctrl_word[9]) begin
		bus = pc_out;
	end else begin
		bus = 8'b0;
	end
end

clock clock_inst (
    .hlt(ctrl_word[11]),
    .clk_in(CLK),
    .clk_out(clk)
);


pc pc_inst (
    .clk(clk),
    .rst(rst),
    .inc(ctrl_word[10]),
    .out(pc_out)
);


ir ir_inst (
    .clk(clk),
    .rst(rst),
    .load(ctrl_word[6]),
    .bus(bus),
    .out(ir_out)
);


reg_a reg_a_inst (
    .clk(clk),
    .rst(rst),
    .load(ctrl_word[4]),
    .bus(bus),
    .out(reg_a_out)
);

reg_b reg_b_inst (
    .clk(clk),
    .rst(rst),
    .load(ctrl_word[2]),
    .bus(bus),
    .out(reg_b_out)
);


adder adder_inst (
    .a(reg_a_out),
    .b(reg_b_out),
    .sub(ctrl_word[1]),
    .out(adder_out)
);


memory memory_inst (
    .clk(clk),
    .rst(rst),
    .load(ctrl_word[8]),
    .bus(bus),
    .out(memory_out)
);


controller controller_inst (
    .clk(clk),
    .rst(rst),
    .opcode(ir_out[7:4]),
    .out(ctrl_word),
    .stage(stage)  

);

assign hlt = ctrl_word[11];
assign inc = ctrl_word[10];
assign load = ctrl_word[6];
assign load_a = ctrl_word[4];
assign load_b = ctrl_word[2];
assign sub = ctrl_word[1];
assign memory_load = ctrl_word[8];

endmodule
