// TalTech large integer multiplier library
// Multiplier type: sbm_digitized
// Parameters: 1024 1024 1
// Target tool: genus
module sbm_digitized(clk, rst, a, b, c);

// Declaration of parameters
parameter SIZEA = 1024;
parameter SIZEB = 1024;
parameter SIZEOF_DIGITS = 1024;
parameter DIGITS = 2;

// Declaration of module inputs and outputs
input clk;
input rst;
input [1023:0] a;
input [1023:0] b;
output reg [2047:0] c;

// Set local parameters for FSM controller
localparam ST_RUN = 0;
localparam ST_WAIT = 1;
localparam ST_OFFSET = 2;
localparam ST_RST = 3;

// Registers declaration 
reg local_rst;
reg digit_mul_start;
reg digit_mul_start_next;
reg  [1023:0] short_b;
reg  [1023:0] short_b_next;
reg counter_digits;
reg counter_digits_next;
reg  [1:0] state;
reg  [1:0] next_state;
reg  [2047:0] next_c;
reg  [1023:0] tmp;
reg  [510:0] upper_addr;
reg  [510:0] lower_addr;

// Wires declaration 
wire digit_mul_done;
wire  [2047:0] short_c;

// Multiplier Instance
mult_unit #(1024, 1024) mult_unit (clk, rst, local_rst, a, short_b, digit_mul_start, short_c, digit_mul_done);

// FSM-controller --< Sequential Part
always @(posedge clk) begin
	if (rst == 1'b1) begin
		state <= ST_RUN;
		c <= 2048'b0;
		counter_digits <= 1'b0;
		short_b <= 1024'b0;
		digit_mul_start <= 1'b0;
	end
	else begin
		state <= next_state;
		c <= next_c;
		counter_digits <= counter_digits_next;
		short_b <= short_b_next;
		digit_mul_start <= digit_mul_start_next;
	end
end

// FSM-controller --< Combinational Part
always @ (*) begin 
	next_state = state;
	next_c = c;
	digit_mul_start_next = digit_mul_start;
	local_rst = 0;
	counter_digits_next = counter_digits;
	short_b_next = short_b;
	tmp = tmp;
	case (state)
		ST_RUN: begin
			tmp[1023:0] = b[1023:0];
			lower_addr = counter_digits_next*(1024);
			short_b_next = tmp[lower_addr+:1024];
			if (counter_digits_next < 1) begin
				digit_mul_start_next = 1'b1;
				next_state = ST_WAIT;
			end
			else begin 
				next_state = ST_OFFSET;
			end
		end
		ST_WAIT: begin
			if (digit_mul_done == 1'b1) begin
				digit_mul_start_next = 1'b0;
				counter_digits_next = counter_digits_next +1;
				next_state = ST_OFFSET;
			end
			else begin 
				next_state = ST_WAIT;
			end
		end
		ST_OFFSET: begin
			next_c = next_c + (short_c << 1024 *(counter_digits_next-1));			next_state = ST_RST;
		end
		ST_RST: begin
			local_rst = 1'b1;
			next_state = ST_RUN;
		end
	endcase
end
endmodule

// multiplier inside the sbm_digitized
module mult_unit(clk, rst, local_rst, a, b, digit_mul_start, c, digit_mul_done);

// Declaration of parameters
parameter SHORTA = 1;
parameter SHORTB = 1;

// Declaration of module inputs and outputs
input clk;
input rst;
input local_rst;
input [1023:0] a;
input [1023:0] b;
input digit_mul_start;
output reg [2047:0] c;
output reg digit_mul_done;

// Registers declaration 
reg [11:0] count;

always @ (posedge clk) begin 
	if ((rst == 1'b1) || (local_rst == 1'b1)) begin
		c <= {SHORTA+SHORTB { 1'b0}};
		count <= 12'd0;
		digit_mul_done <= 1'b0;
	end
	else begin
		if (digit_mul_start == 1'b1) begin
			if (count < SHORTB) begin
				if (b[count] == 1) begin
					c <= c + (a << count);
				end
					count <= count + 12'd1;
			end
			else begin
				digit_mul_done <= 1'b1;
			end
		end
	end
end
endmodule
