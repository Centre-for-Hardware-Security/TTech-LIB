// TalTech large integer multiplier library
// Multiplier type: four_way_toom_cook
// Parameters: 571 571 3
// Target tool: genus
module four_way_toom_cook(clk, rst, a, b, c);
input clk;
input rst;
input [570:0] a;
input [570:0] b;
output reg [1141:0] c;

// Pipeline register declaration 
reg [1141:0] c_temp_2;
reg [1141:0] c_temp_1;

// Wires declaration 
wire  [142:0] a0;
wire  [142:0] a1;
wire  [141:0] a2;
wire  [142:0] a3;
wire  [142:0] b0;
wire  [142:0] b1;
wire  [141:0] b2;
wire  [142:0] b3;

// Registers declaration 
reg  [141:0] counter_d;
reg  [141:0] counter_e1;
reg  [141:0] counter_e2;
reg  [141:0] counter_f1;
reg  [141:0] counter_f2;
reg  [141:0] counter_f3;
reg  [141:0] counter_g1;
reg  [141:0] counter_g2;
reg  [141:0] counter_g3;
reg  [141:0] counter_g4;
reg  [141:0] counter_h1;
reg  [141:0] counter_h2;
reg  [141:0] counter_h3;
reg  [141:0] counter_i1;
reg  [141:0] counter_i2;
reg  [141:0] counter_j;
reg  [570:0] d;
reg  [570:0] e1_mul;
reg  [570:0] e2_mul;
reg  [570:0] e;
reg  [570:0] f1_mul;
reg  [570:0] f2_mul;
reg  [570:0] f3_mul;
reg  [570:0] f;
reg  [570:0] g1_mul;
reg  [570:0] g2_mul;
reg  [570:0] g3_mul;
reg  [570:0] g4_mul;
reg  [570:0] g;
reg  [570:0] h1_mul;
reg  [570:0] h2_mul;
reg  [570:0] h3_mul;
reg  [570:0] h;
reg  [570:0] i1_mul;
reg  [570:0] i2_mul;
reg  [570:0] i;
reg  [570:0] j;
reg  [1141:0] temp;

// Initial assignments to wires
assign a0 = a[142:0];
assign a1 = a[285:143];
assign a2 = a[427:286];
assign a3 = a[570:428];
assign b0 = b[142:0];
assign b1 = b[285:143];
assign b2 = b[427:286];
assign b3 = b[570:428];

// Step-1 of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin			counter_d <= 142'd0;
			d <= 571'd0;
		end
		else if (counter_d < 143) begin
			if (a3[counter_d] == 1'b1) begin
				d <= d ^ (b3 << counter_d);
				counter_d <= counter_d + 1;
			end
			counter_d <= counter_d + 1;
		end
end

// Step-2 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_e1 <= 142'd0;
			e1_mul <= 571'd0;
		end
		else if (counter_e1 < 143) begin
			if (a2[counter_e1] == 1'b1) begin
				e1_mul <= e1_mul ^ (b3 << counter_e1);
				counter_e1 <= counter_e1 + 1;
			end
			counter_e1 <= counter_e1 + 1;
		end
end

// Step-2 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_e2 <= 142'd0;
			e2_mul <= 571'd0;
		end
		else if (counter_e2 < 143) begin
			if (a3[counter_e1] == 1'b1) begin
				e2_mul <= e2_mul ^ (b2 << counter_e2);
				counter_e2 <= counter_e2 + 1;
			end
			counter_e2 <= counter_e2 + 1;
		end
end

// Step-2 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			e <= 571'd0;
		end
		else begin
			e <= e1_mul ^ e2_mul;
		end
end

// Step-3 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_f1 <= 142'd0;
			f1_mul <= 571'd0;
		end
		else if (counter_f1 < 143) begin
			if (a1[counter_f1] == 1'b1) begin
				f1_mul <= f1_mul ^ (b3 << counter_f1);
				counter_f1 <= counter_f1 + 1;
			end
			counter_f1 <= counter_f1 + 1;
		end
end

// Step-3 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_f2 <= 142'd0;
			f2_mul <= 571'd0;
		end
		else if (counter_f2 < 143) begin
			if (a2[counter_f2] == 1'b1) begin
				f2_mul <= f2_mul ^ (b2 << counter_f2);
				counter_f2 <= counter_f2 + 1;
			end
			counter_f2 <= counter_f2 + 1;
		end
end

// Step-3 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_f3 <= 142'd0;
			f3_mul <= 571'd0;
		end
		else if (counter_f3 < 143) begin
			if (a3[counter_f3] == 1'b1) begin
				f3_mul <= f3_mul ^ (b1 << counter_f3);
				counter_f3 <= counter_f3 + 1;
			end
			counter_f3 <= counter_f3 + 1;
		end
end

// Step-3 (Part-4) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			f <= 571'd0;
		end
		else begin
			f <= f1_mul ^ f2_mul ^ f3_mul;
		end
end

// Step-4 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_g1 <= 142'd0;
			g1_mul <= 571'd0;
		end
		else if (counter_g1 < 143) begin
			if (a0[counter_g1] == 1'b1) begin
				g1_mul <= g1_mul ^ (b3 << counter_g1);
				counter_g1 <= counter_g1 + 1;
			end
			counter_g1 <= counter_g1 + 1;
		end
end

// Step-4 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_g2 <= 142'd0;
			g2_mul <= 571'd0;
		end
		else if (counter_g2 < 143) begin
			if (a1[counter_g2] == 1'b1) begin
				g2_mul <= g2_mul ^ (b2 << counter_g2);
				counter_g2 <= counter_g2 + 1;
			end
			counter_g2 <= counter_g2 + 1;
		end
end

// Step-4 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_g3 <= 142'd0;
			g3_mul <= 571'd0;
		end
		else if (counter_g3 < 143) begin
			if (a2[counter_g3] == 1'b1) begin
				g3_mul <= g3_mul ^ (b1 << counter_g3);
				counter_g3 <= counter_g3 + 1;
			end
			counter_g3 <= counter_g3 + 1;
		end
end

// Step-4 (Part-4) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_g4 <= 142'd0;
			g4_mul <= 571'd0;
		end
		else if (counter_g4 < 143) begin
			if (a3[counter_g4] == 1'b1) begin
				g4_mul <= g4_mul ^ (b0 << counter_g4);
				counter_g4 <= counter_g4 + 1;
			end
			counter_g4 <= counter_g4 + 1;
		end
end

// Step-4 (Part-5) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			g <= 571'd0;
		end
		else begin
			g <= g1_mul ^ g2_mul ^ g3_mul ^ g4_mul;
		end
end

// Step-5 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_h1 <= 142'd0;
			h1_mul <= 571'd0;
		end
		else if (counter_h1 < 143) begin
			if (a0[counter_h1] == 1'b1) begin
				h1_mul <= h1_mul ^ (b2 << counter_h1);
				counter_h1 <= counter_h1 + 1;
			end
			counter_h1 <= counter_h1 + 1;
		end
end

// Step-5 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_h2 <= 142'd0;
			h2_mul <= 571'd0;
		end
		else if (counter_h2 < 143) begin
			if (a1[counter_h2] == 1'b1) begin
				h2_mul <= h2_mul ^ (b1 << counter_h2);
				counter_h2 <= counter_h2 + 1;
			end
			counter_h2 <= counter_h2 + 1;
		end
end

// Step-5 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_h3 <= 142'd0;
			h3_mul <= 571'd0;
		end
		else if (counter_h3 < 143) begin
			if (a2[counter_h3] == 1'b1) begin
				h3_mul <= h3_mul ^ (b0 << counter_h3);
				counter_h3 <= counter_h3 + 1;
			end
			counter_h3 <= counter_h3 + 1;
		end
end

// Step-5 (Part-4) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			h <= 571'd0;
		end
		else begin
			h <= h1_mul ^ h2_mul ^ h3_mul;
		end
end

// Step-6 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_i1 <= 142'd0;
			i1_mul <= 571'd0;
		end
		else if (counter_i1 < 143) begin
			if (a0[counter_i1] == 1'b1) begin
				i1_mul <= i2_mul ^ (b1 << counter_i1);
				counter_i1 <= counter_i1 + 1;
			end
			counter_i1 <= counter_i1 + 1;
		end
end

// Step-6 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_i2 <= 142'd0;
			i2_mul <= 571'd0;
		end
		else if (counter_i2 < 143) begin
			if (a1[counter_i2] == 1'b1) begin
				i2_mul <= i2_mul ^ (b0 << counter_i2);
				counter_i2 <= counter_i2 + 1;
			end
			counter_i2 <= counter_i2 + 1;
		end
end

// Step-6 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			i <= 571'd0;
		end
		else begin
			i <= i1_mul ^ i2_mul;
		end
end

// Step-7 of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			counter_j = 142'd0;
			j = 571'd0;
		end
		else if (counter_j < 143) begin
			if (a0[counter_j] == 1'b1) begin
				j = j ^ (b0 << counter_j);
				counter_j = counter_j + 1;
			end
			counter_j = counter_j + 1;
		end
end

// Step-8 of 4-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			temp = 1142'd0;
			c = 1142'd0;
		end
		else begin
			temp = j;
			temp = temp ^ (i << 142);
			temp = temp ^ (h << 284);
			temp = temp ^ (g << 426);
			temp = c_temp_2 ^ (f << 568);
			temp = temp ^ (e << 710);
			temp = temp ^ (d << 852);
			c = temp;
		end
end

// pipeline stages
always @(posedge clk) begin
	c_temp_1 <= temp;
	c_temp_2 <= c_temp_1;
end
endmodule
