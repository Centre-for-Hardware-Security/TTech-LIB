// TalTech large multiplier library
// Multiplier type: schoolbook
// Parameters: 571 571 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [570:0] a;
input [570:0] b;
output reg [1141:0] c;

// no pipeline vars
reg  [9:0] count;

always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 1142'd0;
		count <= 10'd0;
	end
	else begin
if (count < 571) begin
if (b[count] == 1) begin
c <= c + (a << count);
end
count <= count + 1;
end

	end
end
endmodule
