// TalTech large multiplier library
// Multiplier type: schoolbook
// Parameters: 64 64 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [63:0] a;
input [63:0] b;
output reg [127:0] c;

// no pipeline vars
reg  [6:0] count;

always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 128'd0;
		count <= 7'd0;
	end
	else begin
if (count < 64) begin
if (b[count] == 1) begin
c <= c + (a << count);
end
count <= count + 1;
end

	end
end
endmodule
