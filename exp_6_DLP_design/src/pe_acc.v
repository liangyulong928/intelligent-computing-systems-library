module pe_acc (
    input   [1023:0]    mult_result,
    output  [31:0]  acc_result
);
genvar  i;
genvar  j;

wire [31:0] int16_result[31:0][5:0];

for(i=0;i<=5;i=i+1)
begin : int16_add_tree
    for (j=0;j<32/(2**i);j=j+1) 
    begin : int16_adder
        if (i==0) begin
            assign int16_result[0][j] = mult_result[j*2+1] + mult_result[j*2];
        end else begin
            assign int16_result[i][j] = int16_result[i-1][j*2+1] + int16_result[i-1][j*2];
        end
    end
end

assign acc_result = int16_result[5][0];

endmodule