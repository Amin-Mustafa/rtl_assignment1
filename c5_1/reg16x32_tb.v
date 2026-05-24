`timescale  1ns/1ps

module reg16x32_tb();
    reg clk, we;
    reg [31:0] Ddata;
    reg [3:0]  Daddr, Aaddr, Baddr;
    reg [31:0] Adata_exp, Bdata_exp;
    reg [2:0]  pad;    // 3 bit padding
    
    reg [31:0] vector_num, errors;
    reg [111:0] test_vectors[0:10000];

    wire [31:0] Adata_real, Bdata_real;

    // Instantiate DUT
    reg16x32 dut(
        .clk(clk), 
        .we(we),
        .Ddata(Ddata),
        .Daddr(Daddr), 
        .Aaddr(Aaddr), 
        .Baddr(Baddr),
        .Adata(Adata_real), 
        .Bdata(Bdata_real)
    );

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, reg16x32_tb);
        $readmemh("test_vectors.tv", test_vectors); // Changed to readmemH for Hex
        vector_num = 0;
        errors = 0;
        clk = 1;
    end

    // Clock generator
    always #5 clk = ~clk;

    always @(negedge clk) begin
        {Ddata, Daddr, Aaddr, Baddr, pad, we, Adata_exp, Bdata_exp} = test_vectors[vector_num];
    end

    always @(posedge clk) begin
        #1; 
        
        if((Adata_real !== Adata_exp) || (Bdata_real !== Bdata_exp)) begin
            $display("Error at Vector %0d: we=%b Daddr=%h Ddata=%h | Aaddr=%h Adata=%h (Exp:%h) | Baddr=%h Bdata=%h (Exp:%h)",
                     vector_num, we, Daddr, Ddata, Aaddr, Adata_real, Adata_exp, Baddr, Bdata_real, Bdata_exp);
            errors = errors + 1;
        end
        
        vector_num = vector_num + 1;
        
        if(test_vectors[vector_num] === 112'bx) begin
            $display("%0d tests finished with %0d errors\n", vector_num, errors);
            $finish;
        end
    end

endmodule