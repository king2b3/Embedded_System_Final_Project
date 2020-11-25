// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Logic operations on 16-bit inputs

`timescale 1ns / 100ps

module int_calc_16(clk, rst, operation, enable, opa, opb, sign, out);
input   clk;
input   rst;
input   [2:0] operation; 
input   [31:0]  opa, opb;
output  [31:0]  result;
input   enable;
output  sign;
output  [31:0]  out;      


always @ (clk) begin
    
    if (reset) begin

        opa <= 0;
        opb <= 0;
        out <= 0;
        sign <= 0;
        enable <= 0;

    end else if (enable) begin
    
        case (operation)

            3'b000: begin
                        out <= opa & opb; // A & B
                    end
            
            3'b001: begin
                        out <= ~(opa & opb); // ~(A & opb)
                    end
            
            3'b010: begin
                        out <= opa | opb; // A x B
                    end
            
            3'b011: begin
                        out <= ~(opa | opb); // ~(A | B)
                    end
            
            3'b100: begin
                        out <= opa ^ opb; // A ^ B 
                    end
            
            3'b101: begin
                        out <= ~(opa ^ opb); // ~(A^B)
                    end
            
            3'b110: begin
                        out <= !(opa); // A^B
                    end
        endcase
    end
end
