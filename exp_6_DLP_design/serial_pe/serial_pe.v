`timescale 1ns / 100ps

module serial_pe (
    input   clk,
    input   rst_n,
    input   signed [15:0] neuron,
    input   signed [15:0] weight,
    input   [1:0]   ctl,
    input   vld_i,
    output  reg [31:0]  result,
    output  reg vld_o
);

wire signed [31:0] mult_res = neuron * weight;
reg [31:0] psum_r;

wire [31:0] psum_d = psum_r + mult_res;

always@(posedge clk or negedge rst_n)
if (! rst_n ) begin
    psum_r <= 32'h0;
    result <= psum_r;
end else if(vld_i) begin
    psum_r <= psum_d;
    result <= psum_r;
end

always@(posedge clk or negedge rst_n)
if (! rst_n ) begin
    vld_o <= 1'b0;
end else if(vld_i && (ctl == 2'b11)) begin
    vld_o <= 1'b1;
end else begin
    vld_o <= 1'b0;
end

endmodule
