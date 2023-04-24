module matrix_pe(
  input                 clk,
  input                 rst_n,
  input         [511:0] nram_mpe_neuron,
  input                 nram_mpe_neuron_valid,
  output                nram_mpe_neuron_ready,
  input         [511:0] wram_mpe_weight,
  input                 wram_mpe_weight_valid,
  output                wram_mpe_weight_ready,
  input         [  7:0] ib_ctl_uop,
  input                 ib_ctl_uop_valid,
  output reg            ib_ctl_uop_ready,
  output        [ 31:0] result,
  output                vld_o
);

reg inst_vld;
reg [7:0] inst;  /*inst存放输入控制信号ib_ctl_uop的值*/
always@(posedge clk or negedge rst_n) begin
  /* TODO: inst_vld & inst */
  if (!rst_n) begin
    inst_vld <= 0;
    inst <= 0;
  end else begin
    if (ib_ctl_uop_valid && !inst_vld) begin
      inst_vld <= 1;
      inst <= ib_ctl_uop;
    end 
    else if (ib_ctl_uop_ready) begin
      inst_vld <= 0;
      inst <= 0;
    end
  end
end

wire pe_vld_i = inst_vld && nram_mpe_neuron_valid && wram_mpe_weight_valid;
reg [7:0] iter;

always@(posedge clk or negedge rst_n) begin
  /* TODO: iter */
  if (!rst_n) begin
    iter <= 0;
  end 
  else if (pe_vld_i && pe_ctl[0] && pe_ctl[1]) begin
    iter <= iter + 1;
  end
end

always@(posedge clk or negedge rst_n) begin
  /* TODO: ib_ctl_uop_ready */
  if (!rst_n) begin
    ib_ctl_uop_ready <= 1'b0;
  end else begin
    if (ib_ctl_uop_valid && !inst_vld) begin
      ib_ctl_uop_ready <= 1'b1;
    end else if (ib_ctl_uop_ready && !ib_ctl_uop_valid) begin
      ib_ctl_uop_ready <= 1'b0;
    end
  end
end

wire [511:0] pe_neuron = nram_mpe_neuron;
wire [511:0] pe_weight = wram_mpe_weight;
wire [1:0] pe_ctl;
assign pe_ctl[0] = (iter == 0);  /* TODO */
assign pe_ctl[1] = (iter == 2);  /* TODO */

wire [31:0] pe_result;
wire pe_vld_o;
parallel_pe u_parallel_pe (
/* TODO */
  .clk(clk),
  .rst_n(rst_n),
  .neuron(pe_neuron),
  .weight(pe_weight),
  .ctl(pe_ctl),
  .result(pe_result),
  .vld_i(pe_vld_i),
  .vld_o(pe_vld_o)
);

assign nram_mpe_neuron_ready = (pe_ctl[0] || !nram_mpe_neuron_valid);  /* TODO */
assign wram_mpe_weight_ready = (pe_ctl[0] || !wram_mpe_weight_valid);  /* TODO */

assign result = pe_result;
assign vld_o = pe_vld_o;

endmodule
