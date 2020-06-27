module mux
#(parameter MUX_SIZE)(
	input	[$clog2(MUX_SIZE) - 1 :0]	select,
	input	[MUX_SIZE-1:0]		d,
	output     q
);

	//wire      q;
	//wire[1:0] select;
	//wire[3:0] d;

	assign q = d[select];

endmodule