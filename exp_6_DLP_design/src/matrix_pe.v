module matrix_pe (
    input   clk,
    input   rst_n,
    input   [511:0] nram_mpe_neuron,
    input   nram_mpe_neuron_valid,
    output  nram_mpe_neuron_ready,
    input   [511:0] wram_mpe_weight,
    input   wram_mpe_weight_valid,
    output  wram_mpe_weight_ready,
    input   [7:0]   ib_ctl_uop,
    input   ib_ctl_uop_valid,
    output reg  ib_ctl_uop_ready,
    output  [31:0]  result,
    output reg  vld_o
);

reg inst_vld;
reg [7:0] inst, iter;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        inst_vld <= 0;
        inst <= 0;
    end else begin
        inst_vld <= ib_ctl_uop_valid;
        inst <= ib_ctl_uop;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        iter <= 0;
    end else if (pe_ctl[1] && pe_vld_i) begin
        iter <= iter + 1;
    end
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ib_ctl_uop_ready <= 1'b0;
    end else if (pe_ctl[0] && pe_ctl[1] && pe_vld_i) begin
        ib_ctl_uop_ready <= 1'b1;
    end
end

wire [1:0] pe_ctl;
assign pe_ctl[0] = (nram_mpe_neuron_valid && wram_mpe_weight_valid);
assign pe_ctl[1] = pe_vld_i;
wire pe_vld_i = pe_ctl[0] && !vld_o;

wire [31:0] pe_result;
wire pe_vld_o;
parallel_pe u_parallel_pe (
    .pe_ctl(pe_ctl),
    .nram_mpe_neuron(nram_mpe_neuron),
    .wram_mpe_weight(wram_mpe_weight),
    .pe_vld_i(pe_vld_i),
    .pe_result(pe_result),
    .pe_vld_o(pe_vld_o)
);

assign nram_mpe_neuron_ready = !pe_ctl[0] || (pe_ctl[0] && pe_vld_i);
assign wram_mpe_weight_ready = !pe_ctl[0] || (pe_ctl[0] && pe_vld_i);
assign result = pe_result;
assign vld_o = pe_vld_o;

endmodule