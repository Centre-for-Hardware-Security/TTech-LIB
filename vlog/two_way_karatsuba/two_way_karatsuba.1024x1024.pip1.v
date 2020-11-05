// TalTech large multiplier library
// Multiplier type: two_way_karatsuba
// Parameters: 1024 1024 1
// Target tool: genus
module two_way_karatsuba(clk, rst, a, b, c);
input clk;
input rst;
input [1023:0] a;
input [1023:0] b;
output reg [2047:0] c;

// Wires declaration 
wire  [511:0] a1;
wire  [511:0] b1;
wire  [511:0] c1;
wire  [511:0] d1;
wire  [512:0] sum_a1b1;
wire  [512:0] sum_c1d1;

// Registers declaration 
reg  [511:0] counter_a1c1;
reg  [511:0] counter_b1d1;
reg  [513:0] counter_sum_a1b1_c1d1;
reg  [1023:0] mul_a1c1;
reg  [1023:0] mul_b1d1;
reg  [1025:0] mul_sum_a1b1_sum_c1d1;

// Initializations / initial assignments
assign a1 = a[1023:512];
assign b1 = a[511:0];
assign c1 = b[1023:512];
assign d1 = b[511:0];

// Step-1 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 2048'd0;
		counter_a1c1 <= 512'd0;
		counter_b1d1 <= 512'd0;
		counter_sum_a1b1_c1d1 <= 514'd0;
		mul_a1c1 <= 1024'd0;
		mul_b1d1 <= 1024'd0;
		mul_sum_a1b1_sum_c1d1 <= 1026'd0;
	end
	else begin
		if (counter_a1c1 < 513) begin
			if (a[counter_a1c1] == 1'b1) begin
				mul_a1c1 <= mul_a1c1 ^ (c1 << counter_a1c1);
				counter_a1c1 <= counter_a1c1 + 1;
			end
				counter_a1c1 <= counter_a1c1 + 1;
		end

	end
end

// Step-2 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
		if (counter_b1d1 < 513) begin
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
		if (counter_sum_a1b1_c1d1 < 513) begin
			if (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin
				mul_sum_a1b1_sum_c1d1 <= mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);
				counter_sum_a1b1_c1d1 <= counter_sum_a1b1_c1d1 + 1;
			end
				counter_sum_a1b1_c1d1 <= counter_sum_a1b1_c1d1 + 1;
		end
	c = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;
	c = c << 512;
	c = c ^ (mul_a1c1 << 1024);
	c = c ^ mul_b1d1;

end
endmodule
