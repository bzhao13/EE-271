
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	parameter whichClock = 15;
	clock_divider cdiv (CLOCK_50, clk);
	
	// Hook up FSM inputs and outputs.
	assign reset = SW[9]; 														// reset
	assign key3 = ~KEY[3]; 														// player in
	logic compIn; 																	// computer in
	logic [9:0] randNum; 														// random number
	logic Lmeta, Rmeta; 															// outputs after metastability tolerance
	logic Lplayer, Rplayer;														// single clock cycle outputs
	logic led9, led8, led7, led6, led5, led4, led3, led2, led1; 	// playfield leds
	logic Lwin, Rwin; 															// winner of one round
	logic LgameOver, RgameOver; 												// winner of entire game
	
	// Random number generator
	LFSR rng(.clk(clk[whichClock]), .reset, .out(randNum));
	
	// Comparator for rng to computer input
	comparator(.A({1'b0, SW[8:0]}), .B(randNum), .out(compIn));
	
	// Metastability tolerance
	meta player(.clk(clk[whichClock]), .in(key3 | LgameOver | RgameOver), .out(Lmeta));
	meta computer(.clk(clk[whichClock]), .in(compIn | LgameOver | RgameOver), .out(Rmeta));
	
	// Player input single pulse
	playerIn Lin(.clk(clk[whichClock]), .reset, .key(Lmeta), .out(Lplayer));
	playerIn Rin(.clk(clk[whichClock]), .reset, .key(Rmeta), .out(Rplayer));
	
	// Lights of playfield
	normalLight L9(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(1'b0), .NR(led8), .lightOn(led9));
	normalLight L8(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led9), .NR(led7), .lightOn(led8));
	normalLight L7(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led8), .NR(led6), .lightOn(led7));
	normalLight L6(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led7), .NR(led5), .lightOn(led6));
	
	centerLight L5(.clk(clk[whichClock]), .reset(reset | Lwin | Rwin), .L(Lplayer), .R(Rplayer), .NL(led6), .NR(led4), .lightOn(led5));
	
	normalLight L4(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led5), .NR(led3), .lightOn(led4));
	normalLight L3(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led4), .NR(led2), .lightOn(led3));
	normalLight L2(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led3), .NR(led1), .lightOn(led2));
	normalLight L1(.clk(clk[whichClock]), .reset, .L(Lplayer), .R(Rplayer), .NL(led2), .NR(1'b0), .lightOn(led1));
	
	// Check round win condition
	victory V(.L(Lplayer), .R(Rplayer), .NL(led9), .NR(led1), .LW(Lwin), .RW(Rwin));
	
	// Check game win condition and round win counter
	counter leftCounter(.clk(clk[whichClock]), .reset(SW[9]), .in(Lwin), .out(HEX5), .winner(LgameOver));
	counter rightCounter(.clk(clk[whichClock]), .reset(SW[9]), .in(Rwin), .out(HEX0), .winner(RgameOver));
	
	// Show signals on LEDRs so we can see what is happening.
	assign LEDR = {led9, led8, led7, led6, led5, led4, led3, led2, led1, 1'b0};
	
	// Sets all unused hex displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;
	
	initial begin
		divided_clocks <= 0;
	end
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule
