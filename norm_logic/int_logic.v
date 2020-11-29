// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Logic operations on 64-bit inputs

`timescale 1ns / 100ps

module int_calc(clk, rst, operation, enable, opa, opb, out);
input   clk;
input   rst;
input   [2:0] operation; 
input   [63:0]  opa, opb;
input   enable;
output  [63:0]  out;      


always @ (clk) begin
    
    if (reset) begin

        out <= 0;;

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
