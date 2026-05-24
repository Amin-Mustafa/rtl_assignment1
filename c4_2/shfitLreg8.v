`timescale 1ns/1ps

module shiftLreg8 (
    input [7:0] d,
    input clk, rst, en, ldsh, SI,
    output SO,
    output reg [7:0] q
);

// Triggered on posedge clk, active-low async rst
always @(negedge rst, posedge clk) begin
    if (rst == 0) 
        q <= 8'b0;
    else if (en) begin
        if (ldsh) 
            q <= d;
        else 
            q <= {q[6:0], SI}; // Shift Left
    end
    else
        q <= q;
end

assign SO = q[7]; // MSB is the shift output

endmodule