// TalTech large multiplier library
// Multiplier type: schoolbook
// Parameters: 1024 1024 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [1023:0] a;
input [1023:0] b;
output reg [2047:0] c;

// no pipeline vars
reg  [10:0] count;

always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 2048'd0;
		count <= 11'd0;
	end
	else begin
if (count < 1024) begin
if (b[count] == 1) begin
c <= c + (a << count);
end
count <= count + 1;
end

	end
end
endmodule
