// TalTech large multiplier library
// Multiplier type: sbm_digitized
// Parameters: 6088 6088 1
// Target tool: genus
module sbm_digitized(clk, rst, a, b, c);

// Declaration of parameters
parameter SIZEA = 6088;
parameter SIZEB = 6088;
parameter SIZEOF_DIGITS = 4;
parameter DIGITS = 1522;

// Declaration of module inputs and outputs
input clk;
input rst;
input [6087:0] a;
input [6087:0] b;
output reg [12175:0] c;

// Set local parameters for FSM controller
localparam ST_RUN = 0;
localparam ST_WAIT = 1;
localparam ST_OFFSET = 2;
localparam ST_RST = 3;

// Registers declaration 
reg local_rst;
reg mul_start;
reg  [3:0] short_b;
reg  [1521:0] counter_digits;
reg  [1521:0] next_counter_digits;
reg  [1:0] state;
reg  [1:0] next_state;
reg  [12175:0] next_c;
reg  [6087:0] tmp;
reg  [3042:0] upper_addr;
reg  [3042:0] lower_addr;

// Wires declaration 
wire ready;
wire mul_done_tmp;
wire  [6091:0] short_c;

// Multiplier Instance
mult_unit #(6088, 4) mult_unit (clk, rst, local_rst, a, short_b, mul_start, short_c, mul_done_tmp, ready);

// FSM-controller --< Sequential Part
always @(posedge clk) begin
	if (rst == 1'b1) begin
		state <= ST_RUN;
		c <= 12176'b0;
		counter_digits <= 1522'b0;
	end
	else begin
		state <= next_state;
		c <= next_c;
		counter_digits <= next_counter_digits;
	end
end

// FSM-controller --< Combinational Part
always @ (*) begin 
	next_state = state;
	next_c = c;
	local_rst = 0;
	next_counter_digits = counter_digits;
	short_b = short_b;
	tmp = tmp;
	case (state)
		ST_RUN: begin
			tmp[6087:0] = b[6087:0];
			lower_addr = next_counter_digits*(4);
			short_b = tmp[lower_addr+:4];
			if (next_counter_digits < 1522) begin
				mul_start = 1'b1;
				next_state = ST_WAIT;
			end
			else begin 
				next_state = ST_OFFSET;
			end
		end
		ST_WAIT: begin
			if (mul_done_tmp == 1'b1) begin
				mul_start = 1'b0;
				next_counter_digits = next_counter_digits +1;
				next_state = ST_OFFSET;
			end
			else begin 
				next_state = ST_WAIT;
			end
		end
		ST_OFFSET: begin
			next_c = next_c + (short_c << 4 *(next_counter_digits-1));
			next_state = ST_RST;
		end
		ST_RST: begin
			local_rst = 1'b1;
			next_state = ST_RUN;
		end
	endcase
end
endmodule

// multiplier inside the sbm_digitized
module mult_unit(clk, rst, local_rst, a, b, mul_start, c, mul_done, ready);

// Declaration of parameters
parameter SHORTA = 1;
parameter SHORTB = 1;

// Declaration of module inputs and outputs
input clk;
input rst;
input local_rst;
input [6087:0] a;
input [3:0] b;
input mul_start;
output reg [6091:0] c;
output reg mul_done;
output reg ready;

// Registers declaration 
reg [11:0] count;

always @ (posedge clk) begin 
	if ((rst == 1'b1) || (local_rst == 1'b1)) begin
		c <= {SHORTA+SHORTB { 1'b0}};
		count <= 12'd0;
		ready <= 1'b0;
		mul_done <= 1'b0;
	end
	else begin
		if (mul_start == 1'b1) begin
			if (count < SHORTB) begin
				if (b[count] == 1) begin
					c <= c + (a << count);
				end
					count <= count + 12'd1;
			end
			else begin
				mul_done <= 1'b1;
			end
		end
	end
end
endmodule
