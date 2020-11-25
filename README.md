# Embedded_System_Final_Project

Final project for Zach Hadden, Bryan Kanu and Bayley King for Embedded Systems EECE 6017C.

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
    1. VGA Output
    2. Stack Command Queue
2. Floating Point
3. Logical Functions
4. Arithmetic Functions

### Work Assignments
Modules:
1. user can input numbers either 16, 32 or 64 bits.
   1. Need to use temp registers
2. Store results in memory, or input values to be stored and used later
   1. More set registers on board. Define set of memory, allow the user to call it
3. Display results either on the 7-seg or VGA outputs to terminal
    1. For now use $display, we will give UART another try though. Also follow up with Chris on VGA
4. The user can input multiple operations that will be completed at a single time. These operations will be kept in a stack, and then performed in order. The next operations will be stored in a stack.
    1. IE (A+B)*C would first add A and B then multiply the result by C.
5. the integer addition have a higher priority than the floating point addition (preempt the floating point addition)
