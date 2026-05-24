module bcd7segDEC_tb();

    reg clk, reset;
    reg[3:0] in;
    reg[1:7] out_expected;
    reg[31:0] vector_num, errors;
    reg[10:0] test_vectors[0:10000];

    wire [1:7] out_real;

    //instantiate
    bcd7segDEC dut(.bcd(in), .leds(out_real));

    initial begin
        $dumpfile("build/waves.vcd");
        $dumpvars(0, bcd7segDEC_tb);
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
        {in, out_expected} = test_vectors[vector_num];
    end

    always @(negedge clk) begin
        if(~reset) begin
            if(out_real !== out_expected) begin
                $display("Error: inputs = %b, outputs = %b (%b expected)\n",
                         in, out_real, out_expected);
                errors = errors + 1;
            end
            vector_num = vector_num + 1;
            if(test_vectors[vector_num] === 11'bx) begin
                $display("%d tests finished with %d errors\n", vector_num, errors);
                $finish;
            end
        end
    end

endmodule