`timescale 1ns / 100ps
module top_tb;

reg clk;
reg rst; 
reg enable;
reg [15:0] switches; 
wire sign;
wire [15:0] sum;
wire ready; 
wire underflow; 
wire overflow;
wire inexact;
wire exception; 
wire invalid;
 
 	top UUT (
 	.clk(clk), 
 	.rst(rst), 
 	.enable(enable), 
 	.switches(switches), 
 	.sign(sign), 
 	.ready(ready), 
 	.underflow(underflow), 
 	.overflow(overflow),
    .inexact(inexact), 
    .exception(exception), 
    .invalid(invalid)
);
 	 
 
always
    begin
        clk = 1'b1;
        #10;
        
        clk = 1'b0;
        #10;
    end    

always @(posedge clk)
    begin
            
        $display($time,"test");
        #10;


        $stop;
    end
      
endmodule
