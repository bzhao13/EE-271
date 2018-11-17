
module playerIn(clk, reset, key, out);
	input logic clk, reset, key;
	output logic out;
	
	// State variables
	enum {A, B, C} ps, ns;
	
	// Next State Logic
	always_comb begin
		case (ps)
			A: if (key)
					ns = B;
				else
					ns = A;
			B: if (key)
					ns = C;
				else
					ns = A;
			C: if (key)
					ns = C;
				else
					ns = A;
		endcase
	end
	
	// Output logic
	assign out = (ns == B);
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
	
endmodule

module playerIn_testbench();
	logic clk, reset, key;
	logic out;
	
	playerIn dut(clk, reset, key, out);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
										@(posedge clk);
		reset <= 1; 				@(posedge clk);
		reset <= 0; key <= 0; 	@(posedge clk);
						key <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						key <= 0;	@(posedge clk);
						key <= 1;	@(posedge clk);
						key <= 0;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						key <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
