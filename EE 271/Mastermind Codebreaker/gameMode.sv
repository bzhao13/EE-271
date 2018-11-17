
module gameMode(clk, reset, on, off, gameOverL, gameOverW, realGame);
	input logic clk, reset, on, off, gameOverL, gameOverW;
	output logic realGame;
	
	// State variables
	enum {A, B, C, D} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			A: if (gameOverL)
					ns = C;
				else if (gameOverW)
					ns = D;
				else if (on)
					ns = B;
				else
					ns = A;
			B: if (gameOverL)
					ns = C;
				else if (gameOverW)
					ns = C;
				else if (off)
					ns = A;
				else
					ns = B;
			C: ns = C;
			D: ns = D;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ps)
			A: realGame = 1'b0;
			B: realGame = 1'b1;
			C: realGame = 1'b1;
			D: realGame = 1'b0;
		endcase
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
endmodule

module gameMode_tb();
	logic clk, reset, on, off, gameOverL, gameOverW, realGame;
	
	gameMode dut(clk, reset, on, off, gameOverL, gameOverW, realGame);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1;										@(posedge clk);	
		reset <= 0;										@(posedge clk);
						on <= 1;							@(posedge clk);	
															@(posedge clk);
															@(posedge clk);
						on <= 0;							@(posedge clk);
						off <= 1;						@(posedge clk);	
															@(posedge clk);
															@(posedge clk);
						off <= 0;						@(posedge clk);
									gameOverL <= 1;	@(posedge clk);	
															@(posedge clk);
															@(posedge clk);
									gameOverL <= 0;	@(posedge clk);
									gameOverW <= 1;	@(posedge clk);	
									gameOverW <= 0;	@(posedge clk);
															@(posedge clk);
		$stop;
	end
endmodule
