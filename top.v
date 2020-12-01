// Bayley King, Bryan Kanu, Zach Hadden
// Embedded Systems final project
// Top level wrapper for project

`timescale 1ns / 100ps

module top(clk, rst, enable, switches, sign, ready, underflow, overflow,
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
wire     [63:0]  fp_out;
wire     [63:0]  bit_manip_out;
wire     [63:0]  int_calc_out;
wire     [63:0]  int_logic_out;
reg     [63:0]  out;

reg     [63:0]  opa, opb;
reg     [1:0] size_sel; // 0: 16 bit. 1: 32 bit. 2: 64 bit.
reg     [2:0] state; 
reg     [255:0] memory;
wire     enable_deb;
reg     [1:0] rmode;
reg     printed;
reg     [1:0] count;
reg     sign_temp;
reg     [4:0] uart_mode;

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
    .clk(clk), .operation(op2),
    .opa(opa), .opb(opb), .out(bit_manip_out)
);

int_calc u4(
    .clk(clk), .operation(op2),
    .opa(opa), .opb(opb), .out(int_calc_out)
);

int_log u5(
    .clk(clk), .operation(op2),
    .opa(opa), .opb(opb), .out(int_logic_out)
);

uart_out u6(
    .inA(out), .CLK(clk), .mode(uart_mode)
);
    
initial begin
    
    state <= 0;
    out <= 0;
    size_sel <= 0;
    memory <= 0;
    operation <= 0;
    count <= 0;
    sign_temp <= 0;
    printed <= 1;
    uart_mode <= 0;
end
    
always @ (clk) begin
    
    if (rst) begin

        state <= 0;
        out <= 0;
        size_sel <= 0;

    end else begin


        case (state)

        3'b000: begin
            if (printed) begin
                uart_mode <= 0;
                // $display($time,"Please select a mode on swithces 2-0. Press button U18 when the mode is selected");
                // CHAR_ARRAY(0 to 79) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"6d",X"6f",X"64",X"65",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"68",X"63",X"65",X"73",X"20",X"32",X"2d",X"30",X"2e",X"20",X"50",X"72",X"65",X"73",X"73",X"20",X"62",X"75",X"74",X"74",X"6f",X"6e",X"20",X"55",X"31",X"38",X"20",X"77",X"68",X"65",X"6e",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65",X"20",X"69",X"73",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"65",X"64");
                
                uart_mode <= uart_mode +1;
                //$display("000 for Floating Point, 001 for Binary Arthimatic, 010 for Bit Shifting, 011 for Binary Logic, 100 to Fetch a Stored Value, 101 to Store A Value");
                // CHAR_ARRAY(0 to 143) := (X"30",X"30",X"30",X"20",X"66",X"6f",X"72",X"20",X"46",X"6c",X"6f",X"61",X"74",X"69",X"6e",X"67",X"20",X"50",X"6f",X"69",X"6e",X"74",X"2c",X"20",X"30",X"30",X"31",X"20",X"66",X"6f",X"72",X"20",X"42",X"69",X"6e",X"61",X"72",X"79",X"20",X"41",X"72",X"74",X"68",X"69",X"6d",X"61",X"74",X"69",X"63",X"2c",X"20",X"30",X"31",X"30",X"20",X"66",X"6f",X"72",X"20",X"42",X"69",X"74",X"20",X"53",X"68",X"69",X"66",X"74",X"69",X"6e",X"67",X"2c",X"20",X"30",X"31",X"31",X"20",X"66",X"6f",X"72",X"20",X"42",X"69",X"6e",X"61",X"72",X"79",X"20",X"4c",X"6f",X"67",X"69",X"63",X"2c",X"20",X"31",X"30",X"30",X"20",X"74",X"6f",X"20",X"46",X"65",X"74",X"63",X"68",X"20",X"61",X"20",X"53",X"74",X"6f",X"72",X"65",X"64",X"20",X"56",X"61",X"6c",X"75",X"65",X"2c",X"20",X"31",X"30",X"31",X"20",X"74",X"6f",X"20",X"53",X"74",X"6f",X"72",X"65",X"20",X"41",X"20",X"56",X"61",X"6c",X"75",X"65");
                printed <= 0;
            end else if (enable_deb == 1'b1) begin
                operation <= switches[2:0];
                state <= state+1;
                printed <= 1;
            end
        end

        3'b001:begin
            if (printed) begin
                case (operation)
                3'b000: begin
                    uart_mode <= uart_mode +1; 
                    //$display($time,"Please select an FPU operation on switches 1-0. Then press U18 to confirm the mode");
                    // CHAR_ARRAY(0 to 81) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"6e",X"20",X"46",X"50",X"55",X"20",X"6f",X"70",X"65",X"72",X"61",X"74",X"69",X"6f",X"6e",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65");
                    uart_mode <= uart_mode +1;
                    //$display("00: add. 01: sub. 10: mul. 11: div"); // op2
                    // CHAR_ARRAY(0 to 33) := (X"30",X"30",X"3a",X"20",X"61",X"64",X"64",X"2e",X"20",X"30",X"31",X"3a",X"20",X"73",X"75",X"62",X"2e",X"20",X"31",X"30",X"3a",X"20",X"6d",X"75",X"6c",X"2e",X"20",X"31",X"31",X"3a",X"20",X"64",X"69",X"76");
                end

                3'b001: begin
                    uart_mode <= uart_mode +1;
                    //$display($time,"Please select a Arthimatic Operation on switches 2-0. Then press U18 to confirm the mode");
                    // CHAR_ARRAY(0 to 87) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"41",X"72",X"74",X"68",X"69",X"6d",X"61",X"74",X"69",X"63",X"20",X"4f",X"70",X"65",X"72",X"61",X"74",X"69",X"6f",X"6e",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"32",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65");
                    uart_mode <= uart_mode +1;
                    //$display("000: add (A+B). 001: sub (A-B). 010: mul (A*B). 011: div (A/B). 100: rem (A % B)");
                    // CHAR_ARRAY(0 to 79) := (X"30",X"30",X"30",X"3a",X"20",X"61",X"64",X"64",X"20",X"28",X"41",X"2b",X"42",X"29",X"2e",X"20",X"30",X"30",X"31",X"3a",X"20",X"73",X"75",X"62",X"20",X"28",X"41",X"2d",X"42",X"29",X"2e",X"20",X"30",X"31",X"30",X"3a",X"20",X"6d",X"75",X"6c",X"20",X"28",X"41",X"2a",X"42",X"29",X"2e",X"20",X"30",X"31",X"31",X"3a",X"20",X"64",X"69",X"76",X"20",X"28",X"41",X"2f",X"42",X"29",X"2e",X"20",X"31",X"30",X"30",X"3a",X"20",X"72",X"65",X"6d",X"20",X"28",X"41",X"20",X"25",X"20",X"42",X"29");
                end

                3'b010: begin
                    uart_mode <= uart_mode +1;
                    //$display($time,"Please select a Bit Operation on switches 1-0. Then press U18 to confirm the mode");
                    // CHAR_ARRAY(0 to 80) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"42",X"69",X"74",X"20",X"4f",X"70",X"65",X"72",X"61",X"74",X"69",X"6f",X"6e",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65");
                    uart_mode <= uart_mode +1;
                    //$display("00: clear bit. 01: set bit. 10: get bit. 11: set output");
                    // CHAR_ARRAY(0 to 54) := (X"30",X"30",X"3a",X"20",X"63",X"6c",X"65",X"61",X"72",X"20",X"62",X"69",X"74",X"2e",X"20",X"30",X"31",X"3a",X"20",X"73",X"65",X"74",X"20",X"62",X"69",X"74",X"2e",X"20",X"31",X"30",X"3a",X"20",X"67",X"65",X"74",X"20",X"62",X"69",X"74",X"2e",X"20",X"31",X"31",X"3a",X"20",X"73",X"65",X"74",X"20",X"6f",X"75",X"74",X"70",X"75",X"74");
                end

                3'b011: begin
                    uart_mode <= uart_mode +1;
                    //$display($time,"Please select a Binary Logic on switches 2-0. Then press U18 to confirm the mode");
                    // CHAR_ARRAY(0 to 79) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"42",X"69",X"6e",X"61",X"72",X"79",X"20",X"4c",X"6f",X"67",X"69",X"63",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"32",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65");
                    uart_mode <= uart_mode +1;
                    //$display("000: and (A&B). 001: nand ~(A&B). 010: or (AxB). 011: nor ~(AxB). 100: xor (A ^ B)). 101: xnor ~(A ^ B). 110: not (~A)");
                    // CHAR_ARRAY(0 to 117) := (X"30",X"30",X"30",X"3a",X"20",X"61",X"6e",X"64",X"20",X"28",X"41",X"26",X"42",X"29",X"2e",X"20",X"30",X"30",X"31",X"3a",X"20",X"6e",X"61",X"6e",X"64",X"20",X"7e",X"28",X"41",X"26",X"42",X"29",X"2e",X"20",X"30",X"31",X"30",X"3a",X"20",X"6f",X"72",X"20",X"28",X"41",X"78",X"42",X"29",X"2e",X"20",X"30",X"31",X"31",X"3a",X"20",X"6e",X"6f",X"72",X"20",X"7e",X"28",X"41",X"78",X"42",X"29",X"2e",X"20",X"31",X"30",X"30",X"3a",X"20",X"78",X"6f",X"72",X"20",X"28",X"41",X"20",X"5e",X"20",X"42",X"29",X"29",X"2e",X"20",X"31",X"30",X"31",X"3a",X"20",X"78",X"6e",X"6f",X"72",X"20",X"7e",X"28",X"41",X"20",X"5e",X"20",X"42",X"29",X"2e",X"20",X"31",X"31",X"30",X"3a",X"20",X"6e",X"6f",X"74",X"20",X"28",X"7e",X"41",X"29");
                end

                3'b100: begin
                    uart_mode <= uart_mode +1;
                    //$display($time,"Store a value");
                    // CHAR_ARRAY(0 to 12) := (X"53",X"74",X"6f",X"72",X"65",X"20",X"61",X"20",X"76",X"61",X"6c",X"75",X"65");
                    uart_mode <= uart_mode +1;
                    //$display($time,"Please select either reg A (00), B (01), C (10) or D (11) by using switches 1-0");
                    // CHAR_ARRAY(0 to 78) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"65",X"69",X"74",X"68",X"65",X"72",X"20",X"72",X"65",X"67",X"20",X"41",X"20",X"28",X"30",X"30",X"29",X"2c",X"20",X"42",X"20",X"28",X"30",X"31",X"29",X"2c",X"20",X"43",X"20",X"28",X"31",X"30",X"29",X"20",X"6f",X"72",X"20",X"44",X"20",X"28",X"31",X"31",X"29",X"20",X"62",X"79",X"20",X"75",X"73",X"69",X"6e",X"67",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30");
                end

                3'b101: begin
                    uart_mode <= uart_mode +1;
                    //$display($time,"Fetch a value");
                    // CHAR_ARRAY(0 to 12) := (X"46",X"65",X"74",X"63",X"68",X"20",X"61",X"20",X"76",X"61",X"6c",X"75",X"65");
                    uart_mode <= uart_mode +1;
                    //$display("Please select either reg A (00), B (01), C (10) or D (11) by using switches 1-0");
                    // CHAR_ARRAY(0 to 78) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"65",X"69",X"74",X"68",X"65",X"72",X"20",X"72",X"65",X"67",X"20",X"41",X"20",X"28",X"30",X"30",X"29",X"2c",X"20",X"42",X"20",X"28",X"30",X"31",X"29",X"2c",X"20",X"43",X"20",X"28",X"31",X"30",X"29",X"20",X"6f",X"72",X"20",X"44",X"20",X"28",X"31",X"31",X"29",X"20",X"62",X"79",X"20",X"75",X"73",X"69",X"6e",X"67",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30");
                end
                endcase
                printed <= 0;
            end else if (enable_deb == 1'b1) begin
                op2 <= switches[2:0];
                state <= state+1;
                printed <= 1;
            end
        end 
        
        
        3'b010: begin
            if (printed) begin
                uart_mode <= uart_mode +1;
                //$display($time,"Please select a bit-size");
                // CHAR_ARRAY(0 to 23) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"62",X"69",X"74",X"2d",X"73",X"69",X"7a",X"65");
                uart_mode <= uart_mode +1;
                //$display("000 for 16-bit inputs, 001 for 32-bit inputs, 011 for 64-bit inputs");
                // CHAR_ARRAY(0 to 66) := (X"30",X"30",X"30",X"20",X"66",X"6f",X"72",X"20",X"31",X"36",X"2d",X"62",X"69",X"74",X"20",X"69",X"6e",X"70",X"75",X"74",X"73",X"2c",X"20",X"30",X"30",X"31",X"20",X"66",X"6f",X"72",X"20",X"33",X"32",X"2d",X"62",X"69",X"74",X"20",X"69",X"6e",X"70",X"75",X"74",X"73",X"2c",X"20",X"30",X"31",X"31",X"20",X"66",X"6f",X"72",X"20",X"36",X"34",X"2d",X"62",X"69",X"74",X"20",X"69",X"6e",X"70",X"75",X"74",X"73");
                printed <= 0;
            
            end else if (enable_deb == 1'b1) begin
                size_sel <= switches[1:0];
                state <= state + 1;
                printed <= 1;
            end

        end

        3'b011:begin
            if (printed) begin
                uart_mode <= uart_mode +1;
                //$display($time,"Please place input A on the switches");
                // CHAR_ARRAY(0 to 35) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"70",X"6c",X"61",X"63",X"65",X"20",X"69",X"6e",X"70",X"75",X"74",X"20",X"41",X"20",X"6f",X"6e",X"20",X"74",X"68",X"65",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73");
                printed <= 0;
                count <= 0;
            end else if ((count <= size_sel) && (enable_deb == 1'b1)) begin
                case (count)
                2'b00:  opa[15:0] = switches;
                2'b01:  opa[31:16] = switches;
                2'b10:  opa[47:31] = switches;
                2'b11:  opa[63:47] = switches;
                endcase
                count <= count+1;
            end else if (count > size_sel) begin
                if (operation == 3'b1XX || (operation == 3'b001 && op2 == 3'b101) || (operation == 3'b011 && op2 == 3'b110)) 
                    state = 3'b101;
                else
                    state = state+1;
                printed <= 1;
            end
            
        end 

        3'b100:begin
            if (printed) begin
                uart_mode <= uart_mode +1;
                //$display($time,"Please place input B on the switches");
                // CHAR_ARRAY(0 to 35) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"70",X"6c",X"61",X"63",X"65",X"20",X"69",X"6e",X"70",X"75",X"74",X"20",X"42",X"20",X"6f",X"6e",X"20",X"74",X"68",X"65",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73");
                printed <= 0;
                count <= 0;
            end else if (count <= size_sel && enable_deb == 1'b1) begin
                case (count)
                2'b00:  opb[15:0] = switches;
                2'b01:  opb[31:16] = switches;
                2'b10:  opb[47:31] = switches;
                2'b11:  opb[63:47] = switches;
                endcase
                count <= count+1;
            end else if (count > size_sel) begin
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
            3'b100:     begin
                case (op2)
                2'b00:  out <= memory[63:0];
                2'b01:  out <= memory[127:64];
                2'b10:  out <= memory[191:127];
                2'b11:  out <= memory[255:191];
                endcase
            end
            3'b101:     begin
                case (op2)
                2'b00:  memory[63:0] <= opa;
                2'b01:  memory[127:64] <= opa;
                2'b10:  memory[191:127] <= opa;
                2'b11:  memory[255:191] <= opa;
                endcase                
                out <= opa;
            end
            endcase
            case (size_sel)
            2'b00:      sign_temp = out[15];
            2'b01:      sign_temp = out[31];
            2'b11:      sign_temp = out[63];  
            endcase                      
            
            uart_mode <= uart_mode +1;
            uart_mode <= uart_mode +1;
            //$display($time,"Output = ",out);
            // CHAR_ARRAY(0 to 8) := (X"4f",X"75",X"74",X"70",X"75",X"74",X"20",X"3d",X"20");
            state <= 0;
            uart_mode <= 0;
        end 

        endcase

    end
end

assign sign = sign_temp;

endmodule
