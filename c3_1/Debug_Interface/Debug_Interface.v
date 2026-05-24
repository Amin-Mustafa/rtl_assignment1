`timescale 1ns/1ps

module Debug_Interface(
    input[3:0] Ain, Bin, Cin,
    input[2:0] Din,
    input[1:0] sel,
    output reg[7:0] out
);

always@(sel, Ain, Bin, Cin, Din) begin
    case(sel) 
        2'b00: out = {4'b0000, Ain};
        2'b01: out = {4'b0000, Bin};
        2'b10: out = {4'b0000, Cin};
        2'b11: out = {5'b0000, Din};
    endcase
end

endmodule