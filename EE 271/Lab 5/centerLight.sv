
module centerLight(clk, reset, L, R, NL, NR, lightOn);
	input logic clk, reset, L, R, NL, NR;
	output logic lightOn;
	
	// State variables
	enum {on, off} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			off: if (NR & L)
					ns = on;
				else if (NL & R)
					ns = on;
				else
					ns = off;
			on: if (L ^ R)
					ns = off;
				else
					ns = on;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ps)
			off: lightOn = 1'b0;
			on: lightOn = 1'b1;
		endcase
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= on;
		else
			ps <= ns;
	end
endmodule

module centerLight_testbench();
	logic clk, reset, L, R, NL, NR;
	logic lightOn;
	
	centerLight dut(clk, reset, L, R, NL, NR, lightOn);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																		@(posedge clk);
		reset <= 1; 												@(posedge clk);
		reset <= 0;	NL <= 0;	L <= 0;	NR <= 0;	R <= 0;	@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
						NL <= 0;	L <= 1;	NR <= 0;	R <= 1;	@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
						NL <= 0;	L <= 0;	NR <= 0;	R <= 1;	@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
						NL <= 0;	L <= 0;	NR <= 0;	R <= 1;	@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
						NL <= 1;	L <= 0;	NR <= 0;	R <= 0;	@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
						NL <= 0;	L <= 1;	NR <= 1;	R <= 0;	@(posedge clk);
																		@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
 