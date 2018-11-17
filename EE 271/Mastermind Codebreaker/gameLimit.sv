
module gameLimit(reset, totalGuesses, game, over);
	input logic reset, game;
	input logic [7:0] totalGuesses;
	output logic over;
	
	always @(*) begin
		if (game)
			if (totalGuesses > 8'b00001001)
				over = 1'b1;
			else
				over = 1'b0;
		else
			over = 1'b0;
	end
endmodule

module gameLimit_tb();
	logic reset, game;
	logic [7:0] totalGuesses;
	logic over;
	
	gameLimit dut(reset, totalGuesses, game, over);
	
	integer i;
	initial begin
		reset = 1;	game = 1;	#10;
		reset = 0;					#10;
		for(i=0; i<20; i++) begin
			totalGuesses[7:0] = i; #10;
		end
	end
endmodule
