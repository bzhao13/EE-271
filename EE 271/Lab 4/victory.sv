//
//module victory(clk, reset, L, R, NL, NR, lightOn);
//	input logic clk, reset, L, R, NL, NR;
//	output logic [6:0] lightOn;
//	
//	// State variables
//	enum {A, B, C} ps, ns;
//	
//	// Next state logic
//	always_comb begin
//		case (ps)
//			A: ns = A; // left player wins
//			B: if (L & NL)
//					ns = A;
//				else if (R & NR)
//					ns = C;
//				else
//					ns = B;
//			C: ns = C; // right player wins
//		endcase
//	end
//	
//	// Output logic
//	always_comb begin
//		case (ps)
//			A: lightOn = 7'b1000111;
//			B: lightOn = 7'b1111111;
//			C: lightOn = 7'b0101111;
//		endcase
//	end
//	
//	// DFFs
//	always_ff @(posedge clk) begin
//		if (reset)
//			ps <= B;
//		else
//			ps <= ns;
//	end
//endmodule
//
//module victory_tesbench();
//	logic clk, reset, L, R, NL, NR;
//	logic [6:0] lightOn;
//	
//	victory dut(clk, reset, L, R, NL, NR, lightOn);
//	
//	// Set up the clock.
//	parameter CLOCK_PERIOD = 100;
//	initial begin
//		clk <= 0;
//		forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	end
//	
//	// Set up the inputs to the design. Each line is a clock cycle.
//	initial begin
//																	@(posedge clk);
//		reset <= 1;												@(posedge clk);
//		reset <= 0;	NL <= 0;	NR <= 0;	L <= 1; R <= 0;@(posedge clk);
//																	@(posedge clk);
//																	@(posedge clk);
//						NL <= 1;	NR <= 0;						@(posedge clk);
//		reset <= 1;												@(posedge clk);
//		reset <= 0;	NL <= 0;	NR <= 0;						@(posedge clk);
//																	@(posedge clk);
//						NL <= 0;	NR <= 1;	L <= 1; R <= 0;@(posedge clk);
//																	@(posedge clk);
//												L <= 0; R <= 1;@(posedge clk);
//																	@(posedge clk);
//		$stop; // End the simulation.
//	end
//endmodule

module victory(L, R, NL, NR, lightOn);
	input logic L, R, NL, NR;
	output logic [6:0] lightOn;
	
	always @(*) begin
		if (NL & L)
			lightOn = 7'b1000111;
		else if (NR & R)
			lightOn = 7'b0101111;
		else
			lightOn = 7'b1111111;
	end
endmodule
