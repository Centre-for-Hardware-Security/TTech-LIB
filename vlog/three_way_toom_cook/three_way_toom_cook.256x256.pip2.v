// TalTech large integer multiplier library
// Multiplier type: three_way_toom_cook
// Parameters: 256 256 2
// Target tool: genus
// Here, we split the input operands into three equal sizes256
module three_way_toom_cook(clk, rst, a, b, c);
input clk;
input rst;
input [255:0] a;
input [255:0] b;
output reg [511:0] c;

// Pipeline register declaration 
reg [255:0] c_temp_1;

// Wires declaration 
wire  [85:0] a0;
wire  [84:0] a1;
wire  [84:0] a2;
wire  [85:0] b0;
wire  [84:0] b1;
wire  [84:0] b2;

// Registers declaration 
reg  [84:0] counter_d;
reg  [84:0] counter_e1;
reg  [84:0] counter_e2;
reg  [84:0] counter_f1;
reg  [84:0] counter_f2;
reg  [84:0] counter_f3;
reg  [84:0] counter_g1;
reg  [84:0] counter_g2;
reg  [84:0] counter_h;
reg  [255:0] d;
reg  [255:0] e1_mul;
reg  [255:0] e2_mul;
reg  [255:0] e;
reg  [255:0] f1_mul;
reg  [255:0] f2_mul;
reg  [255:0] f3_mul;
reg  [255:0] f;
reg  [255:0] g1_mul;
reg  [255:0] g2_mul;
reg  [255:0] g;
reg  [255:0] h;
reg  [511:0] temp;

// Initial assignments to wires
assign a0 = a[85:0];
assign a1 = a[170:86];
assign a2 = a[255:171];
assign b0 = b[85:0];
assign b1 = b[170:86];
assign b2 = b[255:171];

// Step-1 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		d <= 256'd0;
		counter_d <= 85'd0;
	end
	else if (counter_d < 86) begin
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
		e1_mul <= 256'd0;
		counter_e1 <= 85'd0;
	end
	else if (counter_e1 < 86) begin
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
		e2_mul <= 256'd0;
		counter_e2 <= 85'd0;
	end
	else if (counter_e2 < 86) begin
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
		e <= 256'd0;
	end
	else begin
		e <= e1_mul ^ e2_mul; 
	end
end

// Step-3 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		f1_mul <= 256'd0;
		counter_f1 <= 85'd0;
	end
	else if (counter_f1 < 86) begin
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
		f2_mul <= 256'd0;
		counter_f2 <= 85'd0;
	end
	else if (counter_f2 < 86) begin
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
		f3_mul <= 256'd0;
		counter_f3 <= 85'd0;
	end
	else if (counter_f3 < 86) begin
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
		f <= 256'd0;
	end
	else begin
		f <= f1_mul ^ f2_mul ^ f3_mul; 
	end
end

// Step-4 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		g1_mul <= 256'd0;
		counter_g1 <= 85'd0;
	end
	else if (counter_g1 < 86) begin
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
		g2_mul <= 256'd0;
		counter_g2 <= 85'd0;
	end
	else if (counter_g2 < 86) begin
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
		g <= 256'd0;
	end
	else begin
		g <= g1_mul ^ g2_mul; 
	end
end

// Step-5 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst) begin
		h <= 256'd0;
		counter_h <= 85'd0;
	end
	else if (counter_h < 86) begin
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
		temp = 512'd0;
		c = 512'd0;
	end
	else begin
		temp = h;
		temp = temp ^ (g << 85);
		temp = temp ^ (c_temp_1 << 170);
		temp = temp ^ (e << 255);
		temp = temp ^ (d << 340);
		c = temp;
	end
end

// pipeline stages
always @(posedge clk) begin
	c_temp_1 <= f;
end
endmodule
