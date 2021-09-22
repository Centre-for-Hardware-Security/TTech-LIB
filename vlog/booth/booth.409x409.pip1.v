// TalTech large integer multiplier library
// Multiplier type: booth
// Parameters: 409 409 1
// Target tool: genus
module booth(clk, rst, a, b, c);
input clk;
input rst;
input [408:0] a;
input [408:0] b;
output reg [817:0] c;

// no pipeline vars

// Registers declaration 
reg  [409:0] mul_w_signguard;
reg  [8:0] count;
reg  [409:0] add_w_signguard;
reg  [819:0] mul_ab1;

// Step-1 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		count <= 9'd0;
	else if (|count)
		count <= (count - 1);
	else
		count <= 9'd409;
end

// Step-2 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_w_signguard <= 409'd0;
	else
		mul_w_signguard <= {a[409 - 1], a};
end

// Step-3 of Booth Multiplier
always @(*) begin
	case (mul_ab1[1:0])
		2'b01     : add_w_signguard <= mul_ab1[819:410] + mul_w_signguard;
		2'b10     : add_w_signguard <= mul_ab1[819:410] - mul_w_signguard;
		default   : add_w_signguard <= mul_ab1[819:410];
	endcase
end

// Step-4 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_ab1 <= 819'd0;
	else if (|count)
		mul_ab1 <= {add_w_signguard[409], add_w_signguard, mul_ab1[409:1]};
	else
		mul_ab1 <= {b, 1'b0};
end

// Step-5 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		c <= 817'd0;
	else if (count == 1)
		c <= {add_w_signguard[409], add_w_signguard, mul_ab1[409:2]};
end
endmodule
