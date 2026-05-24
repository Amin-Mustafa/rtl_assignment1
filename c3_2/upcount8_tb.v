`timescale  1ns/1ps

module upcount8_tb();
    reg clk, rst, ld, inc;
    reg[7:0] data;
    reg[7:0] Q_expected;
    reg[31:0] vector_num, errors;
    reg[18:0] test_vectors[0:10000];

    wire [7:0] Q_real;

    //instantiate
    upcount8 dut(.clk(clk), .rst(rst), .ld(ld), .inc(inc), .data(data), .Q(Q_real));

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, upcount8_tb);
    end

    initial begin
        $readmemb("test_vectors.tv", test_vectors);
        vector_num = 0;
        errors = 0;
    end

    always begin
        clk = 1; #5; clk = 0; #5;
    end

    always @(negedge clk) begin
        #1;
        {data, rst, ld, inc, Q_expected} = test_vectors[vector_num];
    end

    always @(negedge clk) begin
        if(Q_real !== Q_expected) begin
            $display("Error: inputs = %b %b %b %b, outputs = %b (%b expected)\n",
                     data, rst, ld, inc, Q_real, Q_expected);
            errors = errors + 1;
        end
        
        vector_num = vector_num + 1;
        
        if(test_vectors[vector_num] === 19'bx) begin
            $display("%d tests finished with %d errors\n", vector_num, errors);
            $finish;
        end
    end

endmodule