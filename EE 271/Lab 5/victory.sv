
module victory(L, R, NL, NR, LW, RW);
	input logic L, R, NL, NR;
	output logic LW, RW;
	
	assign LW = NL & L & ~R;
	assign RW = NR & R & ~L;
endmodule
