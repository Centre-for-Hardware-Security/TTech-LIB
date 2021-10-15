// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 571 571 4
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [570:0] a;
input [570:0] b;
output reg [1141:0] c;

reg [570:0] a_temp_3;
reg [570:0] b_temp_3;
reg [570:0] a_temp_2;
reg [570:0] b_temp_2;
reg [570:0] a_temp_1;
reg [570:0] b_temp_1;

reg  [9:0] count;
reg  [1:0] skip;

always @(posedge clk) begin
	if (rst_n == 1'b0) begin
		c <= 1142'd0;
		count <= 10'd0;
		skip <= 2'd0;
	end
	else begin
		a_temp_1 <= a;
		b_temp_1 <= b;
		a_temp_2 <= a_temp_1;
		b_temp_2 <= b_temp_1;
		a_temp_3 <= a_temp_2;
		b_temp_3 <= b_temp_2;
		if (skip != 3) skip <= skip + 1;
		else begin
			if (count < 571) begin
				if (b_temp_3[count] == 1) begin
					c <= c + (a_temp_3 << count);
				end
				count <= count + 1;
			end
		end
	end
end
endmodule
