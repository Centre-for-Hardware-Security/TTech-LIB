// TalTech large integer multiplier library
// Multiplier type: two_way_karatsuba
// Parameters: 384 384 3
// Target tool: genus
module two_way_karatsuba(clk, rst, a, b, c);
input clk;
input rst;
input [383:0] a;
input [383:0] b;
output reg [767:0] c;

reg [767:0] c_temp_2;
reg [767:0] c_temp_1;

// Wires declaration 
wire  [191:0] a1;
wire  [191:0] b1;
wire  [191:0] c1;
wire  [191:0] d1;
wire  [192:0] sum_a1b1;
wire  [192:0] sum_c1d1;

// Registers declaration 
reg  [191:0] counter_a1c1;
reg  [191:0] counter_b1d1;
reg  [193:0] counter_sum_a1b1_c1d1;
reg  [383:0] mul_a1c1;
reg  [383:0] mul_b1d1;
reg  [385:0] mul_sum_a1b1_sum_c1d1;

// breaking the inputs into 4 parts of equal length
assign a1 = a[383:192];
assign b1 = a[191:0];
assign c1 = b[383:192];
assign d1 = b[191:0];
// Step-1 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst) begin
		mul_a1c1 <= 384'd0;
		counter_a1c1 <= 192'd0;
	end
	else if (counter_a1c1 < 193) begin
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
		mul_b1d1 <= 384'd0;
		counter_b1d1 <= 192'd0;
	end
	else if (counter_b1d1 < 193) begin
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
		c_temp_2 = 768'd0;
		mul_sum_a1b1_sum_c1d1 = 386'd0;
		counter_sum_a1b1_c1d1 = 194'd0;
	end
	else if (counter_sum_a1b1_c1d1 < 193) begin
		if (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin
			mul_sum_a1b1_sum_c1d1 = mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);
			counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
		end
		counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
	end
	c_temp_2 = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;
	c_temp_2 = c_temp_2 << 192;
	c_temp_2 = c_temp_2 ^ (mul_a1c1 << 384);
	c_temp_2 = c_temp_2 ^ mul_b1d1;
end

// pipeline stages
always @(posedge clk) begin
	c <= c_temp_1;
	c_temp_1 <= c_temp_2;
end
endmodule
