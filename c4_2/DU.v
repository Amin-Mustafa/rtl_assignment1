`timescale 1ns/1ps

module DU (
    input clk, reset,
    input [3:0] dataA, dataB,
    input ctrlA, ldA, ctrlB, ldB, Psel, ldP,
    output [7:0] P,
    output b0, z
);

    wire [7:0] A;
    wire [3:0] B;
    wire [7:0] sum;
    wire [7:0] dataP;
    wire SO_A; // Unused serial out from left shift

    // Submodule Instantiations
    
    // shiftLreg8 instance: Ain is 4'b0000 concatenated with dataA
    shiftLreg8 shift_left_reg (
        .d({4'b0000, dataA}),
        .clk(clk),
        .rst(reset),
        .en(ldA),
        .ldsh(ctrlA),
        .SI(1'b0),
        .SO(SO_A),
        .q(A)
    );

    // shiftRreg4 instance
    shiftRreg4 shift_right_reg (
        .d(dataB),
        .clk(clk),
        .rst(reset),
        .en(ldB),
        .ldsh(ctrlB),
        .SI(1'b0),
        .SO(b0),
        .q(B)
    );

    // Structural Datapath Logic
    assign sum = A + {4'b0000, B};
    assign dataP = (Psel == 1'b1) ? sum : A;
    assign z = ~(|B); // 4-input NOR reduction operator

    // reg8 instance (Operates on negedge clk, active-low reset, preset tied to 0)
    reg8 storage_reg (
        .clk(clk),
        .rst(reset),
        .pst(1'b0),
        .en(ldP),
        .d(dataP),
        .q(P)
    );

endmodule