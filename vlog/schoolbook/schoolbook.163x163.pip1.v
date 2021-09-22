// TalTech large integer multiplier library
// Multiplier type: schoolbook
// Parameters: 163 163 1
// Target tool: genus
module schoolbook(clk, rst, a, b, c);
input clk;
input rst;
input [162:0] a;
input [162:0] b;
output reg [325:0] c;

// no pipeline vars
reg  [7:0] count;

always @(posedge clk) begin
	if (rst == 1'b0) begin
		c <= 326'd0;
		count <= 8'd0;
	end
	else begin
		if (count < 163) begin
			if (b[count] == 1) begin
				c <= c + (a << count);
			end
			count <= count + 1;
		end
	end
end
endmodule
