module fillingShiftReg_TB;
	parameter MAPPER_PARALLELISM = 8; // initial value

	reg									clk;
	reg									reset;
	reg [MAPPER_PARALLELISM-1:0] 			d;
	reg [$clog2(MAPPER_PARALLELISM)-1:0]	c;
	wire [MAPPER_PARALLELISM-1:0] 			b;
	wire									data_in_fifo_rd_req;

	fillingShiftReg #(
	.MAPPER_PARALLELISM(MAPPER_PARALLELISM)
	) fillingShiftReg_instance (
		.clk(clk),
		.reset(reset),
		.d(d),
		.c(c),
		.b(b),
		.data_in_fifo_rd_req(data_in_fifo_rd_req)
	);


	initial begin
		d = 8'b11111111;
		c = 3'b000;
		clk = 1'b0;
		reset = 1'b0;
		#100 reset = 1'b1;
		#100 reset = 1'b0;
		#30 c = 3'b011;
	end

	always
	#10 clk = !clk;

endmodule