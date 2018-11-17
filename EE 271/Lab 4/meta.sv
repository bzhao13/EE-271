
module meta(clk, in, out);
	input logic clk, in;
	output logic out;
	logic q;
	
	always_ff @ (posedge clk) begin
		q <= in;
		out <= q;
	end
endmodule

module meta_testbench();
	logic clk, in, out;
	
	meta dut(clk, in, out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
					@(posedge clk);
		in <= 0;	@(posedge clk);
					@(posedge clk);
					@(posedge clk);
		in <= 1;	@(posedge clk);
					@(posedge clk);
					@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
