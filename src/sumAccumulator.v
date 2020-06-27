module sumAccumulator
#(parameter MAPPER_PARALLELISM = 8)(
	input [MAPPER_PARALLELISM-1:0] 									m,
	output [(MAPPER_PARALLELISM)*$clog2(MAPPER_PARALLELISM) - 1:0]  c
);

	assign c[$clog2(MAPPER_PARALLELISM)-1:0] = {{($clog2(MAPPER_PARALLELISM)-1){1'b0}}, m[0]};
	genvar gi;
	generate
		for (gi = 1; gi < MAPPER_PARALLELISM; gi = gi + 1) begin : sum_gen_out
			assign c[$clog2(MAPPER_PARALLELISM)*(gi+1) - 1:$clog2(MAPPER_PARALLELISM)*(gi)] = 
					c[$clog2(MAPPER_PARALLELISM)*(gi) - 1:$clog2(MAPPER_PARALLELISM)*(gi-1)] + {2'b00, m[gi]};
		end
	endgenerate
endmodule