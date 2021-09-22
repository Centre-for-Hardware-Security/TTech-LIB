// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 283 283 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [282:0] a;
input [282:0] b;
output reg [565:0] c;

// no pipeline vars
reg  [8:0] count;

always @(posedge clk) begin
	if (rst == 1'b0) begin
		c <= 566'd0;
		count <= 9'd0;
	end
	else begin
		if (count < 283) begin
			if (b[count] == 1) begin
				c <= c + (a << count);
			end
			count <= count + 1;
		end
	end
end
endmodule
