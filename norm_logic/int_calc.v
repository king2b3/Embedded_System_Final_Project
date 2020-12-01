// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Binary arithmatic 64-bits

`timescale 1ns / 100ps

module int_calc(clk, operation, opa, opb, out);
input           clk;
input           [2:0] operation; 
input	        [63:0]	opa, opb;
output          [63:0]	out;      

reg         [63:0]  out_temp; 

always @ (clk) begin
    case (operation)
    3'b000: out_temp <= opa + opb;           // A + B
    3'b001: out_temp <= opa - opb;           // A - B
    3'b010: out_temp <= opa * opb;           // A x B
    3'b011: out_temp <= opa / opb;           // A / B
    //3'b100: out_temp <= $log10(opa);       // log10(A); maybe want this later if possible: log_A (B) 
    //3'b101: out_temp <= opa**opb;            // A^B
    3'b100: out_temp <= opa % opb;           // A % B      
    endcase

end

assign out = out_temp;

endmodule