module int_bit_manip_tb;

reg clk;
reg [2:0] operation;
reg [63:0] opa_bit_manip;
reg [63:0] opb_bit_manip; 
wire [63:0] out_bit_manip;

    int_bit_manip_16 UUT (
        .clk(clk),
        .operation(operation),
        .opa_bit_manip(opa_bit_manip),
        .opb_bit_manip(opb_bit_manip),
        .out_bit_manip(out_bit_manip));



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
        opa_bit_manip=18;opb_bit_manip=2;
        $display($time, "(", opa_bit_manip," ( & ~ (1 << ",opb_bit_manip,")) = ",out_bit_manip);
        #10;
        // 
        operation=0;
        opa_bit_manip=16;opb_bit_manip=5;
        $display($time, "(", opa_bit_manip," ( & ~ (1 << ",opb_bit_manip,")) = ",out_bit_manip);
        #10;
        //
        operation=1;
        opa_bit_manip=0;opb_bit_manip=2;
        $display($time, "(", opa_bit_manip," ( | (1 << ",opb_bit_manip,")) = ",out_bit_manip);
        #10;
        //
        operation=1;
        opa_bit_manip=2;opb_bit_manip=5;
        $display($time, "(", opa_bit_manip," ( | (1 << ",opb_bit_manip,")) = ",out_bit_manip);
        #10;
        //
        operation=2;
        opa_bit_manip=18;opb_bit_manip=2;
        $display($time, opb_bit_manip," bit is set? ",opb_bit_manip,")) = ",out_bit_manip);
        #10;
        //
        operation=2;
        opa_bit_manip=18;opb_bit_manip=5;
        $display($time, opb_bit_manip," bit is set? ",opb_bit_manip,")) = ",out_bit_manip);
        //
        #10;
        operation=3;
        opa_bit_manip=18;opb_bit_manip=2;
        $display($time, " out_bit_mapip = ", out_bit_manip);

        $stop;
    end

endmodule
