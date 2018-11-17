
module comparator(clk, A, B, out);
	input logic clk;
	input logic [9:0] A, B;
	output logic out;
	
	assign out = (A > B);
endmodule

//module comparator_testbench();
//	logic [9:0] A, B;
//	logic out;
//	
//	comparator dut(A, B, out);
//	
//	initial begin
//		A = 10'b0010101100;	B = 10'b0111001001;	#10;
//									B = 10'b0000001001;	#10;
//									B = 10'b1100001001;	#10;
//		A = 10'b1010101100;	B = 10'b0111001001;	#10;
//		A = 10'b0011110100;								#10;
//		A = 10'b0000110100;								#10;
//	end
//endmodule
