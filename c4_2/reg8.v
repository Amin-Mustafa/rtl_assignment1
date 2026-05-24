`timescale 1ns/1ps
module reg8 (
    input clk, rst, pst, en,
    input [7:0] d,
    output reg [7:0] q
);

// Matches Example 4-7: active-low reset, active-high preset, negedge clock
always @(negedge rst, posedge pst, negedge clk) begin
    if (rst == 0) 
        q <= 8'b0000_0000;
    else if (pst == 1) 
        q <= 8'b1111_1111; // 8 ones
    else if (en == 1) 
        q <= d;
    else 
        q <= q;
end

endmodule