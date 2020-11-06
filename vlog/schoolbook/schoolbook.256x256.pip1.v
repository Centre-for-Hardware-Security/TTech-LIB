// TalTech large multiplier library
// Multiplier type: schoolbook
// Parameters: 256 256 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [255:0] a;
input [255:0] b;
output reg [511:0] c;

// no pipeline vars
reg  [8:0] count;

always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 512'd0;
		count <= 9'd0;
	end
	else begin
if (count < 256) begin
if (b[count] == 1) begin
c <= c + (a << count);
end
count <= count + 1;
end

	end
end
endmodule
