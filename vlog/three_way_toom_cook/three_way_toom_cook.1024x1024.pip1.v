// TalTech large multiplier library
// Multiplier type: three_way_toom_cook
// Parameters: 1024 1024 1
// Target tool: genus
module three_way_toom_cook(clk, rst, a, b, c);
input clk;
input rst;
input [1023:0] a;
input [1023:0] b;
output reg [2047:0] c;

// Wires declaration 
wire  [340:0] a0;
wire  [340:0] a1;
wire  [340:0] a2;
wire  [340:0] b0;
wire  [340:0] b1;
wire  [340:0] b2;

// Registers declaration 
reg  [340:0] counter_d;
reg  [340:0] counter_e1;
reg  [340:0] counter_e2;
reg  [340:0] counter_f1;
reg  [340:0] counter_f2;
reg  [340:0] counter_f3;
reg  [340:0] counter_g1;
reg  [340:0] counter_g2;
reg  [340:0] counter_h;
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
reg  [1023:0] g;
reg  [1023:0] h;
reg  [2047:0] temp;

// Initial assignments to wires
assign a0 = a[340:0];
assign a1 = a[681:341];
assign a2 = a[1022:682];
assign b0 = b[340:0];
assign b1 = b[681:341];
assign b2 = b[1022:682];

// Step-1 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 2048'd0;
		counter_d <= 341'd0;
		counter_e1 <= 341'd0;
		counter_e2 <= 341'd0;
		counter_f1 <= 341'd0;
		counter_f2 <= 341'd0;
		counter_f3 <= 341'd0;
		counter_g1 <= 341'd0;
		counter_g2 <= 341'd0;
		counter_h <= 341'd0;
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
		g <= 1024'd0;
		h <= 1024'd0;
		temp <= 2048'd0;
	end
	else begin
		if (counter_d < 342) begin
			if (a2[counter_d] == 1'b1) begin
				d <= d ^ (b2 << counter_d);
				counter_d <= counter_d + 1;
			end
				counter_d <= counter_d + 1;
		end
	end
end

// Step-2 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_e1 < 342) begin
		if (a1[counter_e1] == 1'b1) begin
			e1_mul <= e1_mul ^ (b2 << counter_e1);
			counter_e1 <= counter_e1 + 1;
		end
			counter_e1 <= counter_e1 + 1;
	end
end

// Step-2 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_e2 < 342) begin
		if (a2[counter_e1] == 1'b1) begin
			e2_mul <= e2_mul ^ (b1 << counter_e2);
			counter_e2 <= counter_e2 + 1;
		end
			counter_e2 <= counter_e2 + 1;
	end
end

// Step-2 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
	e = e1_mul ^ e2_mul; 
end

// Step-3 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_f1 < 342) begin
		if (a0[counter_f1] == 1'b1) begin
			f1_mul = f1_mul ^ (b2 << counter_f1);
			counter_f1 = counter_f1 + 1;
		end
			counter_f1 = counter_f1 + 1;
	end
end

// Step-3 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_f2 < 342) begin
		if (a1[counter_f2] == 1'b1) begin
			f2_mul = f2_mul ^ (b1 << counter_f2);
			counter_f2 = counter_f2 + 1;
		end
			counter_f2 = counter_f2 + 1;
	end
end

// Step-3 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_f3 < 342) begin
		if (a2[counter_f3] == 1'b1) begin
			f3_mul = f3_mul ^ (b0 << counter_f3);
			counter_f3 = counter_f3 + 1;
		end
			counter_f3 = counter_f3 + 1;
	end
end

// Step-3 (Part-4) of 3-Way TCM Multiplier
always @(posedge clk) begin
	f = f1_mul ^ f2_mul ^ f3_mul; 
end

// Step-4 (Part-1) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_g1 < 342) begin
		if (a0[counter_g1] == 1'b1) begin
			g1_mul = g1_mul ^ (b1 << counter_g1);
			counter_g1 = counter_g1 + 1;
		end
			counter_g1 = counter_g1 + 1;
	end
end

// Step-4 (Part-2) of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_g2 < 342) begin
		if (a1[counter_g2] == 1'b1) begin
			g2_mul = g2_mul ^ (b0 << counter_g2);
			counter_g2 = counter_g2 + 1;
		end
			counter_g2 = counter_g2 + 1;
	end
end

// Step-4 (Part-3) of 3-Way TCM Multiplier
always @(posedge clk) begin
	g = g1_mul ^ g2_mul; 
end

// Step-5 of 3-Way TCM Multiplier
always @(posedge clk) begin
	if (counter_h < 342) begin
		if (a0[counter_h] == 1'b1) begin
			h = h ^ (b0 << counter_h);
			counter_h = counter_h + 1;
		end
			counter_h = counter_h + 1;
	end
end

// Step-6 of 3-Way TCM Multiplier
always @(posedge clk) begin
	temp = h;
	temp = temp ^ (g << 341);
	temp = temp ^ (f << 682);
	temp = temp ^ (e << 1023);
	temp = temp ^ (d << 1364);
	c = temp;
end
endmodule
