`timescale 1ns/1ps

module DPU(
    input[15:0] din,
    input[1:0]  dsel,
    output[1:7] seg,
    output reg[7:0] dout
);

wire[3:0] Ain, Bin;
wire[2:0] ALUop;
reg[3:0]  ALUout;

assign Ain = din[3:0];
assign Bin = din[7:4];
assign ALUop = din[10:8];

ALU alu(.Ain(Ain), .Bin(Bin), .op(ALUop), .ALUOut(ALUout));
Debug_Interface di(.Ain(Ain), .Bin(Bin), .Cin(ALUout), .Din(ALUop), .sel(dsel), .out(dout));
bcd7segDEC DisplayDecoder(.bcd(ALUout), .leds(seg));

endmodule;