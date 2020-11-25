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
    1. VGA Output
    2. Stack Command Queue
2. Floating Point
3. Logical Functions
4. Arithmetic Functions

### Work Assignments
Modules:
1. user should be able to perform an arithmetic operation on two floating point numbers
   1. Input number shift button to take bits into FP number (16->32->48….)
   2. 
2. user should be able to perform an arithmetic operation two integers, and have the integer addition have a higher priority than the floating point addition (preempt the floating point addition)
    1. Save for end
3. Store results in memory, or input values to be stored and used later
    1. Save for end
4. Perform exponentials, by multiplication and or bit shifting
    1. After FP
5. Display results either on the 7-seg or VGA outputs to terminal
    1. Both
6. Enter numbers in floating point format with shift register or in binary and have it convert it to floating point. 
    1. Included in first case
7. The user can input multiple operations that will be completed at a single time. These operations will be kept in a stack, and then performed in order. The next operations will be stored in a stack.
    1. After FP
    2. IE (A+B)*C would first add A and B then multiply the result by C.

