module bcd7segDEC (  
    input [3:0] bcd,
    output reg[1:7] leds
);

    always @(*) begin
        case(bcd)
            //                  gfe_dcba
            4'h0: leds = 7'b011_1111;
            4'h1: leds = 7'b000_0110;
            4'h2: leds = 7'b101_1011;
            4'h3: leds = 7'b100_1111;
            4'h4: leds = 7'b110_0110;
            4'h5: leds = 7'b110_1101;
            4'h6: leds = 7'b111_1101;
            4'h7: leds = 7'b010_0111;
            4'h8: leds = 7'b111_1111;
            4'h9: leds = 7'b110_1111;
            4'hA: leds = 7'b111_0111;
            4'hB: leds = 7'b111_1100;
            4'hC: leds = 7'b011_1001;
            4'hD: leds = 7'b101_1110;
            4'hE: leds = 7'b111_1001;
            4'hF: leds = 7'b111_0001;
        endcase
    end
    
    
endmodule