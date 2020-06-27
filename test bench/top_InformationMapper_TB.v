module top_InformationMapper_TB;
	parameter MAPPER_PARALLELISM = 8; // initial value

	reg 									clk;
	reg 									reset;
	reg [MAPPER_PARALLELISM-1:0] 			data_in_fifo_rd_data;
	reg [MAPPER_PARALLELISM-1:0] 			mapping_indicators;
	wire									data_in_fifo_rd_req;
	wire [MAPPER_PARALLELISM-1:0] 			data_out_fifo_wr_data;

	integer	dataFile, mappingFile, outputFile, status_d, status_m;
	integer	start; //	making sure to start fifos work after reset

	top_informationMapper #(
	.MAPPER_PARALLELISM(MAPPER_PARALLELISM)
	) top_informationMapper_instance (
		.clk(clk),
		.reset(reset),
		.data_in_fifo_rd_data(data_in_fifo_rd_data),
		.mapping_indicators(mapping_indicators),
		.data_in_fifo_rd_req(data_in_fifo_rd_req),
		.data_out_fifo_wr_data(data_out_fifo_wr_data)
	);

	initial begin
		clk = 1'b0;
		reset = 1'b0;
		data_in_fifo_rd_data = 0;
		mapping_indicators = 0;
		start = 0;
		// open files
		dataFile = $fopen("data.txt","r");
		if (dataFile == 0) $error("data.txt not opened");
		mappingFile = $fopen("mapping.txt","r");
		if (mappingFile == 0) $error("mapping.txt not opened");
		outputFile = $fopen("output.txt","w");

		#1 reset = 1'b1;
		#21 reset = 1'b0;
		#5 start = 1;
	end

	always
	#10 clk = !clk;

	always @(posedge clk) begin	:	data_fifo
		if(start)	begin
			if(data_in_fifo_rd_req)
				status_d = $fscanf(dataFile,"%h",data_in_fifo_rd_data);
		end
	end

	always @(posedge clk) begin	:	mapping_fifo
		if(start)	begin
			status_m = $fscanf(mappingFile,"%h",mapping_indicators);
		end
	end

	always @(posedge clk) begin	:	output_fifo
		if(start)	begin
			$fdisplay(outputFile,"%h ",data_out_fifo_wr_data);
		end
	end

endmodule