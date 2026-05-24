`timescale 1ns/1ps
module M1_tb();
    reg clk;
    reg[0:6] out_expected;
    reg rst;
    reg[1:0] sel;
    reg[2:0] in1, in2;

    reg[31:0] vector_num, errors;
    reg[15:0] test_vectors[0:10000];

    wire [0:6] out_real;

    //instantiate
    M1 dut(
        .clk(clk), .rst(rst),
        .sel(sel),
        .in1(in1), .in2(in2),
        .out(out_real)
    );

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, M1_tb);
        $readmemb("test_vectors.tv", test_vectors);
        vector_num = 0;
        errors = 0;
        clk = 1;
    end

    always #5 clk = ~clk;

    always @(negedge clk) begin
        {rst, sel, in1, in2, out_expected} = test_vectors[vector_num];
    end

    always @(posedge clk) begin
        #1;
        if(out_real !== out_expected) begin
            $display("Error at Vector %0d: rst=%b sel=%b in1=%b in2=%b| out=%b (Exp:%b)",
                     vector_num, rst, sel, in1, in2, out_real, out_expected);
            errors = errors + 1;
        end
        vector_num = vector_num + 1;
        if(test_vectors[vector_num] === 16'bx) begin
            $display("%d tests finished with %d errors\n", vector_num, errors);
            $finish;
        end
    end

endmodule