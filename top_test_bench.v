`timescale 1ns / 100ps
module top_final_tb;

reg clk;
reg rst; 
reg enable;
reg [15:0] switches; 
wire UART_TXD;
wire [15:0] leds;

 	top UUT (
 	.clk(clk), 
 	.rst(rst), 
 	.enable(enable), 
 	.switches(switches), 
 	.leds(leds),
 	.UART_TXD(UART_TXD)
 	
);
 	 
    localparam clock_time = 1;
    localparam button_press = 5;
    localparam time_between = 20;

 
always
    begin
        clk = 1'b1;
        #clock_time;
        
        clk = 1'b0;
        #clock_time;
    end    

always @(posedge clk)
    begin
            
        $display($time,"start");
          rst=0; 
 	      enable=0; 
 	      switches=0; 
        $display($time,"adding two numbers");
        // select a mode
        switches = 1;  // arithmatic mode
        enable=1;#button_press;enable=0;
        // select an operation
        switches = 0;  // add mode
        enable=1;#button_press;enable=0;
        switches = 4;  // input a onto switches
        enable=1;#button_press;enable=0;
        switches = 5;  // input b onto switches
        enable=1;#button_press;enable=0;
        // output is made. goes to state 110
        enable=1;#button_press;enable=0;
        enable=1;#button_press;enable=0;
        #time_between;
        // goes back to start
        $display($time,"anding two numbers");
        // select a mode
        switches = 3;  // logic mode
        enable=1;#button_press;enable=0;
        // select an operation
        switches = 0;  // and mode
        enable=1;#button_press;enable=0;
        switches = 4;  // input a onto switches
        enable=1;#button_press;enable=0;
        switches = 5;  // input b onto switches
        enable=1;#button_press;enable=0;
        // output is made. goes to state 110
        enable=1;#button_press;enable=0;
        enable=1;#button_press;enable=0;
        // goes back to start
        
        


        $stop;
    end
      
endmodule
