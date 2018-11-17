
module winCondition(correctLocation, win);
	input logic [2:0] correctLocation;
	output logic win;
	
	assign win = (correctLocation == 3'b100);
endmodule
