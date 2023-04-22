`timescale 1ns / 100ps

module tb_top ();

    reg clk;
    reg rst_n;
    reg [15:0]serial_neuron;
    reg [15:0]serial_weight;
    reg [1:0] serial_ctl;
    reg serial_vld_i;
    wire serial_vld_o;
    wire [31:0] serial_result;
    reg [31:0] serial_produce[0:9];
    integer serial_produce_cnt;
    reg serial_right;

    integer element_cnt;
    serial_pe u_serial_pe(
        .clk(clk),
        .rst_n(rst_n),
        .neuron(serial_neuron),
        .weight(serial_weight),
        .ctl(serial_ctl),
        .vld_i(serial_vld_i),
        .result(serial_result),
        .vld_o(serial_vld_o)
    );

    always #5 clk <= ~clk;
    integer i,j;
    reg [15:0]  neuron  [0:8191];
    reg [15:0]  weight  [0:8181];
    reg [31:0]  inst   [0:9];
    reg signed [31:0] result[0:9];

    initial begin
        $readmemb("/Users/yulong/Documents/intelligent-computing-systems-library/exp_6_DLP_design/data/scale.txt",inst);
        $readmemh("/Users/yulong/Documents/intelligent-computing-systems-library/exp_6_DLP_design/data/neuron.txt",neuron);
        $readmemh("/Users/yulong/Documents/intelligent-computing-systems-library/exp_6_DLP_design/data/weight.txt",weight);
        $readmemh("/Users/yulong/Documents/intelligent-computing-systems-library/exp_6_DLP_design/data/result.txt",result);
        serial_produce_cnt = 0;
        serial_right = 1;
        element_cnt = 0;
        clk = 0;
        rst_n = 0;
        serial_ctl = 0;
        #100;
        rst_n = 1;
        #100;

        for(i = 0; i < 10; i = i + 1)
        begin
            for(j = 0; j < inst[i]; j = j + 1)
            begin
                serial_vld_i = 1;
                serial_neuron = neuron[element_cnt];
                serial_weight = weight[element_cnt];
                if(j == 0 && inst[i] == 1) serial_ctl = 2'b11;
                else if(j == 0) serial_ctl = 2'b01;
                else if(j == inst[i] - 1) serial_ctl = 2'b10;
                else serial_ctl = 2'b00;
                #10;
                serial_vld_i = 0;
                #10;
                element_cnt = element_cnt + 1;
            end
        end

        while(serial_produce_cnt < 10 | serial_produce_cnt < 10)
        begin
            #100;
        end
        
        for(i = 0; i < 10; i = i + 1)
        begin
            if(serial_produce[i] != result[i])
            begin
                serial_right = 0;
                i = 10;
            end
            else serial_right = 1;
        end

        if(serial_right == 1)$display("Module serial test passed!\n");
        else $display("Module serial test failed!\n"); 
        $finish;
    end

    initial begin
        $dumpfile("waves.vcd");  // Write waveforms to waves.vcd file
        $dumpvars(0, tb_top); // Dump all signals in testbench module
    end

    always @ (posedge clk)
    begin
        if(serial_vld_o)
        begin
            serial_produce_cnt <= serial_produce_cnt + 1;
            serial_produce[serial_produce_cnt] <= serial_result;
        end
    end
endmodule
