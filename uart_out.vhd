--       *Note that the center user button behaves as a user reset button
--        and is referred to as such in the code comments below
--       *A test pattern is displayed on the VGA port at 1280x1024 resolution.
--        If a mouse is attached to the USB-HID port, a cursor can be moved
--        around the pattern.
--        
--	All UART communication can be captured by attaching the UART port to a
-- computer running a Terminal program with 9600 Baud Rate, 8 data bits, no 
-- parity, and 1 stop bit.																
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


--The IEEE.std_logic_unsigned contains definitions that allow 
--std_logic_vector types to be used with the + operator to instantiate a 
--counter.
use IEEE.std_logic_unsigned.all;

entity uart_out is
    Port (
        inA 			: in  integer;
        enable 			: in  STD_LOGIC;
        CLK 			: in  STD_LOGIC;
        mode            : in integer;
        UART_TXD 	: out  STD_LOGIC
			  );
end uart_out;

architecture Behavioral of uart_out is

component UART_TX_CTRL
Port(
	SEND : in std_logic;
	DATA : in std_logic_vector(7 downto 0);
	CLK : in std_logic;          
	READY : out std_logic;
	UART_TX : out std_logic
	);
end component;

component debouncer_2
Generic(
        DEBNC_CLOCKS : integer;
        PORT_WIDTH : integer);
Port(
		SIGNAL_I : in std_logic;
		CLK_I : in std_logic;          
		SIGNAL_O : out std_logic
		);
end component;

type UART_STATE_TYPE is (RST_REG, LD_INIT_STR, SEND_CHAR, RDY_LOW, WAIT_RDY, WAIT_BTN, LD_BTN_STR);

type CHAR_ARRAY is array (integer range<>) of std_logic_vector(7 downto 0);

signal inA_mod : STD_LOGIC_VECTOR (63 downto 0);

constant TMR_CNTR_MAX : std_logic_vector(26 downto 0) := "101111101011110000100000000"; --100,000,000 = clk cycles per second
constant TMR_VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9
constant RESET_CNTR_MAX : std_logic_vector(17 downto 0) := "110000110101000000";-- 100,000,000 * 0.002 = 200,000 = clk cycles per 2 ms

constant MAX_STR_LEN : integer := 230;
constant OUTA_STR_LEN : natural := 64;

------------------------
-- HARDCODED MESSAGES --
------------------------

-- Please select a mode on swithces 2-0. Press button U18 when the mode is selected
-- 000 for Floating Point, 001 for Binary Arthimatic, 010 for Bit Shifting, 011 for Binary Logic, 100 to Fetch a Stored Value, 101 to Store A Value
constant in_0 : CHAR_ARRAY(0 to 229) := (X"0A",X"0D",X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"6d",X"6f",X"64",X"65",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"68",X"63",X"65",X"73",X"20",X"32",X"2d",X"30",X"2e",X"20",X"50",X"72",X"65",X"73",X"73",X"20",X"62",X"75",X"74",X"74",X"6f",X"6e",X"20",X"55",X"31",X"38",X"20",X"77",X"68",X"65",X"6e",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65",X"20",X"69",X"73",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"65",X"64",X"0A",X"0D",X"30",X"30",X"30",X"20",X"66",X"6f",X"72",X"20",X"46",X"6c",X"6f",X"61",X"74",X"69",X"6e",X"67",X"20",X"50",X"6f",X"69",X"6e",X"74",X"2c",X"20",X"30",X"30",X"31",X"20",X"66",X"6f",X"72",X"20",X"42",X"69",X"6e",X"61",X"72",X"79",X"20",X"41",X"72",X"74",X"68",X"69",X"6d",X"61",X"74",X"69",X"63",X"2c",X"20",X"30",X"31",X"30",X"20",X"66",X"6f",X"72",X"20",X"42",X"69",X"74",X"20",X"53",X"68",X"69",X"66",X"74",X"69",X"6e",X"67",X"2c",X"20",X"30",X"31",X"31",X"20",X"66",X"6f",X"72",X"20",X"42",X"69",X"6e",X"61",X"72",X"79",X"20",X"4c",X"6f",X"67",X"69",X"63",X"2c",X"20",X"31",X"30",X"30",X"20",X"74",X"6f",X"20",X"46",X"65",X"74",X"63",X"68",X"20",X"61",X"20",X"53",X"74",X"6f",X"72",X"65",X"64",X"20",X"56",X"61",X"6c",X"75",X"65",X"2c",X"20",X"31",X"30",X"31",X"20",X"74",X"6f",X"20",X"53",X"74",X"6f",X"72",X"65",X"20",X"41",X"20",X"56",X"61",X"6c",X"75",X"65",X"0A",X"0D");
constant in_0_str_len : natural := 230;

-- Please select an FPU operation on switches 1-0. Then press U18 to confirm the mode
-- 00: add. 01: sub. 10: mul. 11: div
constant in_1 : CHAR_ARRAY(0 to 119) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"6e",X"20",X"46",X"50",X"55",X"20",X"6f",X"70",X"65",X"72",X"61",X"74",X"69",X"6f",X"6e",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65",X"0A",X"0D",X"30",X"30",X"3a",X"20",X"61",X"64",X"64",X"2e",X"20",X"30",X"31",X"3a",X"20",X"73",X"75",X"62",X"2e",X"20",X"31",X"30",X"3a",X"20",X"6d",X"75",X"6c",X"2e",X"20",X"31",X"31",X"3a",X"20",X"64",X"69",X"76",X"0A",X"0D");
constant in_1_str_len : natural := 120;

-- Please select a Arthimatic Operation on switches 2-0. Then press U18 to confirm the mode
-- 000: add (A+B). 001: sub (A-B). 010: mul (A*B). 011: div (A/B). 100: rem (A % B)
constant in_2 : CHAR_ARRAY(0 to 171) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"41",X"72",X"74",X"68",X"69",X"6d",X"61",X"74",X"69",X"63",X"20",X"4f",X"70",X"65",X"72",X"61",X"74",X"69",X"6f",X"6e",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"32",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65",X"0A",X"0D",X"30",X"30",X"30",X"3a",X"20",X"61",X"64",X"64",X"20",X"28",X"41",X"2b",X"42",X"29",X"2e",X"20",X"30",X"30",X"31",X"3a",X"20",X"73",X"75",X"62",X"20",X"28",X"41",X"2d",X"42",X"29",X"2e",X"20",X"30",X"31",X"30",X"3a",X"20",X"6d",X"75",X"6c",X"20",X"28",X"41",X"2a",X"42",X"29",X"2e",X"20",X"30",X"31",X"31",X"3a",X"20",X"64",X"69",X"76",X"20",X"28",X"41",X"2f",X"42",X"29",X"2e",X"20",X"31",X"30",X"30",X"3a",X"20",X"72",X"65",X"6d",X"20",X"28",X"41",X"20",X"25",X"20",X"42",X"29",X"0A",X"0D");
constant in_2_str_len : natural := 172;

-- Please select a Bit Operation on switches 1-0. Then press U18 to confirm the mode
-- 00: clear bit. 01: set bit. 10: get bit. 11: set output
constant in_3 : CHAR_ARRAY(0 to 139) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"42",X"69",X"74",X"20",X"4f",X"70",X"65",X"72",X"61",X"74",X"69",X"6f",X"6e",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65",X"0A",X"0D",X"30",X"30",X"3a",X"20",X"63",X"6c",X"65",X"61",X"72",X"20",X"62",X"69",X"74",X"2e",X"20",X"30",X"31",X"3a",X"20",X"73",X"65",X"74",X"20",X"62",X"69",X"74",X"2e",X"20",X"31",X"30",X"3a",X"20",X"67",X"65",X"74",X"20",X"62",X"69",X"74",X"2e",X"20",X"31",X"31",X"3a",X"20",X"73",X"65",X"74",X"20",X"6f",X"75",X"74",X"70",X"75",X"74",X"0A",X"0D");
constant in_3_str_len : natural := 140;

-- Please select a Binary Logic on switches 2-0. Then press U18 to confirm the mode
-- 000: and (A&B). 001: nand ~(A&B). 010: or (AxB). 011: nor ~(AxB). 100: xor (A ^ B)). 101: xnor ~(A ^ B). 110: not (~A)
constant in_4 : CHAR_ARRAY(0 to 201) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"42",X"69",X"6e",X"61",X"72",X"79",X"20",X"4c",X"6f",X"67",X"69",X"63",X"20",X"6f",X"6e",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"32",X"2d",X"30",X"2e",X"20",X"54",X"68",X"65",X"6e",X"20",X"70",X"72",X"65",X"73",X"73",X"20",X"55",X"31",X"38",X"20",X"74",X"6f",X"20",X"63",X"6f",X"6e",X"66",X"69",X"72",X"6d",X"20",X"74",X"68",X"65",X"20",X"6d",X"6f",X"64",X"65",X"0A",X"0D",X"30",X"30",X"30",X"3a",X"20",X"61",X"6e",X"64",X"20",X"28",X"41",X"26",X"42",X"29",X"2e",X"20",X"30",X"30",X"31",X"3a",X"20",X"6e",X"61",X"6e",X"64",X"20",X"7e",X"28",X"41",X"26",X"42",X"29",X"2e",X"20",X"30",X"31",X"30",X"3a",X"20",X"6f",X"72",X"20",X"28",X"41",X"78",X"42",X"29",X"2e",X"20",X"30",X"31",X"31",X"3a",X"20",X"6e",X"6f",X"72",X"20",X"7e",X"28",X"41",X"78",X"42",X"29",X"2e",X"20",X"31",X"30",X"30",X"3a",X"20",X"78",X"6f",X"72",X"20",X"28",X"41",X"20",X"5e",X"20",X"42",X"29",X"29",X"2e",X"20",X"31",X"30",X"31",X"3a",X"20",X"78",X"6e",X"6f",X"72",X"20",X"7e",X"28",X"41",X"20",X"5e",X"20",X"42",X"29",X"2e",X"20",X"31",X"31",X"30",X"3a",X"20",X"6e",X"6f",X"74",X"20",X"28",X"7e",X"41",X"29",X"0A",X"0D");
constant in_4_str_len : natural := 202;

-- Store a value
-- Please select either reg A (00), B (01), C (10) or D (11) by using switches 1-0
constant in_5 : CHAR_ARRAY(0 to 95) := (X"53",X"74",X"6f",X"72",X"65",X"20",X"61",X"20",X"76",X"61",X"6c",X"75",X"65",X"0A",X"0D",X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"65",X"69",X"74",X"68",X"65",X"72",X"20",X"72",X"65",X"67",X"20",X"41",X"20",X"28",X"30",X"30",X"29",X"2c",X"20",X"42",X"20",X"28",X"30",X"31",X"29",X"2c",X"20",X"43",X"20",X"28",X"31",X"30",X"29",X"20",X"6f",X"72",X"20",X"44",X"20",X"28",X"31",X"31",X"29",X"20",X"62",X"79",X"20",X"75",X"73",X"69",X"6e",X"67",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30",X"0A",X"0D");
constant in_5_or_6_str_len : natural := 96;

-- Fetch a value
-- Please select either reg A (00), B (01), C (10) or D (11) by using switches 1-0
constant in_6 : CHAR_ARRAY(0 to 95) := (X"46",X"65",X"74",X"63",X"68",X"20",X"61",X"20",X"76",X"61",X"6c",X"75",X"65",X"0A",X"0D",X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"65",X"69",X"74",X"68",X"65",X"72",X"20",X"72",X"65",X"67",X"20",X"41",X"20",X"28",X"30",X"30",X"29",X"2c",X"20",X"42",X"20",X"28",X"30",X"31",X"29",X"2c",X"20",X"43",X"20",X"28",X"31",X"30",X"29",X"20",X"6f",X"72",X"20",X"44",X"20",X"28",X"31",X"31",X"29",X"20",X"62",X"79",X"20",X"75",X"73",X"69",X"6e",X"67",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"20",X"31",X"2d",X"30",X"0A",X"0D");

-- Please select a bit-size
-- 000 for 16-bit inputs, 001 for 32-bit inputs, 011 for 64-bit inputs
constant in_7 : CHAR_ARRAY(0 to 94) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"73",X"65",X"6c",X"65",X"63",X"74",X"20",X"61",X"20",X"62",X"69",X"74",X"2d",X"73",X"69",X"7a",X"65",X"0A",X"0D",X"30",X"30",X"30",X"20",X"66",X"6f",X"72",X"20",X"31",X"36",X"2d",X"62",X"69",X"74",X"20",X"69",X"6e",X"70",X"75",X"74",X"73",X"2c",X"20",X"30",X"30",X"31",X"20",X"66",X"6f",X"72",X"20",X"33",X"32",X"2d",X"62",X"69",X"74",X"20",X"69",X"6e",X"70",X"75",X"74",X"73",X"2c",X"20",X"30",X"31",X"31",X"20",X"66",X"6f",X"72",X"20",X"36",X"34",X"2d",X"62",X"69",X"74",X"20",X"69",X"6e",X"70",X"75",X"74",X"73",X"0A",X"0D");
constant in_7_str_len : natural := 95;

-- Please place input A on the switches
constant in_8 : CHAR_ARRAY(0 to 37) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"70",X"6c",X"61",X"63",X"65",X"20",X"69",X"6e",X"70",X"75",X"74",X"20",X"41",X"20",X"6f",X"6e",X"20",X"74",X"68",X"65",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"0A",X"0D");
constant in_8_or_9_str_len : natural := 38;

-- Please place input B on the switches
constant in_9 : CHAR_ARRAY(0 to 37) := (X"50",X"6c",X"65",X"61",X"73",X"65",X"20",X"70",X"6c",X"61",X"63",X"65",X"20",X"69",X"6e",X"70",X"75",X"74",X"20",X"42",X"20",X"6f",X"6e",X"20",X"74",X"68",X"65",X"20",X"73",X"77",X"69",X"74",X"63",X"68",X"65",X"73",X"0A",X"0D");

-- Output = 
constant in_10 : CHAR_ARRAY(0 to 10) := (X"4f",X"75",X"74",X"70",X"75",X"74",X"20",X"3d",X"20",X"0A",X"0D");
constant in_10_str_len : natural := 11;

-- Input you message: Hello, and welcome! This is our final project for Embedded Systems. - Zach, Bryan and Bayley
constant in_11 : CHAR_ARRAY(0 to 93) := (X"48",X"65",X"6c",X"6c",X"6f",X"2c",X"20",X"61",X"6e",X"64",X"20",X"77",X"65",X"6c",X"63",X"6f",X"6d",X"65",X"21",X"20",X"54",X"68",X"69",X"73",X"20",X"69",X"73",X"20",X"6f",X"75",X"72",X"20",X"66",X"69",X"6e",X"61",X"6c",X"20",X"70",X"72",X"6f",X"6a",X"65",X"63",X"74",X"20",X"66",X"6f",X"72",X"20",X"45",X"6d",X"62",X"65",X"64",X"64",X"65",X"64",X"20",X"53",X"79",X"73",X"74",X"65",X"6d",X"73",X"2e",X"20",X"2d",X"20",X"5a",X"61",X"63",X"68",X"2c",X"20",X"42",X"72",X"79",X"61",X"6e",X"20",X"61",X"6e",X"64",X"20",X"42",X"61",X"79",X"6c",X"65",X"79",X"0A",X"0D");
constant in_11_str_len : natural := 94;

-------------------------------
-- END OF HARDCODED MESSAGES --
-------------------------------

--constant outA : CHAR_ARRAY(0 to 29) := (X"54",X"61",X"6b",X"65",X"20",X"74",X"68",X"61",X"74",X"20",X"56",X"47",X"41",X"2c",X"20",X"55",X"41",X"52",X"54",X"20",X"74",X"69",X"6c",X"6c",X"20",X"49",X"20",X"64",X"69",X"65");
signal outA : CHAR_ARRAY(0 to 63); 														  
--signal inA : std_logic_vector(63 downto 0); -- pull in the input

--Contains the current string being sent over uart.
signal sendStr : CHAR_ARRAY(0 to (MAX_STR_LEN - 1));

--Contains the length of the current string being sent over uart.
signal strEnd : natural;

--Contains the index of the next character to be sent over uart
--within the sendStr variable.
signal strIndex : natural;

--Used to determine when a button press has occured
signal btnReg : std_logic := '0';
signal btnDetect : std_logic;

--UART_TX_CTRL control signals
signal uartRdy : std_logic := '1';
signal uartSend : std_logic := '1';
signal uartData : std_logic_vector (7 downto 0):= "00000000";
signal uartTX : std_logic;

--Current uart state signal
signal uartState : UART_STATE_TYPE := RST_REG;

--this counter counts the amount of time paused in the UART reset state
signal reset_cntr : std_logic_vector (17 downto 0) := (others=>'0');

signal btnDeBnc : std_logic;

begin

----------------------------------------------------------
------              Button Control                 -------
----------------------------------------------------------
--Buttons are debounced and their rising edges are detected
--to trigger UART messages

--Debounces btn signals
Inst_btn_debounce: debouncer_2
    generic map(
        DEBNC_CLOCKS => (2**16),
        PORT_WIDTH => 1)
    port map(
		SIGNAL_I => enable,
		CLK_I => CLK,
		SIGNAL_O => btnDeBnc
	);

--Registers the debounced button signals, for edge detection.
btn_reg_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		btnReg <= btnDeBnc;
	end if;
end process;

--btnDetect goes high for a single clock cycle when a btn press is
--detected. This triggers a UART message to begin being sent.
btnDetect <= '1' when (btnReg='0' and btnDeBnc='1') else
				  '0';




----------------------------------------------------------
------              UART Control                   -------
----------------------------------------------------------
--Messages are sent on reset and when a button is pressed.

--This counter holds the UART state machine in reset for ~2 milliseconds. This
--will complete transmission of any byte that may have been initiated during 
--FPGA configuration due to the UART_TX line being pulled low, preventing a 
--frame shift error from occuring during the first message.
process(CLK)
begin
  if (rising_edge(CLK)) then
    if ((reset_cntr = RESET_CNTR_MAX) or (uartState /= RST_REG)) then
      reset_cntr <= (others=>'0');
    else
      reset_cntr <= reset_cntr + 1;
    end if;
  end if;
end process;

--Next Uart state logic (states described above)
next_uartState_process : process (CLK)
begin
	if (rising_edge(CLK)) then
        case uartState is 
        when RST_REG =>
            if (reset_cntr = RESET_CNTR_MAX) then
                uartState <= LD_INIT_STR;
            end if;
        when LD_INIT_STR =>
            uartState <= SEND_CHAR;
        when SEND_CHAR =>
            uartState <= RDY_LOW;
        when RDY_LOW =>
            uartState <= WAIT_RDY;
        when WAIT_RDY =>
            if (uartRdy = '1') then
                if (strEnd = strIndex) then
                    uartState <= WAIT_BTN;
                else
                    uartState <= SEND_CHAR;
                end if;
            end if;
        
        when WAIT_BTN =>
            if (btnDetect = '1') then
                uartState <= LD_BTN_STR;
            end if;
        when LD_BTN_STR =>
            uartState <= SEND_CHAR;
        when others=> --should never be reached
            uartState <= RST_REG;
        end case;
	end if;
end process;

-- Converts the output into a character array
uart_convert : process (CLK)
begin
    if (rising_edge(CLK)) then
        inA_mod <= std_logic_vector(to_unsigned(inA, OUTA_STR_LEN));
        for i in 0 to 63 loop
            if inA_mod(i) = '1' then
                outA(i) <= X"31"; -- One
            else 
                outA(i) <= X"30"; -- Zero
            end if;
        end loop;
    end if;
end process;

--Loads the sendStr and strEnd signals when a LD state is
--is reached.
string_load_process : process (CLK)
begin
    if (rising_edge(CLK)) then
        if (uartState = LD_INIT_STR) then
            sendStr(0 to 93) <= in_11;
            strEnd <= in_11_str_len;
        
            elsif (uartState = LD_BTN_STR) then
            case mode is
                when 	 0  => 
                    sendStr(0 to 229) <= in_0; 
                    strEnd <= in_0_str_len; 
                when 	 1  =>
                    sendStr(0 to 119) <= in_1; 
                    strEnd <= in_1_str_len; 
                when 	 2  =>
                    sendStr(0 to 171) <= in_2; 
                    strEnd <= in_2_str_len; 
                when 	 3  =>
                    sendStr(0 to 139) <= in_3; 
                    strEnd <= in_3_str_len; 
                when 	 4  =>
                    sendStr(0 to 201) <= in_4; 
                    strEnd <= in_4_str_len; 
                when 	 5  =>
                    sendStr(0 to 95) <= in_5; 
                    strEnd <= in_5_or_6_str_len; 
                when 	 6  =>
                    sendStr(0 to 95) <= in_6;
                    strEnd <= in_5_or_6_str_len; 
                when 	 7  =>
                    sendStr(0 to 94) <= in_7; 
                    strEnd <= in_7_str_len; 
                when 	 8  =>
                    sendStr(0 to 37) <= in_8; 
                    strEnd <= in_8_or_9_str_len;
                when 	 9  =>
                    sendStr(0 to 37) <= in_9; 
                    strEnd <= in_8_or_9_str_len;
                when 	 10 =>
                    sendStr(0 to 10) <= in_10; 
                    strEnd <= in_10_str_len;
                when 	 11 =>
                    sendStr(0 to 93) <= in_11; 
                    strEnd <= in_11_str_len;
                when others =>
                    sendStr(0 to 63) <= outA; --  result;
                    strEnd <= OUTA_STR_LEN; --result;
            end case;
        end if;
	end if;
end process;

--Conrols the strIndex signal so that it contains the index
--of the next character that needs to be sent over uart
char_count_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (uartState = LD_INIT_STR or uartState = LD_BTN_STR) then
			strIndex <= 0;
		elsif (uartState = SEND_CHAR) then
			strIndex <= strIndex + 1;
		end if;
	end if;
end process;

--Controls the UART_TX_CTRL signals
char_load_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		if (uartState = SEND_CHAR) then
			uartSend <= '1';
			uartData <= sendStr(strIndex);
		else
			uartSend <= '0';
		end if;
	end if;
end process;

--Component used to send a byte of data over a UART line.
Inst_UART_TX_CTRL: UART_TX_CTRL port map(
		SEND => uartSend,
		DATA => uartData,
		CLK => CLK,
		READY => uartRdy,
		UART_TX => uartTX 
	);

UART_TXD <= uartTX;

end Behavioral;
