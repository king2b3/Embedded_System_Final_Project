// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Bit shift operations on 64-bit inputs

`timescale 1ns / 100ps

module int_bit_manip(clk, rst, operation, opa, opb, out);
input       clk;
input       rst;
input       [2:0] operation; 
input       [63:0]  opa, opb;
output      [63:0]  out;      


always @ (clk) begin
    
    if (reset) begin
        out <= 0;
        sign <= 0;

    end else begin
        case (operation)
        3'b000: opa <= ( opa & ~(1 << opb));            // clear opbth bit           
        3'b001: opa <= ( opa | (1 << opb));             // set opbth bit
        3'b010: out <= (opa & (1 << opb)) != 0 ? 1 : 0; // get opbth bit
        3'b011: out <= opa; 
        endcase
        sign <= out[63];
    end
end
