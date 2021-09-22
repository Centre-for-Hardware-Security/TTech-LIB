// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 233 233 2
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [232:0] a;
input [232:0] b;
output reg [465:0] c;

reg [232:0] a_temp_1;
reg [232:0] b_temp_1;

reg  [7:0] count;
reg skip;

always @(posedge clk) begin
	if (rst == 1'b0) begin
		c <= 466'd0;
		count <= 8'd0;
		skip <= 1'd0;
	end
	else begin
		a_temp_1 <= a;
		b_temp_1 <= b;
		if (skip != 1) skip <= skip + 1;
		else begin
			if (count < 233) begin
				if (b_temp_1[count] == 1) begin
					c <= c + (a_temp_1 << count);
				end
				count <= count + 1;
			end
		end
	end
end
endmodule
