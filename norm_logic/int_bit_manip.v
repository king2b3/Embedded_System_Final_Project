// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Bit shift operations on 64-bit inputs

`timescale 1ns / 100ps

module int_calc(clk, rst, operation, enable, opa, opb, sign, out);
input   clk;
input   rst;
input   [2:0] operation; 
input   [63:0]  opa, opb;
input   enable;
output  sign;
output  [63:0]  out;      


always @ (clk) begin
    
    if (reset) begin

        out <= 0;
        sign <= 0;

    end else if (enable) begin
    
        case (operation)

            3'b000: begin
                        opa <= ( opa & ~(1 << opb)); // clear opbth bit
                    end
            
            3'b001: begin
                        opa <= ( opa | (1 << opb)); // set opbth bit
                    end
            
            3'b010: begin
                        out <= (opa & (1 << opb)) != 0 ? 1 : 0; // get opbth bit
                    end
            
            3'b011: begin
                        out <= opa; 
                    end
        endcase

        sign <= out[63];
    end
end
