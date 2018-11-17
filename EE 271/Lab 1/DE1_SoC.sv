
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	logic c0;
	
	fullAdder FA0 (.A(SW[1]), .B(SW[5]), .cin(SW[0]), .sum(LEDR[0]), .cout(c0));
	fullAdder FA1 (.A(SW[2]), .B(SW[6]), .cin(c0), .sum(LEDR[1]), .cout(c1));
	fullAdder FA2 (.A(SW[3]), .B(SW[7]), .cin(c1), .sum(LEDR[2]), .cout(c2));
	fullAdder FA3 (.A(SW[4]), .B(SW[8]), .cin(c2), .sum(LEDR[3]), .cout(LEDR[4]));
	
	assign HEX0 = 7'b0010000;
	assign HEX1 = 7'b1001000;
	assign HEX2 = 7'b1111001;
	assign HEX3 = 7'b0100001;
	assign HEX4 = 7'b0100001;
	assign HEX5 = 7'b0001000;

endmodule

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);
	
	integer i;
	initial begin
	SW[9] = 1'b0;
	for(i=0; i<2**9; i++) begin
		SW[8:0] = i; #10;
	end
end

endmodule
