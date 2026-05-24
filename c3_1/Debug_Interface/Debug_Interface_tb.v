`timescale  1ns/1ps

module Debug_Interface_tb();

    reg clk, reset;
    reg[3:0] Ain, Bin, Cin;
    reg[2:0] Din;
    reg[1:0] sel;
    reg[7:0] out_expected;
    reg[31:0] vector_num, errors;
    reg[24:0] test_vectors[0:10000];

    wire[7:0] out_real;

    //instantiate
    Debug_Interface dut(.Ain(Ain), .Bin(Bin), .Cin(Cin), .Din(Din), .sel(sel), 
                        .out(out_real));

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, Debug_Interface_tb);
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
        {Ain, Bin, Cin, Din, sel, out_expected} = test_vectors[vector_num];
    end

    always @(negedge clk) begin
        if(~reset) begin
            if(out_real !== out_expected) begin
                $display("Error: inputs = %b %b %b %b %b, outputs = %b (%b expected)\n",
                         Ain, Bin, Cin, Din, sel, out_real, out_expected);
                errors = errors + 1;
            end
            vector_num = vector_num + 1;
            if(test_vectors[vector_num] === 25'bx) begin
                $display("%d tests finished with %d errors\n", vector_num, errors);
                $finish;
            end
        end
    end

endmodule