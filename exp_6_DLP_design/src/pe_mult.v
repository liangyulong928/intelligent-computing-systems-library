module pe_mult (
    input   [511:0] mult_neuron,
    input   [511:0] mult_weight,
    output  [1023:0]    mult_result
);
    
genvar i;

wire signed [15:0] int16_neuron[31:0];
wire signed [15:0] int16_weight[31:0];
wire signed [31:0] int16_mult_result[31:0];

generate
    for (i = 0; i<32; i=i+1) 
    begin : int16_mult
        wire signed [31:0] int32_mult_result;
        wire signed [47:0] int48_mult_result;

        assign int16_neuron[i] = mult_neuron[i*16 +: 16];
        assign int16_weight[i] = mult_weight[i*16 +: 16];

        assign int32_mult_result = int16_neuron[i] * int16_weight[i];

        assign int48_mult_result = {16'b0, int32_mult_result} << i;

        assign int16_mult_result[i] = int48_mult_result[47 -: 16];
        assign int16_mult_result[i+1] = int48_mult_result[31 -: 16];
    end
endgenerate

assign mult_result = {int16_mult_result};

endmodule