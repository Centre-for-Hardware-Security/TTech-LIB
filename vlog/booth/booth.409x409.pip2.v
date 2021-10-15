// TalTech large integer multiplier library
// Multiplier type: booth
// Parameters: 409 409 2
// Target tool: genus
module booth(clk, rst, a, b, c);
input clk;
input rst;
input [408:0] a;
input [408:0] b;
output reg [817:0] c;

// Testing 456
reg [408:0] c_temp_1;


// Registers declaration 
reg  [408:0] mul_w_signguard;
reg  [8:0] count;
reg  [408:0] add_w_signguard;
reg  [817:0] mul_ab1;

// Step-1 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		count <= 9'd0;
	else if (|count)
		count <= (count - 1);
	else
		count <= 9'd408;
end

// Step-2 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_w_signguard <= 408'd0;
	else
		mul_w_signguard <= {a[408 - 1], a};
end

// Step-3 of Booth Multiplier
always @(*) begin
	case (mul_ab1[1:0])
		2'b01     : c_temp_1 <= mul_ab1[817:409] + mul_w_signguard;
		2'b10     : c_temp_1 <= mul_ab1[817:409] - mul_w_signguard;
		default   : c_temp_1 <= mul_ab1[817:409];
	endcase
end

// Step-4 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		mul_ab1 <= 817'd0;
	else if (|count)
		mul_ab1 <= {c_temp_1[408], c_temp_1, mul_ab1[408:1]};
	else
		mul_ab1 <= {b, 1'b0};
end

// Step-5 of Booth Multiplier
always @(posedge clk) begin
	if (rst)
		c <= 817'd0;
	else if (count == 1)
		c <= {c_temp_1[408], c_temp_1, mul_ab1[408:2]};
end

// pipeline stages
always @(posedge clk) begin
	add_w_signguard <= c_temp_1;
end
endmodule
