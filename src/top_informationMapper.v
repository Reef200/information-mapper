module top_informationMapper
#(parameter MAPPER_PARALLELISM = 8)(
	input 									clk,
	input 									reset,
	input [MAPPER_PARALLELISM-1:0] 			data_in_fifo_rd_data,
	input [MAPPER_PARALLELISM-1:0] 			mapping_indicators,
	output									data_in_fifo_rd_req,
	output [MAPPER_PARALLELISM-1:0] 		data_out_fifo_wr_data
);

	//	declaration and assignment of connectors
	wire [MAPPER_PARALLELISM-1:0]								 b;
	wire [(MAPPER_PARALLELISM)*$clog2(MAPPER_PARALLELISM) - 1:0] c;
	wire [MAPPER_PARALLELISM-1:0] 								 d;
	wire [MAPPER_PARALLELISM-1:0]								 m;
	assign d = data_in_fifo_rd_data;
	assign m = mapping_indicators;


	sumAccumulator #(
	.MAPPER_PARALLELISM(MAPPER_PARALLELISM)
	) sumAccumulator_instance (
		.m(m),
		.c(c)
	);

	fillingShiftReg #(
	.MAPPER_PARALLELISM(MAPPER_PARALLELISM)
	) fillingShiftReg_instance (
		.clk(clk),
		.reset(reset),
		.d(d),
		.c(c[(MAPPER_PARALLELISM)*$clog2(MAPPER_PARALLELISM)-1:(MAPPER_PARALLELISM-1)*$clog2(MAPPER_PARALLELISM)]),
		.b(b),
		.data_in_fifo_rd_req(data_in_fifo_rd_req)
	);

	mapper #(
	.MAPPER_PARALLELISM(MAPPER_PARALLELISM)
	) mapper_instance (
		.m(m),
		.b(b),
		.c(c[(MAPPER_PARALLELISM-1)*$clog2(MAPPER_PARALLELISM)-1:0]),
		.mapper_out(data_out_fifo_wr_data)
	);

endmodule