`timescale 1ns/1ps

module shiftRreg4 (
    input [3:0] d,
    input clk, rst, en, ldsh, SI,
    output SO,
    output reg [3:0] q
);

always @(negedge rst, posedge clk) begin
    if (rst == 0) 
        q <= 4'b0;
    else if (en) begin
        if (ldsh) 
            q <= d;
        else 
            q <= {SI, q[3:1]}; // Shift Right
    end
    else
        q <= q;
end

assign SO = q[0]; // LSB is the shift output

endmodule