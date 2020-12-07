// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Bit shift operations on 64-bit inputs

`timescale 1ns / 100ps

module int_bit_manip(clk, operation, opa, opb, out);
input       clk;
input       [2:0] operation; 
input       [63:0]  opa, opb;
output      [63:0]  out;      

reg         [63:0]  out_temp; 

always @ (clk) begin
    
    case (operation)
    3'b000: out_temp <= ( opa & ~(1 << opb));            // clear opbth bit           
    3'b001: out_temp <= ( opa | (1 << opb));             // set opbth bit
    3'b010: out_temp <= (opa & (1 << opb)) != 0 ? 1 : 0; // get opbth bit
    3'b011: out_temp <= opa; 
    endcase
end

assign out = out_temp;

endmodule
