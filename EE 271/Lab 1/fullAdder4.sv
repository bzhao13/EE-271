
module fullAdder4 (A, B, cin, sum, cout);

	input logic A[3:0];
	input logic B[3:0];
	input logic cin;
	
	output logic sum[3:0];
	output logic cout;
	
	logic c0;
	
	fullAdder FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(c0));
	fullAdder FA1 (.A(A[1]), .B(B[1]), .cin(c0), .sum(sum[1]), .cout(c1));
	fullAdder FA2 (.A(A[2]), .B(B[2]), .cin(c1), .sum(sum[2]), .cout(c2));
	fullAdder FA3 (.A(A[3]), .B(B[3]), .cin(c2), .sum(sum[3]), .cout(cout));
	
endmodule

module fullAdder4_testbench();

	logic A[3:0], B[3:0], cin, sum[3:0], cout, c0;
	
	fullAdder4 dut (A, B, cin, sum, cout);
	
	integer i;
	initial begin
		for(i=0; i<2**9; i++) begin
			{A[3], A[2], A[1], A[0], B[3], B[2], B[1], B[0], cin} = i; #10;
		end
	end
endmodule
