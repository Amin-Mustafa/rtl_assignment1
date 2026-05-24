`timescale 1ns/1ps

module upcount8(
    input clk, rst, ld, inc,
    input[7:0] data,
    output reg[7:0] Q
);

always@(posedge clk, negedge rst) begin
    if(~rst) Q <= 8'b0;
    else if(ld) Q <= data;
    else if(inc) Q <= Q + 1;
    else Q <= Q; 
end

endmodule