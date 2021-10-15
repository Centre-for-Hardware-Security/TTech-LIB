// TalTech large integer multiplier library
// Multiplier type: booth
// Parameters: 192 192 1
// Target tool: genus
module booth(clk, rst, a, b, c);
input clk;
input rst;
input [191:0] a;
input [191:0] b;
output reg [383:0] c;

// Testing 456
// no pipeline vars

// Registers declaration 
reg  [191:0] mul_w_signguard;
reg  [7:0] count;
reg  [191:0] add_w_signguard;
reg  [383:0] mul_ab1;

// Step-1 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		count <= 8'd0;
	else if (|count)
		count <= (count - 1);
	else
		count <= 8'd191;
end

// Step-2 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_w_signguard <= 191'd0;
	else
		mul_w_signguard <= {a[191 - 1], a};
end

// Step-3 of Booth Multiplier
always @(*) begin
	case (mul_ab1[1:0])
		2'b01     : add_w_signguard <= mul_ab1[383:192] + mul_w_signguard;
		2'b10     : add_w_signguard <= mul_ab1[383:192] - mul_w_signguard;
		default   : add_w_signguard <= mul_ab1[383:192];
	endcase
end

// Step-4 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_ab1 <= 383'd0;
	else if (|count)
		mul_ab1 <= {add_w_signguard[191], add_w_signguard, mul_ab1[191:1]};
	else
		mul_ab1 <= {b, 1'b0};
end

// Step-5 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		c <= 383'd0;
	else if (count == 1)
		c <= {add_w_signguard[191], add_w_signguard, mul_ab1[191:2]};
end
endmodule
