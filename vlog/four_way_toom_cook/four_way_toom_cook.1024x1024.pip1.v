// TalTech large multiplier library
// Multiplier type: four_way_toom_cook
// Parameters: 1024 1024 1
// Target tool: genus
module four_way_toom_cook(clk, rst, a, b, c);
input clk;
input rst;
input [1023:0] a;
input [1023:0] b;
output reg [2047:0] c;

// Wires declaration 
wire  [255:0] a0;
wire  [255:0] a1;
wire  [255:0] a2;
wire  [255:0] a3;
wire  [255:0] b0;
wire  [255:0] b1;
wire  [255:0] b2;
wire  [255:0] b3;

// Registers declaration 
reg  [255:0] counter_d;
reg  [255:0] counter_e1;
reg  [255:0] counter_e2;
reg  [255:0] counter_f1;
reg  [255:0] counter_f2;
reg  [255:0] counter_f3;
reg  [255:0] counter_g1;
reg  [255:0] counter_g2;
reg  [255:0] counter_g3;
reg  [255:0] counter_g4;
reg  [255:0] counter_h1;
reg  [255:0] counter_h2;
reg  [255:0] counter_h3;
reg  [255:0] counter_i1;
reg  [255:0] counter_i2;
reg  [255:0] counter_j;
reg  [1023:0] d;
reg  [1023:0] e1_mul;
reg  [1023:0] e2_mul;
reg  [1023:0] e;
reg  [1023:0] f1_mul;
reg  [1023:0] f2_mul;
reg  [1023:0] f3_mul;
reg  [1023:0] f;
reg  [1023:0] g1_mul;
reg  [1023:0] g2_mul;
reg  [1023:0] g3_mul;
reg  [1023:0] g4_mul;
reg  [1023:0] g;
reg  [1023:0] h1_mul;
reg  [1023:0] h2_mul;
reg  [1023:0] h3_mul;
reg  [1023:0] h;
reg  [1023:0] i1_mul;
reg  [1023:0] i2_mul;
reg  [1023:0] i;
reg  [1023:0] j;
reg  [2047:0] temp;

// Initial assignments to wires
assign a0 = a[255:0];
assign a1 = a[511:256];
assign a2 = a[767:512];
assign a3 = a[1023:768];
assign b0 = b[255:0];
assign b1 = b[511:256];
assign b2 = b[767:512];
assign b3 = b[1023:768];

// Step-1 of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 2048'd0;
		counter_d <= 256'd0;
		counter_e1 <= 256'd0;
		counter_e2 <= 256'd0;
		counter_f1 <= 256'd0;
		counter_f2 <= 256'd0;
		counter_f3 <= 256'd0;
		counter_g1 <= 256'd0;
		counter_g2 <= 256'd0;
		counter_g3 <= 256'd0;
		counter_g4 <= 256'd0;
		counter_h1 <= 256'd0;
		counter_h2 <= 256'd0;
		counter_h3 <= 256'd0;
		counter_i1 <= 256'd0;
		counter_i2 <= 256'd0;
		counter_j <= 256'd0;
		d <= 1024'd0;
		e1_mul <= 1024'd0;
		e2_mul <= 1024'd0;
		e <= 1024'd0;
		f1_mul <= 1024'd0;
		f2_mul <= 1024'd0;
		f3_mul <= 1024'd0;
		f <= 1024'd0;
		g1_mul <= 1024'd0;
		g2_mul <= 1024'd0;
		g3_mul <= 1024'd0;
		g4_mul <= 1024'd0;
		g <= 1024'd0;
		h1_mul <= 1024'd0;
		h2_mul <= 1024'd0;
		h3_mul <= 1024'd0;
		h <= 1024'd0;
		i1_mul <= 1024'd0;
		i2_mul <= 1024'd0;
		i <= 1024'd0;
		j <= 1024'd0;
		temp <= 2048'd0;
	end
	else begin
		if (counter_d < 257) begin
			if (a3[counter_d] == 1'b1) begin
				d <= d ^ (b3 << counter_d);
				counter_d <= counter_d + 1;
			end
				counter_d <= counter_d + 1;
		end
	end
end

// Step-2 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_e1 < 257) begin
		if (a2[counter_e1] == 1'b1) begin
			e1_mul <= e1_mul ^ (b3 << counter_e1);
			counter_e1 <= counter_e1 + 1;
		end
			counter_e1 <= counter_e1 + 1;
	end
end

// Step-2 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_e2 < 257) begin
		if (a3[counter_e1] == 1'b1) begin
			e2_mul <= e2_mul ^ (b2 << counter_e2);
			counter_e2 <= counter_e2 + 1;
		end
			counter_e2 <= counter_e2 + 1;
	end
end

// Step-2 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
	e <= e1_mul ^ e2_mul; 
end

// Step-3 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_f1 < 257) begin
		if (a1[counter_f1] == 1'b1) begin
			f1_mul <= f1_mul ^ (b3 << counter_f1);
			counter_f1 <= counter_f1 + 1;
		end
			counter_f1 <= counter_f1 + 1;
	end
end

// Step-3 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_f2 < 257) begin
		if (a2[counter_f2] == 1'b1) begin
			f2_mul <= f2_mul ^ (b2 << counter_f2);
			counter_f2 <= counter_f2 + 1;
		end
			counter_f2 <= counter_f2 + 1;
	end
end

// Step-3 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_f3 < 257) begin
		if (a3[counter_f3] == 1'b1) begin
			f3_mul <= f3_mul ^ (b1 << counter_f3);
			counter_f3 <= counter_f3 + 1;
		end
			counter_f3 <= counter_f3 + 1;
	end
end

// Step-3 (Part-4) of 4-Way TCM Multiplier
always @(posedge clk) begin
	f <= f1_mul ^ f2_mul ^ f3_mul; 
end

// Step-4 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_g1 < 257) begin
		if (a0[counter_g1] == 1'b1) begin
			g1_mul <= g1_mul ^ (b3 << counter_g1);
			counter_g1 <= counter_g1 + 1;
		end
			counter_g1 <= counter_g1 + 1;
	end
end

// Step-4 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_g2 < 257) begin
		if (a1[counter_g2] == 1'b1) begin
			g2_mul <= g2_mul ^ (b2 << counter_g2);
			counter_g2 <= counter_g2 + 1;
		end
			counter_g2 <= counter_g2 + 1;
	end
end

// Step-4 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_g3 < 257) begin
		if (a2[counter_g3] == 1'b1) begin
			g3_mul <= g3_mul ^ (b1 << counter_g3);
			counter_g3 <= counter_g3 + 1;
		end
			counter_g3 <= counter_g3 + 1;
	end
end

// Step-4 (Part-4) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_g4 < 257) begin
		if (a3[counter_g4] == 1'b1) begin
			g4_mul <= g4_mul ^ (b0 << counter_g4);
			counter_g4 <= counter_g4 + 1;
		end
			counter_g4 <= counter_g4 + 1;
	end
end

// Step-4 (Part-5) of 4-Way TCM Multiplier
always @(posedge clk) begin
	g <= g1_mul ^ g2_mul ^ g3_mul ^ g4_mul; 
end

// Step-5 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_h1 < 257) begin
		if (a0[counter_h1] == 1'b1) begin
			h1_mul <= h1_mul ^ (b2 << counter_h1);
			counter_h1 <= counter_h1 + 1;
		end
			counter_h1 <= counter_h1 + 1;
	end
end

// Step-5 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_h2 < 257) begin
		if (a1[counter_h2] == 1'b1) begin
			h2_mul <= h2_mul ^ (b1 << counter_h2);
			counter_h2 <= counter_h2 + 1;
		end
			counter_h2 <= counter_h2 + 1;
	end
end

// Step-5 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_h3 < 257) begin
		if (a2[counter_h3] == 1'b1) begin
			h3_mul <= h3_mul ^ (b0 << counter_h3);
			counter_h3 <= counter_h3 + 1;
		end
			counter_h3 <= counter_h3 + 1;
	end
end

// Step-5 (Part-4) of 4-Way TCM Multiplier
always @(posedge clk) begin
	h <= h1_mul ^ h2_mul ^ h3_mul; 
end

// Step-6 (Part-1) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_i1 < 257) begin
		if (a0[counter_i1] == 1'b1) begin
			i1_mul <= i2_mul ^ (b1 << counter_i1);
			counter_i1 <= counter_i1 + 1;
		end
			counter_i1 <= counter_i1 + 1;
	end
end

// Step-6 (Part-2) of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_i2 < 257) begin
		if (a1[counter_i2] == 1'b1) begin
			i2_mul <= i2_mul ^ (b0 << counter_i2);
			counter_i2 <= counter_i2 + 1;
		end
			counter_i2 <= counter_i2 + 1;
	end
end

// Step-6 (Part-3) of 4-Way TCM Multiplier
always @(posedge clk) begin
	i <= i1_mul ^ i2_mul; 
end

// Step-7 of 4-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_j < 257) begin
		if (a0[counter_j] == 1'b1) begin
			j <= j ^ (b0 << counter_j);
			counter_j = counter_j + 1;
		end
			counter_j = counter_j + 1;
	end
end

// Step-8 of 4-Way TCM Multiplier
always @(posedge clk) begin
	temp = j;
	temp = temp ^ (i << 256);
	temp = temp ^ (h << 512);
	temp = temp ^ (g << 768);
	temp = temp ^ (f << 1024);
	temp = temp ^ (e << 1280);
	temp = temp ^ (d << 1536);
	c = temp;
end
endmodule