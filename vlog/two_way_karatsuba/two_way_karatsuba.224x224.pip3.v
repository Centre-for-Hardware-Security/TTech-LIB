// TalTech large integer multiplier library
// Multiplier type: two_way_karatsuba
// Parameters: 224 224 3
// Target tool: genus
module two_way_karatsuba(clk, rst, a, b, c);
input clk;
input rst;
input [223:0] a;
input [223:0] b;
output reg [447:0] c;

reg [447:0] c_temp_2;
reg [447:0] c_temp_1;

// Wires declaration 
wire  [111:0] a1;
wire  [111:0] b1;
wire  [111:0] c1;
wire  [111:0] d1;
wire  [112:0] sum_a1b1;
wire  [112:0] sum_c1d1;

// Registers declaration 
reg  [111:0] counter_a1c1;
reg  [111:0] counter_b1d1;
reg  [113:0] counter_sum_a1b1_c1d1;
reg  [223:0] mul_a1c1;
reg  [223:0] mul_b1d1;
reg  [225:0] mul_sum_a1b1_sum_c1d1;

// breaking the inputs into 4 parts of equal length
assign a1 = a[223:112];
assign b1 = a[111:0];
assign c1 = b[223:112];
assign d1 = b[111:0];
// Step-1 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst) begin
		mul_a1c1 <= 224'd0;
		counter_a1c1 <= 112'd0;
	end
	else if (counter_a1c1 < 113) begin
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
		mul_b1d1 <= 224'd0;
		counter_b1d1 <= 112'd0;
	end
	else if (counter_b1d1 < 113) begin
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
		c_temp_2 = 448'd0;
		mul_sum_a1b1_sum_c1d1 = 226'd0;
		counter_sum_a1b1_c1d1 = 114'd0;
	end
	else if (counter_sum_a1b1_c1d1 < 113) begin
		if (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin
			mul_sum_a1b1_sum_c1d1 = mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);
			counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
		end
		counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
	end
	c_temp_2 = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;
	c_temp_2 = c_temp_2 << 112;
	c_temp_2 = c_temp_2 ^ (mul_a1c1 << 224);
	c_temp_2 = c_temp_2 ^ mul_b1d1;
end

// pipeline stages
always @(posedge clk) begin
	c <= c_temp_1;
	c_temp_1 <= c_temp_2;
end
endmodule
