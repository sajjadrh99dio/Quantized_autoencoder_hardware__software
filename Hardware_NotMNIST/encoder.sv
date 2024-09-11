`timescale 1ns/1ns
`default_nettype none

module encoder #(
    parameter NODE_NUM_Lay2 = 64,
    parameter NODE_NUM_Lay4 = 32,
    parameter NODE_NUM_Lay6 = 16,
    parameter INPUT_NUM = 400,
    parameter IN_WIDTH = 12,
    parameter IN_FRACTION = 9,
    parameter W_WIDTH = 8,
    parameter W_FRACTION = 6,
    parameter W_WIDTH_last = 8,
    parameter W_FRACTION_last = 6,
    parameter OUTPUT_WIDTH_Lay2 = 8,
    parameter OUTPUT_FRACTION_Lay2 = 6,
    parameter OUTPUT_WIDTH_Lay4 = 8,
    parameter OUTPUT_FRACTION_Lay4 = 6,
    parameter OUTPUT_WIDTH_Lay6 = 8,
    parameter OUTPUT_FRACTION_Lay6 = 5,
    parameter OUTPUT_WIDTH = OUTPUT_WIDTH_Lay6,       // OUTPUT_WIDTH = OUTPUT_WIDTH_Lay6,
    parameter OUTPUT_FRACTION = OUTPUT_FRACTION_Lay6, // OUTPUT_FRACTION = OUTPUT_FRACTION_Lay6
    parameter OUT_NUM = NODE_NUM_Lay6                 // OUT_NUM = NODE_NUM_Lay6
) (
    input wire clk,
    input wire valid,
    input wire [IN_WIDTH * INPUT_NUM - 1 : 0] x,

    output reg signed [OUTPUT_WIDTH - 1 : 0] out [0 : OUT_NUM - 1],
    output reg out_ready
);


wire signed [OUTPUT_WIDTH_Lay2 - 1 : 0] OUT_Layer2 [0 : NODE_NUM_Lay2 -1];
wire signed [OUTPUT_WIDTH_Lay4 - 1 : 0] OUT_Layer4 [0 : NODE_NUM_Lay4 -1];

reg signed [OUTPUT_WIDTH_Lay2 * NODE_NUM_Lay2 - 1 : 0] IN_Layer4;
reg signed [OUTPUT_WIDTH_Lay4 * NODE_NUM_Lay4 - 1 : 0] IN_Layer6;

//converting 2D array of Layer output to 1D array for next Layer Input
always @(*) begin

    for (int i=0; i<NODE_NUM_Lay2; i++) begin
        IN_Layer4 [(i*OUTPUT_WIDTH_Lay2)+:OUTPUT_WIDTH_Lay2] = OUT_Layer2[i];
    end

end

always @(*) begin

    for (int j=0; j<NODE_NUM_Lay4; j++) begin
        IN_Layer6 [(j*OUTPUT_WIDTH_Lay4)+:OUTPUT_WIDTH_Lay4] = OUT_Layer4[j];
    end

end

wire lay2_out_ready;
wire lay4_out_ready;


Layer #(
    .LAYERID(2),
    .NODE_NUM(NODE_NUM_Lay2),
    .INPUT_NUM(INPUT_NUM),
    .IN_WIDTH(IN_WIDTH),
    .IN_FRACTION(IN_FRACTION),
    .W_WIDTH(W_WIDTH),
    .W_FRACTION(W_FRACTION),
    .OUTPUT_WIDTH(OUTPUT_WIDTH_Lay2),
    .OUTPUT_FRACTION(OUTPUT_FRACTION_Lay2)) 
Layer_2(
    .clk(clk),
    .valid(valid),
    .x(x),
    .out(OUT_Layer2),
    .out_ready(lay2_out_ready)
);

Layer #(
    .LAYERID(4),
    .NODE_NUM(NODE_NUM_Lay4),
    .INPUT_NUM(NODE_NUM_Lay2),
    .IN_WIDTH(OUTPUT_WIDTH_Lay2),
    .IN_FRACTION(OUTPUT_FRACTION_Lay2),
    .W_WIDTH(W_WIDTH),
    .W_FRACTION(W_FRACTION),
    .OUTPUT_WIDTH(OUTPUT_WIDTH_Lay4),
    .OUTPUT_FRACTION(OUTPUT_FRACTION_Lay4)) 
Layer_4(
    .clk(clk),
    .valid(lay2_out_ready),
    .x(IN_Layer4),
    .out(OUT_Layer4),
    .out_ready(lay4_out_ready)
);


Layer #(
    .LAYERID(6),
    .NODE_NUM(NODE_NUM_Lay6),
    .INPUT_NUM(NODE_NUM_Lay4),
    .IN_WIDTH(OUTPUT_WIDTH_Lay4),
    .IN_FRACTION(OUTPUT_FRACTION_Lay4),
    .W_WIDTH(W_WIDTH_last),
    .W_FRACTION(W_FRACTION_last),
    .OUTPUT_WIDTH(OUTPUT_WIDTH_Lay6),
    .OUTPUT_FRACTION(OUTPUT_FRACTION_Lay6)) 
Layer_6(
    .clk(clk),
    .valid(lay4_out_ready),
    .x(IN_Layer6),
    .out(out),
    .out_ready(out_ready)
);



endmodule
`default_nettype wire
