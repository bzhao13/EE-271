
module LFSR(clk, reset, out);
	input logic clk, reset;
	output logic [9:0] out;
	
	// State variables
	reg [9:0] ps, ns;
	reg in;
	
	// Next state logic
	always_comb begin
		in = ~(ps[6] ^ ps[9]);
		ns = {ps[8:0], in};
	end
	
	// Output logic
	assign out = ps;
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= 10'b0000000000;
		else
			ps <= ns;
	end
endmodule

module LFSR_testbench();
	logic clk, reset;
	logic [9:0] out;
	
	LFSR dut(clk, reset, out);
	
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
		reset <= 0;	@(posedge clk);
		for(i = 0; i < 50; i++) begin
			@(posedge clk);
		end				
		$stop; // End simulation							
	end
endmodule
