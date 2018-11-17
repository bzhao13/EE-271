
module counter(clk, reset, in, out, winner);
	input logic clk, reset, in;
	output reg [6:0] out;
	output logic winner;
	
	// State variables
	enum {A, B, C, D, E, F, G, H} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			A: if (in)
					ns = B;
				else
					ns = ps;
			B: if (in)
					ns = C;
				else
					ns = ps;
			C: if (in)
					ns = D;
				else
					ns = ps;
			D: if (in)
					ns = E;
				else
					ns = ps;
			E: if (in)
					ns = F;
				else
					ns = ps;
			F: if (in)
					ns = G;
				else
					ns = ps;
			G: if (in)
					ns = H;
				else
					ns = ps;
			H: ns = ps;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ns)
			A: out = 7'b1000000;	// 0
			B: out = 7'b1111001;	// 1
			C: out = 7'b0100100;	// 2
			D: out = 7'b0110000;	// 3
			E: out = 7'b0011001;	// 4
			F: out = 7'b0010010;	// 5
			G: out = 7'b0000010;	// 6
			H: out = 7'b1111000;	// 7
		endcase
	end
	assign winner = (ns == H);

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
endmodule

module counter_testbench();
	logic clk, reset, in;
	logic [6:0] out;
	logic winner;
	
	counter dut(clk, reset, in, out, winner);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1;				@(posedge clk);
		reset <= 0; in <= 1;	@(posedge clk);
									@(posedge clk);
									@(posedge clk);
						in <= 0;	@(posedge clk);
									@(posedge clk);
									@(posedge clk);
						in <= 1; @(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
		$stop; // End simulation							
	end
endmodule
