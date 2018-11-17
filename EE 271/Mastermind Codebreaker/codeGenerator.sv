
module codeGenerator(clk, reset, code3, code2, code1, code0);
	input logic clk, reset;
	output reg [1:0] code3, code2, code1, code0;
	
	// State variables
	reg [4:0] ps = 5'b0000;
	reg [4:0] ns;
	reg in;
	
	// Next state logic
	always_comb begin
		in = ~(ps[4] ^ ps[2]);
		ns = {ps[3:0], in};
	end
	
	// Output logic
	assign code3 = {ps[4], ps[1]};
	assign code2 = {ps[2], ps[4]};
	assign code1 = {ps[0], ps[1]};
	assign code0 = {ps[1], ps[3]};
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= ns;
		else
			ps <= ps;
	end
endmodule

module codeGenerator_tb();
	logic clk, reset;
	logic [1:0] code3, code2, code1, code0;
	
	codeGenerator dut(clk, reset, code3, code2, code1, code0);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design. Each line is a clock cycle.
	integer i;
	initial begin
		reset <= 1;	@(posedge clk);
		reset <= 0;
		for(i = 0; i < 10; i++) begin
			@(posedge clk);
		end
		reset <= 1;
		for(i = 0; i < 10; i++) begin
			@(posedge clk);
		end
		reset <= 0;
		for(i = 0; i < 10; i++) begin
			@(posedge clk);
		end
		reset <= 1;
		for(i = 0; i < 10; i++) begin
			@(posedge clk);
		end
		reset <= 0;
		for(i = 0; i < 10; i++) begin
			@(posedge clk);
		end
		reset <= 1;
		for(i = 0; i < 10; i++) begin
			@(posedge clk);
		end
		$stop; // End simulation							
	end
endmodule
