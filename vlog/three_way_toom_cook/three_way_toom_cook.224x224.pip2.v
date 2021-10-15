// TalTech large integer multiplier library
// Multiplier type: three_way_toom_cook
// Parameters: 224 224 2
// Target tool: genus
// Here, we split the input operands into three equal sizes224
module three_way_toom_cook(clk, rst, a, b, c);
input clk;
input rst;
input [223:0] a;
input [223:0] b;
output reg [447:0] c;

// Pipeline register declaration 
reg [223:0] c_temp_1;

// Wires declaration 
wire  [74:0] a0;
wire  [73:0] a1;
wire  [74:0] a2;
wire  [74:0] b0;
wire  [73:0] b1;
wire  [74:0] b2;

// Registers declaration 
reg  [73:0] counter_d;
reg  [73:0] counter_e1;
reg  [73:0] counter_e2;
reg  [73:0] counter_f1;
reg  [73:0] counter_f2;
reg  [73:0] counter_f3;
reg  [73:0] counter_g1;
reg  [73:0] counter_g2;
reg  [73:0] counter_h;
reg  [223:0] d;
reg  [223:0] e1_mul;
reg  [223:0] e2_mul;
reg  [223:0] e;
reg  [223:0] f1_mul;
reg  [223:0] f2_mul;
reg  [223:0] f3_mul;
reg  [223:0] f;
reg  [223:0] g1_mul;
reg  [223:0] g2_mul;
reg  [223:0] g;
reg  [223:0] h;
reg  [447:0] temp;

// Initial assignments to wires
assign a0 = a[74:0];
assign a1 = a[148:75];
assign a2 = a[223:149];
assign b0 = b[74:0];
assign b1 = b[148:75];
assign b2 = b[223:149];

// Step-1 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		d <= 224'd0;
		counter_d <= 74'd0;
	end
	else if (counter_d < 75) begin
		if (a2[counter_d] == 1'b1) begin
			d <= d ^ (b2 << counter_d);
			counter_d <= counter_d + 1;
		end
		counter_d <= counter_d + 1;
	end
end

// Step-2 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		e1_mul <= 224'd0;
		counter_e1 <= 74'd0;
	end
	else if (counter_e1 < 75) begin
		if (a1[counter_e1] == 1'b1) begin
			e1_mul <= e1_mul ^ (b2 << counter_e1);
			counter_e1 <= counter_e1 + 1;
		end
		counter_e1 <= counter_e1 + 1;
	end
end

// Step-2 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		e2_mul <= 224'd0;
		counter_e2 <= 74'd0;
	end
	else if (counter_e2 < 75) begin
		if (a2[counter_e1] == 1'b1) begin
			e2_mul <= e2_mul ^ (b1 << counter_e2);
			counter_e2 <= counter_e2 + 1;
		end
		counter_e2 <= counter_e2 + 1;
	end
end

// Step-2 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		e <= 224'd0;
	end
	else begin
		e <= e1_mul ^ e2_mul; 
	end
end

// Step-3 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		f1_mul <= 224'd0;
		counter_f1 <= 74'd0;
	end
	else if (counter_f1 < 75) begin
		if (a0[counter_f1] == 1'b1) begin
			f1_mul <= f1_mul ^ (b2 << counter_f1);
			counter_f1 <= counter_f1 + 1;
		end
		counter_f1 <= counter_f1 + 1;
	end
end

// Step-3 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		f2_mul <= 224'd0;
		counter_f2 <= 74'd0;
	end
	else if (counter_f2 < 75) begin
		if (a1[counter_f2] == 1'b1) begin
			f2_mul <= f2_mul ^ (b1 << counter_f2);
			counter_f2 <= counter_f2 + 1;
		end
		counter_f2 <= counter_f2 + 1;
	end
end

// Step-3 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		f3_mul <= 224'd0;
		counter_f3 <= 74'd0;
	end
	else if (counter_f3 < 75) begin
		if (a2[counter_f3] == 1'b1) begin
			f3_mul <= f3_mul ^ (b0 << counter_f3);
			counter_f3 <= counter_f3 + 1;
		end
		counter_f3 <= counter_f3 + 1;
	end
end

// Step-3 (Part-4) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		f <= 224'd0;
	end
	else begin
		f <= f1_mul ^ f2_mul ^ f3_mul; 
	end
end

// Step-4 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		g1_mul <= 224'd0;
		counter_g1 <= 74'd0;
	end
	else if (counter_g1 < 75) begin
		if (a0[counter_g1] == 1'b1) begin
			g1_mul <= g1_mul ^ (b1 << counter_g1);
			counter_g1 <= counter_g1 + 1;
		end
		counter_g1 <= counter_g1 + 1;
	end
end

// Step-4 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		g2_mul <= 224'd0;
		counter_g2 <= 74'd0;
	end
	else if (counter_g2 < 75) begin
		if (a1[counter_g2] == 1'b1) begin
			g2_mul <= g2_mul ^ (b0 << counter_g2);
			counter_g2 <= counter_g2 + 1;
		end
		counter_g2 <= counter_g2 + 1;
	end
end

// Step-4 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		g <= 224'd0;
	end
	else begin
		g <= g1_mul ^ g2_mul; 
	end
end

// Step-5 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		h <= 224'd0;
		counter_h <= 74'd0;
	end
	else if (counter_h < 75) begin
		if (a0[counter_h] == 1'b1) begin
			h <= h ^ (b0 << counter_h);
			counter_h <= counter_h + 1;
		end
	counter_h <= counter_h + 1;
	end
end

// Step-6 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		temp = 448'd0;
		c = 448'd0;
	end
	else begin
		temp = h;
		temp = temp ^ (g << 74);
		temp = temp ^ (c_temp_1 << 148);
		temp = temp ^ (e << 222);
		temp = temp ^ (d << 296);
		c = temp;
	end
end

// pipeline stages
always @(posedge clk) begin
	c_temp_1 <= f;
end
endmodule
