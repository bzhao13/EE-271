
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
	assign reset = SW[9];														// reset
	assign enterGuess = ~KEY[3];												// push to submit current guess
	assign LEDR[0] = wonGame;													// true if won game
	assign LEDR[9] = lostGame;													// true if lost game
	assign LEDR[7] = gameMode;													// true if not practice game
	logic [1:0] digit3, digit2, digit1, digit0;							// four digit code
	logic [1:0] guessD3, guessD2, guessD1, guessD0;						// selected guesses
	logic [7:0] totalGuesses;													// number of guesses made
	logic [3:0] CL3, CL2, CL1, CL0;											// number of correct values and correct locations
	logic [3:0] VO3, VO2, VO1, VO0;											// number of correct values but wrong locations
	logic [3:0] totalCorrect, totalValuesOnly;							// total number of CL and VO
	logic [6:0] guessDisp3, guessDisp2, guessDisp1, guessDisp0;		// hex displays for guesses
	logic [6:0] codeDisp3, codeDisp2, codeDisp1, codeDisp0;			// hex displays for code
	logic [6:0] locationDisp, valueDisp, counter10, counter1;		// hex displays for game states

	
	
	// Random code generator
	codeGenerator rng(.clk(clk[whichClock]), .reset, .code3(digit3), .code2(digit2), .code1(digit1), .code0(digit0));
	
	// Make guess
	enterGuess guess(.clk(clk[whichClock]), .reset, .guess3({SW[7], SW[6]}), .guess2({SW[5], SW[4]}), .guess1({SW[3], SW[2]}), .guess0({SW[1], SW[0]}), .enter(enterGuess || wonGame || lostGame), .out3(guessD3), .out2(guessD2), .out1(guessD1), .out0(guessD0));
	
	// Compare guess with code
	comparator C3(.reset, .guess(guessD3), .codeA(digit3), .codeB(digit2), .codeC(digit1), .codeD(digit0), .correctLocation(CL3), .valueOnly(VO3));
	comparator C2(.reset, .guess(guessD2), .codeA(digit2), .codeB(digit3), .codeC(digit1), .codeD(digit0), .correctLocation(CL2), .valueOnly(VO2));
	comparator C1(.reset, .guess(guessD1), .codeA(digit1), .codeB(digit3), .codeC(digit2), .codeD(digit0), .correctLocation(CL1), .valueOnly(VO1));
	comparator C0(.reset, .guess(guessD0), .codeA(digit0), .codeB(digit3), .codeC(digit2), .codeD(digit1), .correctLocation(CL0), .valueOnly(VO0));
	
	// Finds total correct locations and total values only
	sum totalCL(.value3(CL3), .value2(CL2), .value1(CL1), .value0(CL0), .sum(totalCorrect));
	sum totalVO(.value3(VO3), .value2(VO2), .value1(VO1), .value0(VO0), .sum(totalValuesOnly));
	
	// Win condition
	winCondition win(.correctLocation(totalCorrect), .win(wonGame));
	
	// Select game mode
	gameMode practice(.clk(clk[whichClock]), .reset, .on(~KEY[1]), .off(~KEY[2]), .gameOverL(lostGame), .gameOverW(wonGame), .realGame(gameMode));
	gameLimit rounds(.reset, .totalGuesses(totalGuesses), .game(gameMode), .over(lostGame));
	
	// Display options
	// Display each guess
	guessDisplay G3(.value({SW[7], SW[6]}), .displayOut(guessDisp3));
	guessDisplay G2(.value({SW[5], SW[4]}), .displayOut(guessDisp2));
	guessDisplay G1(.value({SW[3], SW[2]}), .displayOut(guessDisp1));
	guessDisplay G0(.value({SW[1], SW[0]}), .displayOut(guessDisp0));
	
	// Display secret code
	guessDisplay Code3(.value(digit3), .displayOut(codeDisp3));
	guessDisplay Code2(.value(digit2), .displayOut(codeDisp2));
	guessDisplay Code1(.value(digit1), .displayOut(codeDisp1));
	guessDisplay Code0(.value(digit0), .displayOut(codeDisp0));
	
	// Display status of game
	stateDisplay CL(.clk(clk[whichClock]), .reset, .in(enterGuess), .value(totalCorrect), .displayOut(locationDisp));
	stateDisplay VO(.clk(clk[whichClock]), .reset, .in(enterGuess), .value(totalValuesOnly), .displayOut(valueDisp));
	counter guessesMade(.reset, .in(enterGuess || wonGame), .displayOut10(counter10), .displayOut1(counter1), .guesses(totalGuesses));
	
	// Control displayed game information
	always @(*) begin
		if (wonGame && ~lostGame)
			if (SW[8]) begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = codeDisp3;
				HEX2 = codeDisp2;
				HEX1 = codeDisp1;
				HEX0 = codeDisp0;
			end else begin
				HEX5 = 7'b1111111;
				HEX4 = locationDisp;
				HEX3 = 7'b1111111;
				HEX2 = valueDisp;
				HEX1 = counter10;
				HEX0 = counter1;
			end
		else if (lostGame)
			if (SW[8]) begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = codeDisp3;
				HEX2 = codeDisp2;
				HEX1 = codeDisp1;
				HEX0 = codeDisp0;
			end else begin
				HEX5 = 7'b1000111; // L
				HEX4 = 7'b0100011; // o
				HEX3 = 7'b0010010; // s
				HEX2 = 7'b0000110; // E
				HEX1 = 7'b0101111; // r
				HEX0 = 7'b1111111;
			end
		else
			if (SW[8]) begin
				HEX5 = 7'b1111111;
				HEX4 = 7'b1111111;
				HEX3 = guessDisp3;
				HEX2 = guessDisp2;
				HEX1 = guessDisp1;
				HEX0 = guessDisp0;
			end else begin
				HEX5 = 7'b1111111;
				HEX4 = locationDisp;
				HEX3 = 7'b1111111;
				HEX2 = valueDisp;
				HEX1 = counter10;
				HEX0 = counter1;
			end
	end
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
