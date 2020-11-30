// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Binary arithmatic 64-bits

`timescale 1ns / 100ps

module int_calc(clk, rst, operation, A, B, sum);
input           clk;
input		rst;
input           [2:0] operation; 
input	        [63:0]	opa, opb;
output          [63:0]	sum;      


always @ (clk) begin


    if (enable) begin
        case (operation)
        3'b000: sum <= A + B;           // A + B
        3'b001: sum <= A - B;           // A - B
        3'b010: sum <= A * B;           // A x B
        3'b011: sum <= A / B;           // A / B
        3'b100: sum <= $log10(A);       // log10(A); maybe want this later if possible: log_A (B) 
        3'b101: sum <= A**B;            // A^B
        3'b110: sum <= A % B;           // A % B      
        endcase

        sign <= sum[63];

    end
end
endmodule