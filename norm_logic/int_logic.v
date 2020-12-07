// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Logic operations on 64-bit inputs

`timescale 1ns / 100ps

module int_log(clk, operation, opa, opb, out);
input       clk;
input       [2:0] operation; 
input       [15:0]  opa, opb;
output      [15:0]  out;      

reg         [15:0]  out_temp; 

always @ (clk) begin
    
    case (operation)
    3'b000: out_temp <= opa & opb;       // A and B
    3'b001: out_temp <= ~(opa & opb);    // A nand B
    3'b010: out_temp <= opa | opb;       // A or B
    3'b011: out_temp <= ~(opa | opb);    // A nor B
    3'b100: out_temp <= opa ^ opb;       // A xor B 
    3'b101: out_temp <= (opa ~^ opb);    // A xnor
    3'b110: out_temp <= ~(opa);          // not A
    endcase

end

assign out = out_temp;

endmodule