// TalTech large integer multiplier library
// Multiplier type: booth
// Parameters: 521 521 1
// Target tool: genus
module booth(clk, rst, a, b, c);
input clk;
input rst;
input [520:0] a;
input [520:0] b;
output reg [1041:0] c;

// no pipeline vars

// Registers declaration 
reg  [521:0] mul_w_signguard;
reg  [9:0] count;
reg  [521:0] add_w_signguard;
reg  [1043:0] mul_ab1;

// Step-1 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		count <= 10'd0;
	else if (|count)
		count <= (count - 1);
	else
		count <= 10'd521;
end

// Step-2 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_w_signguard <= 521'd0;
	else
		mul_w_signguard <= {a[521 - 1], a};
end

// Step-3 of Booth Multiplier
always @(*) begin
	case (mul_ab1[1:0])
		2'b01     : add_w_signguard <= mul_ab1[1043:522] + mul_w_signguard;
		2'b10     : add_w_signguard <= mul_ab1[1043:522] - mul_w_signguard;
		default   : add_w_signguard <= mul_ab1[1043:522];
	endcase
end

// Step-4 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_ab1 <= 1043'd0;
	else if (|count)
		mul_ab1 <= {add_w_signguard[521], add_w_signguard, mul_ab1[521:1]};
	else
		mul_ab1 <= {b, 1'b0};
end

// Step-5 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		c <= 1041'd0;
	else if (count == 1)
		c <= {add_w_signguard[521], add_w_signguard, mul_ab1[521:2]};
end
endmodule
