module pe_mult(
  input  [ 511:0] mult_neuron,
  input  [ 511:0] mult_weight,
  output [1023:0] mult_result
);

// *******************************************************************
/*int16  乘法器*/
// *******************************************************************
genvar i;
wire signed [15:0] int16_neuron[31:0];
wire signed [15:0] int16_weight[31:0];
wire signed [31:0] int16_mult_result[31:0];

generate
  for(i=0; i<32; i=i+1)
  begin:int16_mult                 /* TODO */
    assign int16_neuron[i] = mult_neuron[(i*16+15):(i*16)];
    assign int16_weight[i] = mult_weight[(i*16+15):(i*16)];
    assign int16_mult_result[i] = int16_neuron[i] * int16_weight[i];
  end

  assign mult_result = {int16_mult_result[31],int16_mult_result[30],int16_mult_result[29],int16_mult_result[28],int16_mult_result[27],int16_mult_result[26],int16_mult_result[25],int16_mult_result[24],int16_mult_result[23],int16_mult_result[22],int16_mult_result[21],int16_mult_result[20],int16_mult_result[19],int16_mult_result[18],int16_mult_result[17],int16_mult_result[16],int16_mult_result[15],int16_mult_result[14],int16_mult_result[13],int16_mult_result[12],int16_mult_result[11],int16_mult_result[10],int16_mult_result[9],int16_mult_result[8],int16_mult_result[7],int16_mult_result[6],int16_mult_result[5],int16_mult_result[4],int16_mult_result[3],int16_mult_result[2],int16_mult_result[1],int16_mult_result[0]};

endgenerate

endmodule
