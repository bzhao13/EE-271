
module runway (clk, reset, sw1, sw0, led2, led1, led0);
	input logic clk, reset, sw1, sw0;
	output logic led2, led1, led0;
	
	// State variables
	enum {A, B, C, D} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			A: if ({sw1, sw0} == 2'b10)
					ns = C;
				else
					ns = B;
				
			B: if ({sw1, sw0} == 2'b00)
					ns = D;
				else if ({sw1, sw0} == 2'b01)
					ns = C;
				else if ({sw1, sw0} == 2'b10)
					ns = A;
				else
					ns = B;
					
			C: if ({sw1, sw0} == 2'b01)
					ns = A;
				else
					ns = B;
			D:	ns = B;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ps)
			A: begin
				led2 = 0; led1 = 0; led0 = 1;
				end
				
			B: begin
				led2 = 0; led1 = 1; led0 = 0;
				end
				
			C: begin
				led2 = 1; led1 = 0; led0 = 0;
				end
				
			D: begin
				led2 = 1; led1 = 0; led0 = 1;
				end
		endcase
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= B;
		else
			ps <= ns;
	end
endmodule

module runway_testbench();
	logic clk, reset, sw1, sw0;
	logic led2, led1, led0;
	
	runway dut(clk, reset, sw1, sw0, led2, led1, led0);
	
	// Set up clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
														@(posedge clk);
		reset <= 1; 								@(posedge clk);
		reset <= 0;	sw1 <= 0;	sw0 <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
						sw0 <= 1;					@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
						sw1 <= 1;	sw0 <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		$stop; // End the simulation.
	end
endmodule
	
	