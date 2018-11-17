
module hexDisplay(in, out);
	input reg [2:0] in;
	output logic [6:0] out;
	
	always_comb begin
		case (in)
			3'b000: out = 7'b1000000;	// 0
			3'b001: out = 7'b1111001;	// 1
			3'b010: out = 7'b0100100;	// 2
			3'b011: out = 7'b0110000;	// 3
			3'b100: out = 7'b0011001;	// 4
			3'b101: out = 7'b0010010;	// 5
			3'b110: out = 7'b0000010;	// 6
			3'b111: out = 7'b1111000;	// 7
		endcase
	end
endmodule
