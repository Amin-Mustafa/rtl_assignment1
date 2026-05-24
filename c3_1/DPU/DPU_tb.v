`timescale 1ns/1ps

module DPU_tb();

    reg clk, reset;
    reg[15:0] din;
    reg[1:0]  dsel;
    reg[1:7]  seg_expected;
    reg[7:0]  dout_expected;
    reg[31:0] vector_num, errors;
    reg[32:0] test_vectors[0:10000];

    wire[1:7] seg_real;
    wire[7:0] dout_real;

    //instantiate
    DPU dut(.din(din), .dsel(dsel), .seg(seg_real), .dout(dout_real));

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, DPU_tb);
    end

    initial begin
        $readmemb("test_vectors.tv", test_vectors);
        vector_num = 0;
        errors = 0;
        reset = 1; #27; reset = 0;
    end

    always begin
        clk = 1; #5; clk = 0; #5;
    end

    always @(posedge clk) begin
        #1;
        {din, dsel, seg_expected, dout_expected} = test_vectors[vector_num];
    end

    always @(negedge clk) begin
        if(~reset) begin
            if((seg_real !== seg_expected) || (dout_real != dout_expected)) begin
                $display("Error: inputs = %b %b, outputs = %b %b (%b %b expected)\n",
                         din, dsel, seg_real, dout_real, seg_expected, dout_expected);
                errors = errors + 1;
            end
            vector_num = vector_num + 1;
            if(test_vectors[vector_num] === 33'bx) begin
                $display("%d tests finished with %d errors\n", vector_num, errors);
                $finish;
            end
        end
    end

endmodule