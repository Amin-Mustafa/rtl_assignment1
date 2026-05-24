`timescale 1ns/1ps

module reg8_tb();
    reg clk, rst, pst, en;
    reg [7:0] d;
    reg [7:0] q_expected;
    reg [31:0] vector_num, errors;
    
    // 8 (d) + 1 (rst) + 1 (pst) + 1 (en) + 8 (q_expected) = 19 bits
    reg [18:0] test_vectors_reg8[0:10000]; 

    wire [7:0] q_real;

    // Instantiate DUT
    reg8 dut(
        .clk(clk), 
        .rst(rst), 
        .pst(pst), 
        .en(en), 
        .d(d), 
        .q(q_real)
    );

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, reg8_tb);
        $readmemb("test_vectors_reg8.tv", test_vectors_reg8);
        vector_num = 0;
        errors = 0;
        clk = 0; // Initialize clock to 0
    end

    // Clock generator (10ns period)
    always #5 clk = ~clk;

    always @(posedge clk) begin
        {d, rst, pst, en, q_expected} = test_vectors_reg8[vector_num];
    end

    always @(negedge clk) begin
        #1; 
        
        if(q_real !== q_expected) begin
            $display("Error at Vector %0d: d=%b rst=%b pst=%b en=%b | q=%b (Exp:%b)",
                     vector_num, d, rst, pst, en, q_real, q_expected);
            errors = errors + 1;
        end
        
        vector_num = vector_num + 1;
        
        if(test_vectors_reg8[vector_num] === 19'bx) begin
            $display("%0d tests finished with %0d errors\n", vector_num, errors);
            $finish;
        end
    end

endmodule