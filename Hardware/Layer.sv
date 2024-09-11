`timescale 1ns/1ns
`default_nettype none

module Layer #(
    parameter LAYERID=1,
    parameter NODE_NUM = 16,        //Number of Nodes in Layer
    parameter INPUT_NUM = 2,        //Number of Inputs of a Node
    parameter IN_WIDTH = 16,        //Input width
    parameter IN_FRACTION = 14,     //Input Fraction
    parameter W_WIDTH = 8,          //Weight width
    parameter W_FRACTION = 7,       //Weight Fraction
    parameter OUTPUT_WIDTH = 16,    
    parameter OUTPUT_FRACTION = 14
) (
    input wire clk,
    input wire valid,
    input wire [IN_WIDTH * INPUT_NUM - 1 : 0] x,

    output reg signed [OUTPUT_WIDTH - 1 : 0] out [0 : NODE_NUM - 1],
    output reg out_ready
);

// determine width of output and fraction part based on Number of inputs, IN_WIDTH and W_WIDTH
// Add one to the input number before taking the base-2 logarithm to account for the bias
localparam OUT_NODE_WIDTH = IN_WIDTH + W_WIDTH + $clog2(INPUT_NUM + 1);
localparam OUT_NODE_FRACTION = IN_FRACTION + W_FRACTION;

reg signed [OUT_NODE_WIDTH - 1 : 0] OUT_NODES [0 : NODE_NUM-1];
reg signed [OUT_NODE_WIDTH - 1 : 0] OUT_ReLu [0 : NODE_NUM-1];


//ready_out signal indicates that the current module has valid data to send to the next module
wire OutNodeValid [0 : NODE_NUM-1];
wire OutReLuValid [0 : NODE_NUM-1];
wire OutClipValid [0 : NODE_NUM-1];

reg temp;
integer j;

// final out_ready is &OutClipValid
always @(*) begin
temp = 1;
for (j = 0; j < NODE_NUM; j = j + 1) begin
temp = temp & OutClipValid[j];
end
out_ready = temp;
end


genvar i;

generate for (i = 0 ; i < NODE_NUM; i++) begin

    node #(
        .LAYERID(LAYERID),
        .WIDTH(IN_WIDTH),
        .FRACTION(IN_FRACTION),
        .W_WIDTH(W_WIDTH),
        .INPUT_NUM(INPUT_NUM),
        .OUTPUT_WIDTH(OUT_NODE_WIDTH), // W_WIDTH + Input_WIDTH + $clog2 (Num_INPUT+1)
        .NODEID(i+1)) 
    node_i ( .clk(clk), .in_ready(valid), .x(x), .out(OUT_NODES[i]), .out_ready(OutNodeValid[i]));

    ReLu #(
        .Input_WIDTH(OUT_NODE_WIDTH),
        .FRACTION(OUT_NODE_FRACTION)) 
    ReLu_i ( .clk(clk), .valid(OutNodeValid[i]), .x(OUT_NODES[i]), .out(OUT_ReLu[i]), .out_ready(OutReLuValid[i]));

    clip #(
        .Input_WIDTH(OUT_NODE_WIDTH),
        .Input_FRACTION(OUT_NODE_FRACTION),
        .Output_WIDTH(OUTPUT_WIDTH),
        .Output_FRACTION(OUTPUT_FRACTION))
    clip_i ( .clk(clk), .valid(OutReLuValid[i]), .x(OUT_ReLu[i]), .out(out[i]), .out_ready(OutClipValid[i]));


end 
endgenerate

endmodule
`default_nettype wire
