`timescale 1ns/1ps

module ALU(
    input[3:0] Ain, Bin,
    input[2:0] op,
    output reg[3:0] ALUOut
);

always@(op, Ain, Bin) begin
    case (op) 
        3'b000: ALUOut = Ain;
        3'b001: ALUOut = Ain | Bin;
        3'b010: ALUOut = Ain ^ Bin;
        3'b011: ALUOut = Ain & Bin;
        3'b100: ALUOut = Ain - Bin;
        3'b101: ALUOut = Ain + Bin;
        default: ALUOut = Bin;
    endcase
end

endmodule