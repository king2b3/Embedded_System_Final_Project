// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Binary arithmatic

`timescale 1ns / 100ps

module int_calc_16(clk, rst, operation, enable, opa, opb, sign, sum);
input		clk;
input		rst;
input  [2:0] operation; 
input	[15:0]	opa, opb;
output  [15:0]  result;
input		enable;
output		sign;
output  [15:0]	sum;      


always @ (clk) begin
    
    if (reset) begin

        opa <= 0;
        opb <= 0;
        sum <= 0;
        sign <= 0;
        enable <= 0;

    end else if (enable) begin
    
        case (operation)

            3'b000: begin
                        sum <= A + B; // A + B
                    end
            
            3'b001: begin
                        // A - B
                    end
            
            3'b010: begin
                        // A x B
                    end
            
            3'b011: begin
                        // A / B
                    end
            
            3'b100: begin
                        // A*exp(B) 
                    end
            
            3'b101: begin
                        // log_A (B)
                    end
            
            3'b110: begin
                        // A^B
                    end
            
            3'b111: begin
                        // A % B
                    end
        endcase
    end
end
