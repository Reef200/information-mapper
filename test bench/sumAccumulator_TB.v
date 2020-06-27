module sumAccumulator_TB;
	parameter MAPPER_PARALLELISM = 8; // initial value

	reg [MAPPER_PARALLELISM-1:0] 										m;
	wire [(MAPPER_PARALLELISM)*$clog2(MAPPER_PARALLELISM) - 1:0]		c;

	sumAccumulator sumAccumulator_instance (
		.m(m),
		.c(c)
	);


initial begin
	m = 8'b10101111;
end

endmodule