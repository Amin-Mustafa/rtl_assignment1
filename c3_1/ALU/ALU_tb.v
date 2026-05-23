`timescale  1ns/1ps

module ALU_tb();

    reg clk, reset;
    reg[3:0] Ain, Bin;
    reg[2:0] op;
    reg[3:0] out_expected;
    reg[31:0] vector_num, errors;
    reg[14:0] test_vectors[0:10000];

    wire [3:0] out_real;

    //instantiate
    ALU dut(.Ain(Ain), .Bin(Bin), .op(op), .ALUOut(out_real));

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, ALU_tb);
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
        {Ain, Bin, op, out_expected} = test_vectors[vector_num];
    end

    always @(negedge clk) begin
        if(~reset) begin
            if(out_real !== out_expected) begin
                $display("Error: inputs = %b %b %b, outputs = %b (%b expected)\n",
                         Ain, Bin, op, out_real, out_expected);
                errors = errors + 1;
            end
            vector_num = vector_num + 1;
            if(test_vectors[vector_num] === 15'bx) begin
                $display("%d tests finished with %d errors\n", vector_num, errors);
                $finish;
            end
        end
    end

endmodule