// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 233 233 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [232:0] a;
input [232:0] b;
output reg [465:0] c;

// no pipeline vars
reg  [7:0] count;

always @(posedge clk) begin
	if (rst == 1'b0) begin
		c <= 466'd0;
		count <= 8'd0;
	end
	else begin
		if (count < 233) begin
			if (b[count] == 1) begin
				c <= c + (a << count);
			end
			count <= count + 1;
		end
	end
end
endmodule
