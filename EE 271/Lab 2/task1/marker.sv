
module marker(U, P, C, M, d, s);
	input logic U, P, C, M;
	output logic d, s;
	
	assign d = P | (U & C);
	assign s = (~P & ~C & ~M) | (U & ~P & ~M);
	
endmodule

module marker_testbench();

	logic U, P, C, M, d, s;
	
	marker dut(U, P, C, M, d, s);
	
	integer i;
	initial begin
	
		for(i = 0; i < 2**4; i++) begin
			{U, P, C, M} = i; #10;
		end
	end
	
endmodule
