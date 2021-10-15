// TalTech large integer multiplier library
// Multiplier type: two_way_karatsuba
// Parameters: 283 283 1
// Target tool: genus
module two_way_karatsuba(clk, rst, a, b, c);
input clk;
input rst;
input [282:0] a;
input [282:0] b;
output reg [565:0] c;

// no pipeline vars
// Wires declaration 
wire  [140:0] a1;
wire  [140:0] b1;
wire  [140:0] c1;
wire  [140:0] d1;
wire  [141:0] sum_a1b1;
wire  [141:0] sum_c1d1;

// Registers declaration 
reg  [140:0] counter_a1c1;
reg  [140:0] counter_b1d1;
reg  [142:0] counter_sum_a1b1_c1d1;
reg  [282:0] mul_a1c1;
reg  [282:0] mul_b1d1;
reg  [284:0] mul_sum_a1b1_sum_c1d1;

// breaking the inputs into 4 parts of equal length
assign a1 = a[282:141];
assign b1 = a[140:0];
assign c1 = b[282:141];
assign d1 = b[140:0];
// Step-1 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst) begin
		mul_a1c1 <= 283'd0;
		counter_a1c1 <= 141'd0;
	end
	else if (counter_a1c1 < 142) begin
		if (a[counter_a1c1] == 1'b1) begin
			mul_a1c1 <= mul_a1c1 ^ (c1 << counter_a1c1);
			counter_a1c1 <= counter_a1c1 + 1;
		end
		counter_a1c1 <= counter_a1c1 + 1;
	end
end

// Step-2 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst) begin
		mul_b1d1 <= 283'd0;
		counter_b1d1 <= 141'd0;
	end
	else if (counter_b1d1 < 142) begin
		if (b[counter_b1d1] == 1'b1) begin
			mul_b1d1 <= mul_a1c1 ^ (d1 << counter_b1d1);
			counter_b1d1 <= counter_b1d1 + 1;
		end
		counter_b1d1 <= counter_b1d1 + 1;
	end
end

// Assignments to sum_a1b1 and sum_c1d1
assign sum_a1b1 = a1 ^ b1;
assign sum_c1d1 = c1 ^ d1;

// Step-3 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst) begin
		c = 566'd0;
		mul_sum_a1b1_sum_c1d1 = 285'd0;
		counter_sum_a1b1_c1d1 = 143'd0;
	end
	else if (counter_sum_a1b1_c1d1 < 142) begin
		if (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin
			mul_sum_a1b1_sum_c1d1 = mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);
			counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
		end
		counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
	end
	c = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;
	c = c << 141;
	c = c ^ (mul_a1c1 << 283);
	c = c ^ mul_b1d1;
end
endmodule
