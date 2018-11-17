
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	// Hook up FSM inputs and outputs.
	assign reset = SW[9];
	logic Lmeta, Rmeta;
	logic Lplayer, Rplayer;
	logic led9, led8, led7, led6, led5, led4, led3, led2, led1;
	assign key3 = ~KEY[3];
	assign key0 = ~KEY[0];
	
	// Metastability tolerance
	meta leftPlayer(.clk(CLOCK_50), .in(key3), .out(Lmeta));
	meta rightPlayer(.clk(CLOCK_50), .in(key0), .out(Rmeta));
	
	// player input single pulse
	playerIn Lin(.clk(CLOCK_50), .reset, .key(Lmeta), .out(Lplayer));
	playerIn Rin(.clk(CLOCK_50), .reset, .key(Rmeta), .out(Rplayer));
	
	// lights of playfield
	normalLight L9(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(1'b0), .NR(led8), .lightOn(led9));
	normalLight L8(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led9), .NR(led7), .lightOn(led8));
	normalLight L7(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led8), .NR(led6), .lightOn(led7));
	normalLight L6(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led7), .NR(led5), .lightOn(led6));
	centerLight L5(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led6), .NR(led4), .lightOn(led5));
	normalLight L4(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led5), .NR(led3), .lightOn(led4));
	normalLight L3(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led4), .NR(led2), .lightOn(led3));
	normalLight L2(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led3), .NR(led1), .lightOn(led2));
	normalLight L1(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led2), .NR(1'b0), .lightOn(led1));
	
	// check victory condition
//	victory V(.clk(CLOCK_50), .reset, .L(Lplayer), .R(Rplayer), .NL(led9), .NR(led1), .lightOn(HEX0));
	victory V(.L(Lplayer), .R(Rplayer), .NL(led9), .NR(led1), .lightOn(HEX0));
	
	// Show signals on LEDRs so we can see what is happening.
	assign LEDR = {led9, led8, led7, led6, led5, led4, led3, led2, led1, 1'b0};
	
	// Sets all unused hex displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
endmodule

module DE1_SoC_testbench();
	logic CLOCK_50; // 50MHz clock.
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // True when not pressed, False when pressed
	logic [9:0] SW;
	
	DE1_SoC dut(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	initial CLOCK_50 = 1;
	initial KEY[3:0] = 4'b1111;
	
	// Set up clock
	parameter CLOCK_PERIOD = 100;
	always begin
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
											@(posedge CLOCK_50);
		SW[9] <= 1;						@(posedge CLOCK_50);
		SW[9] <= 0; KEY[0] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[0] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		SW[9] <= 1;						@(posedge CLOCK_50);
		SW[9] <= 0; 					@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 1;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
						KEY[3] <= 0;	@(posedge CLOCK_50);
											@(posedge CLOCK_50);		
											
		$stop; //End the simulation
	end
endmodule
