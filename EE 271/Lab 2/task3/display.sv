
module display(U, P, C, led5, led4, led3, led2, led1, led0);
	input logic U, P, C;
	
	output logic [6:0] led5, led4, led3, led2, led1, led0;
	
	always_comb begin
		case ({U, P, C}) // cases relating item to UPC
			// 		  Light: 6543210
			3'b000: begin
					  led5 = 7'b1000111; // L
					  led4 = 7'b0001000; // A
					  led3 = 7'b0100001; // d
					  led2 = 7'b0100001; // d
					  led1 = 7'b0000110; // E
					  led0 = 7'b0101111; // r
					  end
					  
			3'b001: begin
					  led5 = 7'b1111111;
					  led4 = 7'b0010000; // g
					  led3 = 7'b1000111; // L
					  led2 = 7'b0001000; // A
					  led1 = 7'b0010010; // s
					  led0 = 7'b0010010; // s
					  end
					  
			3'b011: begin
					  led5 = 7'b1111111;
					  led4 = 7'b1111111;
					  led3 = 7'b0101111; // r
					  led2 = 7'b0100011; // o
					  led1 = 7'b0001100; // p
					  led0 = 7'b0000110; // E
					  end
					  
			3'b100: begin
					  led5 = 7'b1111111;
					  led4 = 7'b1111111;
					  led3 = 7'b0101111; // r
					  led2 = 7'b1111011; // i
					  led1 = 7'b0101011; // n
					  led0 = 7'b0010000; // g
					  end
					  
			3'b101: begin
					  led5 = 7'b1111111;
					  led4 = 7'b0001100; // p
					  led3 = 7'b0001011; // h
					  led2 = 7'b0100011; // o
					  led1 = 7'b0101011; // n
					  led0 = 7'b0000110; // E
					  end
					  
			3'b110: begin
					  led5 = 7'b1111111;
					  led4 = 7'b1111111;
					  led3 = 7'b0000011; // b
					  led2 = 7'b0000110; // E
					  led1 = 7'b1000111; // L
					  led0 = 7'b1000111; // L
					  end
					  
			default: begin // don't cares
					  led5 = 7'b1111111;
					  led4 = 7'b1111111;
					  led3 = 7'b1111111;
					  led2 = 7'b1111111;
					  led1 = 7'b1111111;
					  led0 = 7'b1111111;
					  end
		endcase
	end
	
endmodule

module display_testbench();
	logic U, P, C;
	logic [6:0] led5, led4, led3, led2, led1, led0;
	
	display dut(.U, .P, .C, .led5, .led4, .led3, .led2, .led1, .led0);
	
	integer i;
	initial begin
		for(i = 0; i < 2**3; i++) begin
			{U, P, C} = i; #10; // tests all possibilities of UPC
		end
	end
endmodule
