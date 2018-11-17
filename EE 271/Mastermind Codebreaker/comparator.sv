
module comparator(reset, guess, codeA, codeB, codeC, codeD, correctLocation, valueOnly);
	input logic reset;
	input logic [1:0] guess, codeA, codeB, codeC, codeD;
	output logic [2:0] correctLocation, valueOnly;
	
	always @(*) begin
		if (reset) begin
			correctLocation = 3'b000;
			valueOnly = 3'b000;
		end else if (guess == codeA) begin
			correctLocation = 3'b001;
			valueOnly = 3'b000;
		end else begin
			if (guess == codeB)
				valueOnly = 3'b001;
			else if (guess == codeC)
				valueOnly = 3'b001;
			else if (guess == codeD)
				valueOnly = 3'b001;
			else begin
				valueOnly = 3'b000;
			end
			correctLocation = 3'b000;
		end
	end
endmodule

module comparator_tb();
	logic reset;
	logic [1:0] guess, codeA, codeB, codeC, codeD;
	logic [2:0] correctLocation, valueOnly;
	
	comparator dut(reset, guess, codeA, codeB, codeC, codeD, correctLocation, valueOnly);
	
	initial begin
		reset = 1;	#10;
		reset = 0;	#10;
		guess = 2'b00;	codeA = 2'b00;	codeB = 2'b11;	codeC = 2'b10;	codeD = 2'b10;	#10;
		guess = 2'b00;	codeA = 2'b11;	codeB = 2'b11;	codeC = 2'b10;	codeD = 2'b00;	#10;
		guess = 2'b00;	codeA = 2'b11;	codeB = 2'b11;	codeC = 2'b00;	codeD = 2'b10;	#10;
		guess = 2'b00;	codeA = 2'b11;	codeB = 2'b11;	codeC = 2'b10;	codeD = 2'b10;	#10;
	end
endmodule
