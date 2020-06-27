module fillingShiftReg
#(parameter MAPPER_PARALLELISM = 8)(
	input 									clk,
	input 									reset,
	input [MAPPER_PARALLELISM-1:0] 			d,
	input [$clog2(MAPPER_PARALLELISM)-1:0]	c,
	output [MAPPER_PARALLELISM-1:0] 		b,
	output									data_in_fifo_rd_req
);

	wire [$clog2(MAPPER_PARALLELISM):0] res;
	wire [2*MAPPER_PARALLELISM-2:0]		muxxed_fill_data_stg_I;
	wire [2*MAPPER_PARALLELISM-2:0]		muxxed_fill_data_stg_II;
	wire [2*MAPPER_PARALLELISM-2:0]		muxxed_shift_bit;
	wire [2*MAPPER_PARALLELISM-2:0]		muxxed_bit_to_store;
	reg  [2*MAPPER_PARALLELISM-2:0]		r;
	integer								temp = {$clog2(MAPPER_PARALLELISM){1'b0}};
	wire 								fill;


	//	async-logic
	genvar gi;
	generate
		for (gi = 0; gi < 2*MAPPER_PARALLELISM-1; gi = gi + 1) begin : fiil_n_shift
			mux #(2*MAPPER_PARALLELISM) data_mux(.select(gi[$clog2(MAPPER_PARALLELISM):0] - res[$clog2(MAPPER_PARALLELISM):0] + {1'b0, c}), .d( {{MAPPER_PARALLELISM{1'b0}}, d}), .q(muxxed_fill_data_stg_I[gi]));
			assign muxxed_fill_data_stg_II[gi] = (res - {1'b0, c} > MAPPER_PARALLELISM - 1) ? 1'b0 : muxxed_fill_data_stg_I[gi];
			assign muxxed_bit_to_store[gi] = (gi < res - {1'b0, c}) ? muxxed_shift_bit[gi] : muxxed_fill_data_stg_II[gi];
		end

		// handle shifts for regs M_P-1:0
		for (gi = 0; gi < MAPPER_PARALLELISM; gi = gi + 1) begin : LSB_shift
			mux #(MAPPER_PARALLELISM) LSB_shift_mux(.select(c), .d(r[gi+MAPPER_PARALLELISM-1:gi]), .q(muxxed_shift_bit[gi]));
		end

		// handle shifts for regs 2*M_P-2:M_P
		for (gi = MAPPER_PARALLELISM; gi < 2*MAPPER_PARALLELISM-1; gi = gi + 1) begin : MSB_shift
			mux #(MAPPER_PARALLELISM) MSB_shift_mux(.select(c), .d({{(gi-MAPPER_PARALLELISM+1){1'b0}}, r[2*MAPPER_PARALLELISM-2:gi]}), .q(muxxed_shift_bit[gi]));
		end
	endgenerate

	assign fill = (res < MAPPER_PARALLELISM) ? 1'b1 : 1'b0;
	assign res =  temp[$clog2(MAPPER_PARALLELISM):0];

	//	subtractor sequential block
	always @(posedge clk) begin	:	subtractor
		if(reset)
			temp = {{(MAPPER_PARALLELISM - 8){1'b1}}, {$clog2(MAPPER_PARALLELISM){1'b0}}};
		else	begin
			if(fill)		temp = temp + 8;
			temp <= temp - c;
		end
	end

	//	register sequential block
	always @(posedge clk) begin	:	registers
		if(reset)			r <= {(2*MAPPER_PARALLELISM-2){1'b0}};
		else 				r <= muxxed_bit_to_store;
	end

	//	Assign outputs
	assign data_in_fifo_rd_req = fill;
	assign b = r[MAPPER_PARALLELISM-1:0];


endmodule