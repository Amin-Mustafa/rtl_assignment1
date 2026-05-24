`timescale 1ns/1ps

module M1 (
    output[0:6] out,
    input rst, clk,
    input[1:0] sel,
    input[2:0] in1, in2
);

reg[3:0] a;
reg[0:6] b;

assign out = b;

always@(in1, in2, sel) begin
    case(sel) 
        0: a = {1'b0, in2};
        1: a = in1 + in2;
        2: a = {1'b0, in1};
        default: a = 4'bxxxx;
    endcase
end

always@(posedge rst, posedge clk) begin
    if(rst) b <= 0;
    else b <= {3'b000, a};
end

endmodule