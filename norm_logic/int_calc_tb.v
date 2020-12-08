module int_calc_tb;

reg clk;
reg [2:0] operation;
reg [63:0] opa_calc;
reg [63:0] opb_calc; 
wire [63:0] out_calc;

 	int_calc_16 UUT (
		.clk(clk),
		.operation(operation),
		.opa_calc(opa_calc),
		.opb_calc(opb_calc),
		.out_calc(out_calc));



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
        operation=0;
        opa_calc=25;opb_calc=30;
        #10;
        $display($time,opa_calc," + ",opb_calc," = ",out_calc);
        #10;
        //
        operation=1;
        opa_calc=25;opb_calc=30;
        #10;
        $display($time,opa_calc," - ",opb_calc," = ",out_calc);
        #10;
        //
        operation=1;
        opa_calc=20;opb_calc=5;
        #10;
        $display($time,opa_calc," - ",opb_calc," = ",out_calc);
        #10;
        //
        operation=2;
        opa_calc=4;opb_calc=5;
        #10;
        $display($time,opa_calc," x ",opb_calc," = ",out_calc);
        #10;
        //
        operation=3;
        opa_calc=10;opb_calc=2;
        #10;
        $display($time,opa_calc," / ",opb_calc," = ",out_calc);
        #10;

        operation=4;
        opa_calc=10;opb_calc=2;
        #10;
        $display($time,opa_calc," % ",opb_calc," = ",out_calc);
        #10;

        $stop;
    end

endmodule