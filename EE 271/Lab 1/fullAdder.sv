
module fullAdder (A, B, cin, sum, cout);
         input logic A, B, cin;
         output logic sum, cout;
         
         assign sum = A ^ B ^ cin;  //Find the sum of the 3 inputs
         assign cout = (A & B)  |  cin & (A ^ B);  //Find if there is a cout
			
endmodule

module fullAdder_testbench();

	logic A, B, cin, sum, cout;
	
	fullAdder dut(A, B, cin, sum, cout);
	
	integer i;
	initial begin
	
		for(i=0; i<2**3; i++) begin
			{A, B, cin} = i; #10;
		end
	end
endmodule
	