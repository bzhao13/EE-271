
module enterGuess(clk, reset, guess3, guess2, guess1, guess0, enter, out3, out2, out1, out0);
	input logic clk, reset, enter;
	input logic [1:0] guess3, guess2, guess1, guess0;
	output logic [1:0] out3, out2, out1, out0;
	
	// State variables
	enum {A, B, C} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			A:	if (enter)
					ns = B;
				else
					ns = A;
			B: if (enter)
					ns = C;
				else
					ns = A;
			C: if (enter)
					ns = C;
				else
					ns = A;
		endcase
	end
	
	// Output logic	
	always @(*) begin
		if (ns == B) begin
			out3 = guess3;
			out2 = guess2;
			out1 = guess1;
			out0 = guess0;
		end
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
endmodule

module enterGuess_tb();
	logic clk, reset, enter;
	logic [1:0] guess3, guess2, guess1, guess0, out3, out2, out1, out0;
	
	enterGuess dut(clk, reset, guess3, guess2, guess1, guess0, enter, out3, out2, out1, out0);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1;	@(posedge clk);	
		reset <= 0;	@(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;	enter <= 1; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					@(posedge clk);
		guess3 <= 2'b11;	guess2 <= 2'b00;	guess1 <= 2'b00;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;	enter <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	enter <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					@(posedge clk);
		enter <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	enter <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					@(posedge clk);
		enter <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	enter <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					@(posedge clk);
		enter <= 0; @(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b01;	guess1 <= 2'b10;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;	enter <= 1; @(posedge clk);
		guess3 <= 2'b01;	guess2 <= 2'b01;	guess1 <= 2'b11;	guess0 <= 2'b11;					@(posedge clk);
		guess3 <= 2'b00;	guess2 <= 2'b11;	guess1 <= 2'b10;	guess0 <= 2'b01;					@(posedge clk);
		$stop; // End simulation
	end
endmodule
