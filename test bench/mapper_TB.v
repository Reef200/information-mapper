module mapper_tb;
	parameter MAPPER_PARALLELISM = 8; // initial value

	reg [MAPPER_PARALLELISM-1:0] 								b, m;
	reg [(MAPPER_PARALLELISM-1)*$clog2(MAPPER_PARALLELISM) - 1:0]	c;

	wire [MAPPER_PARALLELISM-1:0]								mapper_out;

	mapper mapper_instance (
		.m(m),
		.b(b),
		.c(c),
		.mapper_out(mapper_out)
	);


initial begin
	m = 8'b10101111;
	b = 8'b11111111;
	c = 21'b001010011100101110111;
end

endmodule