
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// marker module for led outputs for discount and sale
	marker UPC0 (.U(SW[9]), .P(SW[8]), .C(SW[7]), .M(SW[0]), .d(LEDR[1]), .s(LEDR[0]));
	
	// display module for hex displays for name of item for sale
	display UPC1 (.U(SW[9]), .P(SW[8]), .C(SW[7]), .led5(HEX5), .led4(HEX4), .led3(HEX3), .led2(HEX2), .led1(HEX1), .led0(HEX0));

endmodule

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	integer i;
	initial begin
	SW[6:1] = 1'b0; // don't need switches 1 through 6
		for(i=0; i<2**4; i++) begin
			{SW[9:7], SW[0]} = i; #10; // tests all possibilities of UPS and mark
		end
	end
endmodule
