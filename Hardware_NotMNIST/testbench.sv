`timescale 1ns/1ns
`default_nettype none


module testbench #(
    parameter NODE_NUM_Lay2 = 64,
    parameter NODE_NUM_Lay4 = 32,
    parameter NODE_NUM_Lay6 = 16,
    parameter INPUT_NUM = 400,
    parameter IN_WIDTH = 12,
    parameter IN_FRACTION = 9,
    parameter W_WIDTH = 8,
    parameter W_FRACTION = 6,
    parameter W_WIDTH_last = 8,
    parameter W_FRACTION_last = 5,
    parameter OUTPUT_WIDTH_Lay2 = 8,
    parameter OUTPUT_FRACTION_Lay2 = 6,
    parameter OUTPUT_WIDTH_Lay4 = 8,
    parameter OUTPUT_FRACTION_Lay4 = 6,
    parameter OUTPUT_WIDTH_Lay6 = 8,
    parameter OUTPUT_FRACTION_Lay6 = 5,
    parameter OUTPUT_WIDTH = OUTPUT_WIDTH_Lay6,       // OUTPUT_WIDTH = OUTPUT_WIDTH_Lay6,
    parameter OUTPUT_FRACTION = OUTPUT_FRACTION_Lay6, // OUTPUT_FRACTION = OUTPUT_FRACTION_Lay6
    parameter OUT_NUM = NODE_NUM_Lay6                 // NODE_NUM = NODE_NUM_Lay6
) ();


reg clk = 0;
reg valid = 0;
reg [IN_WIDTH * INPUT_NUM - 1 : 0] x;

wire signed [OUTPUT_WIDTH - 1 : 0] out [0 : OUT_NUM - 1];
wire out_ready;

encoder #(
    NODE_NUM_Lay2,
    NODE_NUM_Lay4,
    NODE_NUM_Lay6,
    INPUT_NUM,
    IN_WIDTH,
    IN_FRACTION,
    W_WIDTH,
    W_FRACTION,
    W_WIDTH_last,
    W_FRACTION_last,
    OUTPUT_WIDTH_Lay2,
    OUTPUT_FRACTION_Lay2,
    OUTPUT_WIDTH_Lay4,
    OUTPUT_FRACTION_Lay4,
    OUTPUT_WIDTH_Lay6,
    OUTPUT_FRACTION_Lay6,
    OUTPUT_WIDTH,           // OUTPUT_WIDTH = OUTPUT_WIDTH_Lay6,
    OUTPUT_FRACTION,        // OUTPUT_FRACTION = OUTPUT_FRACTION_Lay6
    OUT_NUM                 // NODE_NUM = NODE_NUM_Lay6
) encoder_1 ( clk, valid, x, out, out_ready);


real Decimal_out;
reg signed [63 : 0] out_64bit = 64'b1;
integer               				data_in_file;   // file handler for reading input
integer               				data_out_file;  // file handler for writing output in out.txt
integer               				data_out_file2; // file handler for writing output in hex format

logic   signed [IN_WIDTH-1:0] 		captured_data_in;
localparam INPUT_LEN_DEPTH = $clog2(IN_WIDTH * INPUT_NUM);

reg [INPUT_LEN_DEPTH : 0] j;

// function for converting fixed point to Decimal
function real Fdp_to_decimal (signed [OUTPUT_WIDTH - 1 : 0] fp, int Fraction);
    real out;
    begin
        out = - fp[OUTPUT_WIDTH - 1];   // Add the sign bit
        for (int i = OUTPUT_WIDTH - 2; i >= 0; i--) begin
            out = (out * 2 + fp[i]);    // Add the remaining bits
        end
        out = out * 2.0**(-Fraction);   // Scale by the fractional factor
        return out;
    end
endfunction



initial begin

	//load input file
	data_in_file = $fopen("input.txt", "r");
    $display("file = %d", data_in_file);

    //initialize x
	for(int i=0; i < INPUT_NUM; i= i + 1) begin
        j = i * IN_WIDTH;
		$fscanf(data_in_file, "%h/n", captured_data_in); 

		x[j+:IN_WIDTH] = captured_data_in;
        $display("i = %d_ X = %h ", i, x[j+:IN_WIDTH]); ////////////////////
    end
end

always #10 clk = ~clk;

// write in file when out is ready
always @(out_ready) begin

    if (out_ready) begin
    data_out_file = $fopen("out.txt", "w");
    data_out_file2 = $fopen("out_encoder.txt", "w");
	for(int i=0; i < OUT_NUM; i= i + 1) begin
        Decimal_out = Fdp_to_decimal(out[i], OUTPUT_FRACTION);
		$fdisplay(data_out_file, "%f", Decimal_out); 
        $fdisplay(data_out_file2, "%h", out[i]);
    end
       
    end
end

always begin
    #25;
    valid = 1'b1;
    #20;
    valid = 1'b0;
    #200;
    $fclose(data_out_file2);
    $fclose(data_out_file);
    $stop;
end
endmodule
`default_nettype wire