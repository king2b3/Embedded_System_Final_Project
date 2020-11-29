// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Top level wrapper for project

`timescale 1ns / 100ps

module int_calc_32(clk, rst, operation, enable, opa, opb, sign, out);
input   clk;
input   rst;
input   [2:0] operation; 
input   [63:0]  opa, opb;
input   enable;
output  sign;
output  [63:0]  out;      

reg mode_sel;
reg size_sel;
reg [1:0] state;
reg [1:0] in_size;  // 0: 16 bit. 1: 32 bit. 2: 64 bit.
integer i;

initial begin
    
    state <= 0;
    sign <= 0;
    out <= 0;
    mode_sel <= 0;
    size_sel <= 0;

end


always @ (clk) begin
    
    if (reset) begin

        state <= 0;
        sign <= 0;
        out <= 0;
        mode_sel <= 0;
        size_sel <= 0;

    end else begin

        case (state)

            2'b00: begin
    
                $display($time,"Please select a mode on swithced ##. Press button ## when the mode is selected")
                $display("000 for Floating Point")
                $display("001 for Binary Arthimatic")
                $display("010 for Bit Shifting")
                $display("011 for Binary Logic")
                $display("100 to Store A Value")
                $display("101 to Fetch a Stored Value")

                
                if (mode_selected == 1'b1) begin
                
                    mode_selected <= 0;
                    // operation <= Switches 
                    // increment state

                end
            end

            2'b01: begin

                $display($time,"Please select a bit-size")
                $display("000 for 16-bit inputs")
                $display("001 for 32-bit inputs")
                $display("010 for 64-bit inputs")
                
                if (mode_selected == 1'b1) begin
                
                    mode_selected <= 0;
                    // size_sel <= Switches 
                    // increment state

                end

            end

            2'b10:begin
                
                $display($time,"Please place input A on the switches")
                for 
                $display("Press enable to continue after bits have been placed on the switches")

            end 
        endcase

    end
end

always @(enable) begin
    
    if (mode_selected == 1'b0)
        mode_selected <= 1'b1;
end