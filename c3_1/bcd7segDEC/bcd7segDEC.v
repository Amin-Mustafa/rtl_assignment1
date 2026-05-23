module bcd7segDEC (  
    input [3:0] num,
    output reg[6:0] segments
);

    always @(*) begin
        case(num)
            //                  gfe_dcba
            4'h0: segments = 7'b011_1111;
            4'h1: segments = 7'b000_0110;
            4'h2: segments = 7'b101_1011;
            4'h3: segments = 7'b100_1111;
            4'h4: segments = 7'b110_0110;
            4'h5: segments = 7'b110_1101;
            4'h6: segments = 7'b111_1101;
            4'h7: segments = 7'b010_0111;
            4'h8: segments = 7'b111_1111;
            4'h9: segments = 7'b110_1111;
            4'hA: segments = 7'b111_0111;
            4'hB: segments = 7'b111_1100;
            4'hC: segments = 7'b011_1001;
            4'hD: segments = 7'b101_1110;
            4'hE: segments = 7'b111_1001;
            4'hF: segments = 7'b111_0001;
        endcase
    end
    
    
endmodule