// TalTech large integer multiplier library
// Multiplier type: sbm_digitized
// Parameters: 1024 1024 3
// Target tool: genus
module sbm_digitized(clk, rst, a, b, c);

// Declaration of parameters
parameter SIZEA = 1024;
parameter SIZEB = 1024;
parameter SIZEOF_DIGITS = 8;
parameter DIGITS = 129;

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
reg  [7:0] short_b;
reg  [7:0] short_b_next;
reg  [127:0] counter_digits;
reg  [127:0] counter_digits_next;
reg  [1:0] state;
reg  [1:0] next_state;
reg  [2047:0] next_c;
reg  [1023:0] tmp;
reg  [510:0] upper_addr;
reg  [510:0] lower_addr;

// Wires declaration 
wire digit_mul_done;
wire  [1031:0] short_c;

// Multiplier Instance
mult_unit #(1024, 8) mult_unit (clk, rst, local_rst, a, short_b, digit_mul_start, short_c, digit_mul_done);

// FSM-controller --< Sequential Part
always @(posedge clk) begin
end

// FSM-controller --< Combinational Part
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
input [7:0] b;
input digit_mul_start;
output reg [1031:0] c;
output reg digit_mul_done;

// Registers declaration 
reg [11:0] count;

endmodule
