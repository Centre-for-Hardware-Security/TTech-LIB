// TalTech large multiplier library
// Multiplier type: two_way_karatsuba
// Parameters: 233 233 1
// Target tool: genus
module two_way_karatsuba(clk, rst, a, b, c);
input clk;
input rst;
input [232:0] a;
input [232:0] b;
output reg [465:0] c;

// Wires declaration 
wire  [115:0] a1;
wire  [115:0] b1;
wire  [115:0] c1;
wire  [115:0] d1;
wire  [116:0] sum_a1b1;
wire  [116:0] sum_c1d1;

// Registers declaration 
reg  [115:0] counter_a1c1;
reg  [115:0] counter_b1d1;
reg  [117:0] counter_sum_a1b1_c1d1;
reg  [232:0] mul_a1c1;
reg  [232:0] mul_b1d1;
reg  [234:0] mul_sum_a1b1_sum_c1d1;

// Initializations / initial assignments
assign a1 = a[231:116];
assign b1 = a[115:0];
assign c1 = b[231:116];
assign d1 = b[115:0];

// Step-1 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
		if (rst) begin
			mul_a1c1 <= 233'd0;
			counter_a1c1 <= 116'd0;
		end
		else if (counter_a1c1 < 117) begin
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
			mul_b1d1 <= 233'd0;
			counter_b1d1 <= 116'd0;
		end
		else if (counter_b1d1 < 117) begin
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
			c = 466'd0;
			mul_sum_a1b1_sum_c1d1 = 235'd0;
			counter_sum_a1b1_c1d1 = 118'd0;
		end
		else if (counter_sum_a1b1_c1d1 < 117) begin
			if (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin
				mul_sum_a1b1_sum_c1d1 = mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);
				counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
			end
				counter_sum_a1b1_c1d1 = counter_sum_a1b1_c1d1 + 1;
		end
	c = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;
	c = c << 116;
	c = c ^ (mul_a1c1 << 233);
	c = c ^ mul_b1d1;

end
endmodule
