// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Logic operations on 64-bit inputs

`timescale 1ns / 100ps

module int_log(clk, rst, operation, opa, opb, out);
input       clk;
input       rst;
input       [2:0] operation; 
input       [63:0]  opa, opb;
output      [63:0]  out;      


always @ (clk) begin
    
    if (reset) begin
        out <= 0;;

    end else if (enable) begin
        case (operation)
        3'b000: out <= opa & opb;       // A & B
        3'b001: out <= ~(opa & opb);    // ~(A & opb)
        3'b010: out <= opa | opb;       // A x B
        3'b011: out <= ~(opa | opb);    // ~(A | B)
        3'b100: out <= opa ^ opb;       // A ^ B 
        3'b101: out <= ~(opa ^ opb);    // ~(A^B)
        3'b110: out <= !(opa);          // A^B
        endcase
    end
end
