// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 521 521 3
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [520:0] a;
input [520:0] b;
output reg [1041:0] c;

reg [520:0] a_temp_2;
reg [520:0] b_temp_2;
reg [520:0] a_temp_1;
reg [520:0] b_temp_1;

reg  [9:0] count;
reg  [1:0] skip;

always @(posedge clk) begin
	if (rst == 1'b0) begin
		c <= 1042'd0;
		count <= 10'd0;
		skip <= 2'd0;
	end
	else begin
		a_temp_1 <= a;
		b_temp_1 <= b;
		a_temp_2 <= a_temp_1;
		b_temp_2 <= b_temp_1;
		if (skip != 2) skip <= skip + 1;
		else begin
			if (count < 521) begin
				if (b_temp_2[count] == 1) begin
					c <= c + (a_temp_2 << count);
				end
				count <= count + 1;
			end
		end
	end
end
endmodule
