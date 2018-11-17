

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;

	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// marker module for led outputs for discount and sale
	marker UPC0 (.U(SW[8]), .P(SW[7]), .C(SW[6]), .M(SW[0]), .d(LEDR[1]), .s(LEDR[0]));

	// display module for hex digit representation of UPC
	display UPC1 (.U(SW[8]), .P(SW[7]), .C(SW[6]), .leds(HEX0));
	
	// don't need other hex displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;

endmodule

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	integer i;
	initial begin

	// don't need switches 1 through 5 or switch 9
	SW[9] = 1'b0;
	SW[5:1] = 1'b0;
		for(i=0; i<2**4; i++) begin
			{SW[8:6], SW[0]} = i; #10; // tests all possibilities of UPS and mark
		end
	end
endmodule
