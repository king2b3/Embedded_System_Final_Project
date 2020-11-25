module int_calc_16_tb;

reg clk;
reg rst; 
reg [2:0] operation;
reg enable;
reg [15:0] A;
reg [15:0] B; 
wire sign;
wire [15:0] sum;
 
 	int_calc_16 UUT (
		.clk(clk),
		.rst(rst),
		.operation(operation),
		.enable(enable),
		.A(A),
		.B(B),
		.sign(sign),
		.sum(sum));
 
 
 
always
    begin
        clk = 1'b1;
        #10;
        
        clk = 1'b0;
        #10;
    end    

always @(posedge clk)
    begin
            

        // Initialize Inputs
        enable=1;operation=0;
        A=25;B=30;
        #10;
        $display($time,A," + ",B," = ",sum);
        #10;
        //
        enable=1;operation=1;
        A=25;B=30;
        #10;
        $display($time,A," - ",B," = ",sum);
        #10;
        //
        enable=1;operation=1;
        A=20;B=5;
        #10;
        $display($time,A," - ",B," = ",sum);
        #10;
        //
        enable=1;operation=2;
        A=4;B=5;
        #10;
        $display($time,A," x ",B," = ",sum);
        #10;
        //
        enable=1;operation=3;
        A=10;B=2;
        #10;
        $display($time,A," / ",B," = ",sum);
        #10;

        enable=1;operation=4;
        A=10;B=2;
        #10;
        $display($time,A," * exp( ",B,") = ",sum);
        #10;

        enable=1;operation=5;
        A=10;
        #10;
        $display($time," log_10(",A,") = ",sum);
        #10;

        enable=1;operation=6;
        A=2;B=2;
        #10;
        $display($time,A," ^ ",B," = ",sum);
        #10;
        
        enable=1;operation=7;
        A=10;B=2;
        #10;
        $display($time,A," % ",B," = ",sum);
        #10;

        $stop;
    end
      
endmodule
