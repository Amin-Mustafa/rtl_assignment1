`timescale 1ns/1ps

module shiftRreg4_tb();
    reg clk, rst, en, ldsh, SI;
    reg [3:0] d;
    reg SO_expected;
    reg [3:0] q_expected;
    
    reg [31:0] vector_num, errors;
    
    // d(4) + rst(1) + en(1) + ldsh(1) + SI(1) + SO_expected(1) + q_expected(4) = 13 bits
    reg [12:0] test_vectors[0:10000]; 

    wire SO_real;
    wire [3:0] q_real;

    // Instantiate DUT
    shiftRreg4 dut(
        .clk(clk), .rst(rst), .en(en), .ldsh(ldsh), .SI(SI), .d(d), 
        .SO(SO_real), .q(q_real)
    );

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, shiftRreg4_tb);
        $readmemb("test_vectors_R4.tv", test_vectors);
        vector_num = 0;
        errors = 0;
        clk = 1; 
    end

    always #5 clk = ~clk;

    always @(negedge clk) begin
        {d, rst, en, ldsh, SI, SO_expected, q_expected} = test_vectors[vector_num];
    end

    always @(posedge clk) begin
        #1; 
        if((q_real !== q_expected) || (SO_real !== SO_expected)) begin
            $display("Error at Vector %0d: d=%b rst=%b en=%b ldsh=%b SI=%b | q=%b (Exp:%b), SO=%b (Exp:%b)",
                     vector_num, d, rst, en, ldsh, SI, q_real, q_expected, SO_real, SO_expected);
            errors = errors + 1;
        end
        vector_num = vector_num + 1;
        if(test_vectors[vector_num] === 13'bx) begin
            $display("%0d tests finished with %0d errors\n", vector_num, errors);
            $finish;
        end
    end
endmodule