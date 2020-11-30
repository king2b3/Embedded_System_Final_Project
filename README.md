# Embedded_System_Final_Project

Final project for Zack Hadden, Bryan Kanu and Bayley King for Embedded Systems EECE 6017C.

### File Structure Layout
Final structure will be different, we'll need to have all the verilog files and the wrapper within the same folder. For now though, since we are still testing individual components we can keep everything separated.

1. double_fpu
   1. Contains floating point files from open core
2. final
   1. Vivado project for final project
3. GPIO
   1. clone of source repo for diligent's I/O tutorials
4. norm_logic
   1. Brian's code for normal arithmetic, logic functions, and bit manipulations
5. uart_try
   1. Vivado project to test UART code from GPIO


### Module Plans
1. Wrapper
   1. Floating Point
   2. Logical Functions
   3. Arithmetic Functions
   4. Bit Manipulation

### Work Assignments
1. Let user select rounding mode for FP
2. Test code
3. Clear exceptions / other FPU out LEDS on other op selection
   1. Change these in state 2?
4. Stack Queue? 