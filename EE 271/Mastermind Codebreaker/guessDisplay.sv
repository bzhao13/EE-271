
module guessDisplay(value, displayOut);
	input logic [1:0] value;
	output logic [6:0] displayOut;
	
	always_comb begin
		case (value)
			2'b00: displayOut = 7'b1000000;	// 0
			2'b01: displayOut = 7'b1111001;	// 1
			2'b10: displayOut = 7'b0100100;	// 2
			2'b11: displayOut = 7'b0110000;	// 3
		endcase
	end
endmodule
