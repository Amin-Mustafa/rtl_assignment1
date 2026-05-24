`timescale 1ns/1ps

module DU_tb();
    reg clk, reset;
    reg [3:0] dataA, dataB;
    reg ctrlA, ldA, ctrlB, ldB, Psel, ldP;
    
    reg [7:0] P_expected;
    reg b0_expected, z_expected;
    
    reg [31:0] vector_num, errors;
    
    // Inputs(14): reset(1)+dataA(4)+dataB(4)+ctrlA(1)+ldA(1)+ctrlB(1)+ldB(1)+Psel(1)+ldP(1)
    // Outputs(10): P_expected(8)+b0_expected(1)+z_expected(1)
    // Total = 24 bits
    reg [23:0] test_vectors[0:10000];

    wire [7:0] P;
    wire b0, z;

    // Instantiate System Under Test (SUT)
    DU dut (
        .clk(clk), .reset(reset),
        .dataA(dataA), .dataB(dataB),
        .ctrlA(ctrlA), .ldA(ldA),
        .ctrlB(ctrlB), .ldB(ldB),
        .Psel(Psel), .ldP(ldP),
        .P(P), .b0(b0), .z(z)
    );

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, DU_tb);
        $readmemb("test_vectors_du.tv", test_vectors);
        vector_num = 0;
        errors = 0;
        clk = 1; // Start high so first transition is a negedge
    end

    // 10ns Clock Period
    always #5 clk = ~clk;

    // 1. Driving inputs cleanly on falling edge
    always @(negedge clk) begin
        {reset, dataA, dataB, ctrlA, ldA, ctrlB, ldB, Psel, ldP, P_expected, b0_expected, z_expected} = test_vectors[vector_num];
    end

    // 2. Sampling outputs right before the next processing cycle
    always @(posedge clk) begin
        #4; // Wait 4ns into the high phase (well clear of setup/hold timing limits)
        
        if ((P !== P_expected) || (b0 !== b0_expected) || (z !== z_expected)) begin
            $display("Error at Vector %0d: out P=%b (Exp:%b) | b0=%b (Exp:%b) | z=%b (Exp:%b)",
                     vector_num, P, P_expected, b0, b0_expected, z, z_expected);
            errors = errors + 1;
        end
        
        vector_num = vector_num + 1;
        if (test_vectors[vector_num] === 24'bx) begin
            $display("%0d tests finished with %0d errors\n", vector_num, errors);
            $finish;
        end
    end

endmodule