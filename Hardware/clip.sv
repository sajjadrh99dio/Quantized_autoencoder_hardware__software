`timescale 1ns/1ns
`default_nettype none

/*WIDTH of input integer part >  WIDTH of output integer part
WIDTH of input Fraction part >=  WIDTH of output Fraction part*/

module clip #(
    parameter Input_WIDTH = 16,
    parameter Input_FRACTION = 12,
    parameter Output_WIDTH = 12,
    parameter Output_FRACTION = 10
)
(
    input wire clk,
    input wire valid,
    input wire [Input_WIDTH - 1 : 0] x,

    output reg signed [Output_WIDTH - 1 : 0] out,
    output reg out_ready
);

reg [Output_WIDTH - 1 : 0] max = {1'b0, {(Output_WIDTH - 1){1'b1}}};
reg [Output_WIDTH - 1 : 0] min = {1'b1, {(Output_WIDTH - 1){1'b0}}};

reg [Output_WIDTH + (Input_FRACTION - Output_FRACTION) - 1 : 0] aligned_min = min << (Input_FRACTION - Output_FRACTION);
reg [Output_WIDTH + (Input_FRACTION - Output_FRACTION) - 1 : 0] aligned_max = max << (Input_FRACTION - Output_FRACTION);

always @(posedge clk) 
begin
    
    out_ready <= 1'b0;

    if (valid) begin
        if ($signed(x) >= $signed(aligned_max)) begin
            out <= max;
        end
        else if ($signed(x) <= $signed(aligned_min)) begin
            out <= min;
        end
        else begin
            out <= {x[$high(x)],x[Input_FRACTION - Output_FRACTION +: Output_WIDTH - 1]};
        end
        out_ready <= 1'b1;
    end
end
endmodule
`default_nettype wire
