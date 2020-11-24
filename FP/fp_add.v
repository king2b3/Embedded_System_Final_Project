// Bayley King
// Embedded Systems final project
// Single point FP (32-bit)

`timescale 1ns / 100ps

module fpu_add( clk, rst, enable, opa, opb, sign, sum_2, exponent_2);
input		clk;
input		rst;
input		enable;
input	[31:0]	opa, opb;
output		sign;
output  [55:0]	sum_2;      // what size?  4 higher than the mantisa 
output	[7:0]	exponent_2;

// compare exponents, make them the same
    // change mantisa 

reg [9:0] exponent_a <= opa[30:20];
reg	[9:0] exponent_b <= opb[30:20];
reg	[9:0] mantissa_a <= opa[19:0];
reg [9:0] mantissa_b <= opb[19:0];
reg [9:0] exp_add;
wire [9:0] pad;

always @ (clk) begin
    
    if (exponent_a > exponent_b) begin
        pad = exponent_a - exponent_b;
        exponent_b = exponent_b >> pad;
        mantisa_b = mantisa_b >> pad;
    end else if (exponent_b > exponent_a) begin
        exponent_a <= exponent_a >> (exponent_b - exponent_a);
    end
    exp_add = exponent_a + exponent_b;




end
