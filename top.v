// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Top level wrapper for project

`timescale 1ns / 100ps

module top(clk, rst, enable, switches, sign, sign, ready, underflow, overflow,
           inexact, exception, invalid 
);

input       clk;
input       rst;
input       enable;
input       [15:0]  switches;

// led outputs
output      sign;
output		ready;
output		underflow;
output		overflow;
output		inexact;
output		exception;
output		invalid;      

reg     [2:0] operation;
reg     [2:0] op2;
reg     [63:0]  fp_out;
reg     [63:0]  bit_manip_out;
reg     [63:0]  int_calc_out;
reg     [63:0]  int_logic_out;

reg     [63:0]  opa, opb;
reg     [1:0] size_sel; // 0: 16 bit. 1: 32 bit. 2: 64 bit.
reg     [2:0] state; 
reg     [255:0] memory;
reg     enable_deb;
reg     [1:0] rmode;
reg     printed;
reg     [1:0] counter;

initial begin
    
    state <= 0;
    sign <= 0;
    out <= 0;
    size_sel <= 0;
    memory <= 0;
    operation <= 0;

end

debouncer u1 (
    .pb_1(enable), .clk(clk), .pb_out(enable_deb)
);

fpu_double u2( 
    .clk(clk), .rst(rst), .enable(1'b1), .rmode(rmode), 
    .fpu_op(op2), .opa(opa), .opb(opb), .out(fp_out), .ready(ready), 
    .underflow(underflow),.overflow(overflow), .inexact(inexact), 
    .exception(expection), .invalid(invalid)
);

int_bit_manip u3(
    .clk(clk), .rst(rst), .operation(op2),
    .opa(opa), .opb(opb), .out(bit_manip_out)
);

int_calc u4(
    .clk(clk), .rst(rst), .operation(op2),
    .opa(opa), .opb(opb), .sum(int_calc_out)
);

int_log u5(
    .clk(clk), .rst(rst), .operation(op2),
    .opa(opa), .opb(opb), .out(int_logic_out)
);


always @ (clk) begin
    
    if (reset) begin

        state <= 0;
        out <= 0;
        size_sel <= 0;

    end else begin


        case (state)

        3'b000: begin
            if (printed) begin
                $display($time,"Please select a mode on swithces 2-0. Press button ## when 
                    the mode is selected")
                $display("000 for Floating Point")
                $display("001 for Binary Arthimatic")
                $display("010 for Bit Shifting")
                $display("011 for Binary Logic")
                $display("100 to Fetch a Stored Value")
                $display("101 to Store A Value")
                printed <= 0;
            else if (enable_deb == 1'b1) begin
                operation <= switches[2:0];
                state <= state+1;
                printed <= 1;
            end
        end

        3'b001:begin
            if (printed) begin
                case (operation)
                3'b000: begin
                    $display($time,"Please select an FPU operation on 
                        switches XX. Then press XX to confirm the mode")
                    $display("00: add. 01: sub. 10: mul. 11: div") // op2
                end

                3'b001: begin
                    $display($time,"Please select a Arthimatic Operation on switches XXX. 
                        Then press XX to confirm the mode")
                    $display("000: add (A+B). 001: sub (A-B). 010: mul (A*B). 011: div (A/B)")
                    $display("100: log (log10(A)). 101: pow (A^B). 110: rem (A%B)")
                end

                3'b010: begin
                    $display($time,"Please select a Bit Operation on switches XX. 
                        Then press XX to confirm the mode")
                    $display("00: clear bit. 01: set bit. 10: get bit. 11: set output")
                end

                3'b011: begin
                    $display($time,"Please select a Binary Logic on switches XXX. 
                        Then press XX to confirm the mode")
                    $display("000: and (A&B). 001: nand ~(A&B). 010: or (AxB). 011: nor ~(AxB)")
                    $display("100: xor (A ^ B)). 101: xnor ~(A ^ B). 110: not (~A)")
                end

                3'b100: begin
                    $display($time,"Store a value")
                    $display($time,"Please select either reg A (00), B (01), C (10) or D (11) 
                        by using switches XX")
                end

                3'b101: begin
                    $display($time,"Fetch a value")
                    $display("Please select either reg A (00), B (01), C (10) or D (11) 
                        by using switches XX")
                end
                endcase
                printed <= 0;
            else if (enable_deb == 1'b1) begin
                op2 <= switches[2:0];
                state <= state+1;
                printed <= 1;
            end

        end 
        
        
        3'b010: begin
            if (printed) begin
                $display($time,"Please select a bit-size")
                $display("000 for 16-bit inputs")
                $display("001 for 32-bit inputs")
                $display("010 for 64-bit inputs")
                printed <= 0;
            
            else if (enable_deb == 1'b1) begin
                size_sel <= switches[1:0];
                state <= state + 1;
                printed <= 1;
            end

        end

        3'b011:begin
            if (printed) begin
                $display($time,"Please place input A on the switches")
                printed <= 0;
            end else if (counter < <= size_sel and enable_deb == 1'b1) begin
                opa[(counter+1)*16 : counter*16] = switches;
            end else if (counter > size_sel) begin
                if ( 
                    (operation == 3'b1XX) or
                    (operation == 3'b001 and op2 == 3'b101) or
                    (operation == 3'b011 and op2 == 3'110)
                )
                    state = 3'b101;
                else
                    state = state+1;
                printed <= 1;

            end
            
        end 

        3'b100:begin
            if (printed) begin
                $display($time,"Please place input B on the switches")
                printed <= 0;
            end else if (counter < <= size_sel and enable_deb == 1'b1) begin
                opa[(counter+1)*16 : counter*16] = switches;
            end else if (counter > size_sel) begin
                state <= state+1;
                printed <= 1;
            end
            
        end 

        3'b101:begin
            case (operation)
            3'b000:     out <= fp_out;
            3'b001:     out <= bit_manip_out;
            3'b010:     out <= int_calc_out;
            3'b011:     out <= int_logic_out;
            3'b100:     out <= memory[((op2+1)*16) : (op2*16)]
            3'b101:     begin
                memory[((op2+1)*16) : (op2*16)] <= opa;
                out <= opa;
            end
            endcase
            case (size_sel)
            2'b00:      sign <= out[15];
            2'b00:      sign <= out[31];
            2'b00:      sign <= out[63];  
            endcase                      
            
            $display($time,"Output = ",out)
            state <= 0;
        end 

        endcase

    end
end

