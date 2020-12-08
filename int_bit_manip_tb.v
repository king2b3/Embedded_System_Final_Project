`timescale 1ns / 1ps

module int_bit_manip_tb;
reg clk;
reg [2:0] operation;
reg [63:0] opa_bit;
reg [63:0] opb_bit; 
wire [63:0] out_bit;

 	int_bit_manip UUT (
		.clk(clk),
		.operation(operation),
		.opa_bit(opa_bit),
		.opb_bit(opb_bit),
		.out_bit(out_bit));

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
        operation=0; // Clear opbth bit
        opa_bit="0000000000000000";opb_bit="0000000000000000";
        #10;
        $display($time,opa_bit," & ~(1 << ( ",opb_bit,") = ",out_bit);
        #10;
        //
        operation=0; // Clear opbth bit
        opa_bit=65535;opb_bit=15;
        #10;
        $display($time,opa_bit," & ~(1 << ( ",opb_bit,") = ",out_bit);
        #10;
        //
        operation=0; // Clear opbth bit
        opa_bit=3;opb_bit=3;
        #10;
        $display($time,opa_bit," & ~(1 << ( ",opb_bit,") = ",out_bit);
        #10;
        //
        //
        operation=1; // Sep opbth bit 
        opa_bit="0000000000000000";opb_bit="0000000000000000";
        #10;
        $display($time,opa_bit," | (1 << ",opb_bit," ) = ",out_bit);
        #10;
        //
        operation=1; // Sep opbth bit 
        opa_bit=0;opb_bit=15;
        #10;
        $display($time,opa_bit," | (1 << ",opb_bit," ) = ",out_bit);
        #10;
        //
        operation=1; // Sep opbth bit 
        opa_bit=65535;opb_bit=3;
        #10;
        $display($time,opa_bit," | (1 << ",opb_bit," ) = ",out_bit);
        #10;
        //
        //
        operation=2; // get opbth bit
        opa_bit=0;opb_bit=0;
        #10;
        $display($time,opa_bit," & (1 << ",opb_bit," ) = ",out_bit);
        #10;
        //
        operation=2; // get opbth bit
        opa_bit=65535;opb_bit=8;
        #10;
        $display($time,opa_bit," & (1 << ",opb_bit," ) = ",out_bit);
        #10;
        //
        operation=2; // get opbth bit
        opa_bit=4;opb_bit=3;
        #10;
        $display($time,opa_bit," & (1 << ",opb_bit," ) = ",out_bit);
        #10;
        //
        //
        operation=3; // opa
        opa_bit=0;opb_bit=0;
        #10;
        $display($time,opa_bit," = ",out_bit);
        #10;
        //
        operation=3; // opa
        opa_bit=65535;opb_bit=11;
        #10;
        $display($time,opa_bit," = ",out_bit);
        #10;
        //
        operation=3; // opa
        opa_bit=0;opb_bit=15;
        #10;
        $display($time,opa_bit," = ",out_bit);
        #10;
        //
        $stop;
    end

endmodule