// TalTech large multiplier library
// Multiplier type: three_way_toom_cook
// Parameters: 192 192 1
// Target tool: genus
module three_way_toom_cook(clk, rst, a, b, c);
input clk;
input rst;
input [191:0] a;
input [191:0] b;
output reg [383:0] c;

// Wires declaration 
wire  [63:0] a0;
wire  [64:0] a1;
wire  [64:0] a2;
wire  [63:0] b0;
wire  [64:0] b1;
wire  [64:0] b2;

// Registers declaration 
reg  [63:0] counter_d;
reg  [63:0] counter_e1;
reg  [63:0] counter_e2;
reg  [63:0] counter_f1;
reg  [63:0] counter_f2;
reg  [63:0] counter_f3;
reg  [63:0] counter_g1;
reg  [63:0] counter_g2;
reg  [63:0] counter_h;
reg  [191:0] d;
reg  [191:0] e1_mul;
reg  [191:0] e2_mul;
reg  [191:0] e;
reg  [191:0] f1_mul;
reg  [191:0] f2_mul;
reg  [191:0] f3_mul;
reg  [191:0] f;
reg  [191:0] g1_mul;
reg  [191:0] g2_mul;
reg  [191:0] g;
reg  [191:0] h;
reg  [383:0] temp;

// Initial assignments to wires
assign a0 = a[63:0];
assign a1 = a[127:64];
assign a2 = a[191:128];
assign b0 = b[63:0];
assign b1 = b[127:64];
assign b2 = b[191:128];

// Step-1 of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			d <= 192'd0;
			counter_d <= 64'd0;
		end
		else if (counter_d < 65) begin
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
			e1_mul <= 192'd0;
			counter_e1 <= 64'd0;
		end
	else if (counter_e1 < 65) begin
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
			e2_mul <= 192'd0;
			counter_e2 <= 64'd0;
		end
	else if (counter_e2 < 65) begin
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
			e = 192'd0;
		end
		else begin
			e = e1_mul ^ e2_mul; 
		end
end

// Step-3 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			f1_mul = 192'd0;
			counter_f1 = 64'd0;
		end
		else if (counter_f1 < 65) begin
		if (a0[counter_f1] == 1'b1) begin
			f1_mul = f1_mul ^ (b2 << counter_f1);
			counter_f1 = counter_f1 + 1;
		end
			counter_f1 = counter_f1 + 1;
	end
end

// Step-3 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			f2_mul = 192'd0;
			counter_f2 = 64'd0;
		end
	if (counter_f2 < 65) begin
		if (a1[counter_f2] == 1'b1) begin
			f2_mul = f2_mul ^ (b1 << counter_f2);
			counter_f2 = counter_f2 + 1;
		end
			counter_f2 = counter_f2 + 1;
	end
end

// Step-3 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			f3_mul = 192'd0;
			counter_f3 = 64'd0;
		end
		else if (counter_f3 < 65) begin
		if (a2[counter_f3] == 1'b1) begin
			f3_mul = f3_mul ^ (b0 << counter_f3);
			counter_f3 = counter_f3 + 1;
		end
			counter_f3 = counter_f3 + 1;
	end
end

// Step-3 (Part-4) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			f = 192'd0;
		end
		else begin
			f = f1_mul ^ f2_mul ^ f3_mul; 
		end
end

// Step-4 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			g1_mul = 192'd0;
			counter_g1 = 64'd0;
		end
		else if (counter_g1 < 65) begin
		if (a0[counter_g1] == 1'b1) begin
			g1_mul = g1_mul ^ (b1 << counter_g1);
			counter_g1 = counter_g1 + 1;
		end
			counter_g1 = counter_g1 + 1;
	end
end

// Step-4 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			g2_mul = 192'd0;
			counter_g2 = 64'd0;
		end
	else if (counter_g2 < 65) begin
		if (a1[counter_g2] == 1'b1) begin
			g2_mul = g2_mul ^ (b0 << counter_g2);
			counter_g2 = counter_g2 + 1;
		end
			counter_g2 = counter_g2 + 1;
	end
end

// Step-4 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			g = 192'd0;
		end
		else begin
			g = g1_mul ^ g2_mul; 
		end
end

// Step-5 of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			h = 192'd0;
			counter_h = 64'd0;
		end
		else if (counter_h < 65) begin
		if (a0[counter_h] == 1'b1) begin
			h = h ^ (b0 << counter_h);
			counter_h = counter_h + 1;
		end
			counter_h = counter_h + 1;
	end
end

// Step-6 of 3-Way TCM Multiplier
always @(posedge clk) begin
		if (rst) begin
			temp = 384'd0;
			c = 384'd0;
		end
		else begin
			temp = h;
			temp = temp ^ (g << 64);
			temp = temp ^ (f << 128);
			temp = temp ^ (e << 192);
			temp = temp ^ (d << 256);
			c = temp;
		end
end
endmodule
