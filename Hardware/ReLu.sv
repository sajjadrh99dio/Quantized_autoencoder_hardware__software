`timescale 1ns/1ns
`default_nettype none

module ReLu #(
    parameter Input_WIDTH = 16,
    parameter FRACTION = 14
)
(
    input wire clk,
    input wire valid,
    input wire [Input_WIDTH - 1 : 0] x,

    output reg signed [Input_WIDTH - 1 : 0] out,
    output reg out_ready
);


always @(posedge clk) 
begin
    
    out_ready <= 1'b0;

    // based on sign bit of x
    if (valid) begin
        if (x[$high(x)]) begin
            out <= 'b0;
        end
        else begin
            out <= x;
        end
        out_ready <= 1'b1;
    end
end
endmodule
`default_nettype wire
