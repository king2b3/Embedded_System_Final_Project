// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Binary arithmatic

`timescale 1ns / 100ps

module int_calc_16(clk, rst, operation, enable, A, B, sign, sum);
input		clk;
input		rst;
input  [2:0] operation; 
input	[15:0]	A, B;
input	enable;
output	reg	sign;
output  reg [15:0]	sum;      


always @ (clk) begin


    if (enable) begin
    
        case (operation)

            3'b000: 
                    sum = A + B; // A + B
        
            3'b001: 
                    sum <= A - B; // A - B
        
            3'b010: 
                    sum <= A * B; // A x B
                    
            3'b011: 
                    sum <= A / B; // A / B
        
            3'b100: 
                    sum <= A * 2.7**B;// A*exp(B) 
        
            3'b101: 
                    sum <= $log10(A); // log10(A); maybe want this later if possible: log_A (B)
        
            3'b110: 
                        sum <= A**B; // A^B
            
            3'b111: 
                        sum <= A % B;// A % B
                        
        endcase

        sign <= sum[15];

    end
end
endmodule