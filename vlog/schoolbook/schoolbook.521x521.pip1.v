// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 521 521 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [520:0] a;
input [520:0] b;
output reg [1041:0] c;

// no pipeline vars
reg  [9:0] count;

always @(posedge clk) begin
	if (rst == 1'b0) begin
		c <= 1042'd0;
		count <= 10'd0;
	end
	else begin
		if (count < 521) begin
			if (b[count] == 1) begin
				c <= c + (a << count);
			end
			count <= count + 1;
		end
	end
end
endmodule
