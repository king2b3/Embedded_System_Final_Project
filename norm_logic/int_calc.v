// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Binary arithmatic 64-bits

`timescale 1ns / 100ps

module int_calc(clk, operation, opa_calc, opb_calc, out_calc);
input           clk;
input           [2:0] operation; 
input	        [15:0]	opa_calc, opb_calc;
output          [15:0]	out_calc;      

reg         [15:0]  out_temp_calc; 
integer i;

always @ (clk) begin
    case (operation)
    3'b000: out_temp_calc <= opa_calc + out_calc;           // A + B
    3'b001: out_temp_calc <= opa_calc - out_calc;           // A - B
    3'b010: out_temp_calc <= opa_calc * out_calc;           // A x B
    3'b011: out_temp_calc <= opa_calc / out_calc;           // A / B
    3'b100: out_temp_calc <= opa_calc % out_calc;           // A % B      
    endcase

end

assign out_calc = out_temp_calc;

endmodule
