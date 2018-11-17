
module counter(reset, in, displayOut10, displayOut1, guesses);
	input logic reset, in;
	output logic [6:0] displayOut10, displayOut1;
	output logic [7:0] guesses;
	
	logic [3:0] count1, count10;
	
	// Counters
	always @(posedge in or posedge reset) begin
		if (reset) begin
			count1 <= 4'b0000;
			count10 <= 4'b0000;
			guesses <= 0;
		end else if (in) begin
			guesses = guesses + 1;
			if (count1 < 9)
				count1 <= count1 + 4'b0001;
			else begin
				if (count10 < 9)
					count10 <= count10 + 1;
				else
					count10 <= 0;
				count1 = 0;
			end
		end
	end
	
	// Ones place display
	always @(count1) begin
		case (count1)
			4'b0000: displayOut1 = 7'b1000000;	// 0
			4'b0001: displayOut1 = 7'b1111001;	// 1
			4'b0010: displayOut1 = 7'b0100100;	// 2
			4'b0011: displayOut1 = 7'b0110000;	// 3
			4'b0100: displayOut1 = 7'b0011001;	// 4
			4'b0101: displayOut1 = 7'b0010010;	// 5
			4'b0110: displayOut1 = 7'b0000010;	// 6
			4'b0111: displayOut1 = 7'b1111000;	// 7
			4'b1000: displayOut1 = 7'b0000000;	// 8
			4'b1001: displayOut1 = 7'b0010000;	// 9
			default: displayOut1 = 7'b1111111;
		endcase
	end
	
	// Tens place display
	always @(count10) begin
		case (count10)
			4'b0000: displayOut10 = 7'b1000000;	// 0
			4'b0001: displayOut10 = 7'b1111001;	// 1
			4'b0010: displayOut10 = 7'b0100100;	// 2
			4'b0011: displayOut10 = 7'b0110000;	// 3
			4'b0100: displayOut10 = 7'b0011001;	// 4
			4'b0101: displayOut10 = 7'b0010010;	// 5
			4'b0110: displayOut10 = 7'b0000010;	// 6
			4'b0111: displayOut10 = 7'b1111000;	// 7
			4'b1000: displayOut10 = 7'b0000000;	// 8
			4'b1001: displayOut10 = 7'b0010000;	// 9
			default: displayOut10 = 7'b1111111;
		endcase
	end
endmodule

module counter_tb();
	logic clk, reset, in;
	logic [6:0] displayOut10, displayOut1;
	logic [3:0] count1, count10;
	logic [7:0] guesses;
	
	counter dut(reset, in, displayOut10, displayOut1, guesses);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design. Each line is a clock cycle.
	integer i;
	initial begin
		reset <= 1;	in <= 0;	@(posedge clk);
		reset <= 0;	
		for(i=0; i<30; i++) begin
			in <= 1;	@(posedge clk);
			in <= 0; @(posedge clk);
		end
		$stop;
	end
endmodule
