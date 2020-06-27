module mapper
#(parameter MAPPER_PARALLELISM = 8)(
	input [MAPPER_PARALLELISM-1:0] 									m,
	input [MAPPER_PARALLELISM-1:0] 									b,
	input [(MAPPER_PARALLELISM-1)*$clog2(MAPPER_PARALLELISM) - 1:0] c,
	output	[MAPPER_PARALLELISM-1:0] 								mapper_out
);

	wire [MAPPER_PARALLELISM-1:1] muxxed_bit;

	//	Assigning Mapper Outputs
	assign mapper_out[0] = b[0] & m[0];
	genvar gi;
	generate
		for (gi = 1; gi < MAPPER_PARALLELISM; gi = gi + 1) begin : mapper_gen_out
			mux #(MAPPER_PARALLELISM) my_mux(.select(c[$clog2(MAPPER_PARALLELISM)*gi - 1:$clog2(MAPPER_PARALLELISM)*(gi-1)]), .d(b), .q(muxxed_bit[gi]));
			assign mapper_out[gi] = m[gi] & muxxed_bit[gi];
		end
	endgenerate


endmodule