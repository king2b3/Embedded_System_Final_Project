// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Logic operations on 64-bit inputs

`timescale 1ns / 100ps

module int_log(clk, operation, opa_log, opb_log, out_log);
input       clk;
input       [2:0] operation; 
input       [15:0]  opa_log, opb_log;
output      [15:0]  out_log;      

reg         [15:0]  out_temp_log; 

always @ (clk) begin
    
    case (operation)

    3'b000: out_temp_log <= opa_log & opb_log;       // A and B
    3'b001: out_temp_log <= ~(opa_log & opb_log);    // A nand B
    3'b010: out_temp_log <= opa_log | opb_log;       // A or B
    3'b011: out_temp_log <= ~(opa_log | opb_log);    // A nor B
    3'b100: out_temp_log <= opa_log ^ opb_log;       // A xor B 
    3'b101: out_temp_log <= (opa_log ~^ opb_log);    // A xnor
    3'b110: out_temp_log <= ~(opa_log);          // not A
    endcase

end

assign out_log = out_temp_log;

endmodule
