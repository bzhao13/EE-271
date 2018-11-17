
module sum(value3, value2, value1, value0, sum);
	input logic [3:0] value3, value2, value1, value0;
	output logic [3:0] sum;
	
	assign sum = value3 + value2 + value1 + value0;
endmodule

module sum_tb();
	logic [3:0] value3, value2, value1, value0, sum;
	
	sum dut(value3, value2, value1, value0, sum);
	
	initial begin
		value3 = 3'b000;	value2 = 3'b000;	value1 = 3'b000;	value0 = 3'b000; #10;
		value3 = 3'b000;	value2 = 3'b000;	value1 = 3'b000;	value0 = 3'b001; #10;
		value3 = 3'b000;	value2 = 3'b000;	value1 = 3'b001;	value0 = 3'b001; #10;
		value3 = 3'b000;	value2 = 3'b001;	value1 = 3'b001;	value0 = 3'b001; #10;
		value3 = 3'b001;	value2 = 3'b001;	value1 = 3'b001;	value0 = 3'b001; #10;
	end
endmodule
