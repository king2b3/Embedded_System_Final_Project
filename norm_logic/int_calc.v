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
integer i;

always @ (clk) begin
    case (operation)
    3'b000: out_temp <= opa + opb;           // A + B
    3'b001: out_temp <= opa - opb;           // A - B
    3'b010: out_temp <= opa * opb;           // A x B
    3'b011: out_temp <= opa / opb;           // A / B
    3'b100: out_temp <= opa % opb;           // A % B      
    3'b101: begin
        out_temp <= 1; 
          for(i =0; i < opb ; i = i + 1) begin
              out_temp <= out_temp * opa;
          end
       end
    endcase

end

assign out = out_temp;

endmodule