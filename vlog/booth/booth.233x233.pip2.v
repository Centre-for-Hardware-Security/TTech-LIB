// TalTech large integer multiplier library
// Multiplier type: booth
// Parameters: 233 233 2
// Target tool: genus
module booth(clk, rst, a, b, c);
input clk;
input rst;
input [232:0] a;
input [232:0] b;
output reg [465:0] c;

// Testing 456
reg [232:0] c_temp_1;


// Registers declaration 
reg  [232:0] mul_w_signguard;
reg  [7:0] count;
reg  [232:0] add_w_signguard;
reg  [465:0] mul_ab1;

// Step-1 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		count <= 8'd0;
	else if (|count)
		count <= (count - 1);
	else
		count <= 8'd232;
end

// Step-2 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_w_signguard <= 232'd0;
	else
		mul_w_signguard <= {a[232 - 1], a};
end

// Step-3 of Booth Multiplier
always @(*) begin
	case (mul_ab1[1:0])
		2'b01     : c_temp_1 <= mul_ab1[465:233] + mul_w_signguard;
		2'b10     : c_temp_1 <= mul_ab1[465:233] - mul_w_signguard;
		default   : c_temp_1 <= mul_ab1[465:233];
	endcase
end

// Step-4 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_ab1 <= 465'd0;
	else if (|count)
		mul_ab1 <= {c_temp_1[232], c_temp_1, mul_ab1[232:1]};
	else
		mul_ab1 <= {b, 1'b0};
end

// Step-5 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		c <= 465'd0;
	else if (count == 1)
		c <= {c_temp_1[232], c_temp_1, mul_ab1[232:2]};
end

// pipeline stages
always @(posedge clk) begin
	add_w_signguard <= c_temp_1;
end
endmodule
