`timescale 1ns/1ps

module reg16x32(
    input we, clk, 
    input[31:0] Ddata,
    input[3:0]  Daddr, Aaddr, Baddr,
    output[31:0] Adata, Bdata
);

    reg[31:0] RF[15:0];

    always@(posedge clk) begin
        if(we) RF[Daddr] <= Ddata;
    end

    assign Adata = RF[Aaddr];
    assign Bdata = RF[Baddr];

endmodule