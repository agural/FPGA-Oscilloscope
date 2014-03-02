-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "02/25/2014 13:03:37"
                                                            
-- Vhdl Test Bench template for design  :  test_modelsim
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 


--
---
----
----- EXAMPLE VHDL TEST BENCH FOR 8-BIT COUNTER
-----	Use the blocks in here as a basis for 
-----	writing your own test benches. 
----
---
--

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;                                
USE ieee.std_logic_misc.all;
USE ieee.math_real.all;

ENTITY test_modelsim_vhd_tst IS
END test_modelsim_vhd_tst;



ARCHITECTURE test_modelsim_arch OF test_modelsim_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL clr : STD_LOGIC;
SIGNAL count : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL set : STD_LOGIC;
COMPONENT test_modelsim
	PORT (
	clk : IN STD_LOGIC;
	clr : IN STD_LOGIC;
	count : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	set : IN STD_LOGIC
	);
END COMPONENT;

BEGIN

	i1 : test_modelsim
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	clr => clr,
	count => count,
	set => set
	);


clock : PROCESS                                               
-- variable declarations                                     
BEGIN     

      clk <= '0';
      wait for 50 ps;
      clk <= '1';
      wait for 50 ps;  

END PROCESS clock; 

init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once  
        clr <= '0';
        set <= '0';                    
WAIT;                                                       
END PROCESS init; 


always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations
variable my_count : integer := 0;                                      
BEGIN  

	--
	-- You will find below some exmaples of how to check 
	--	that outputs are correct
	--

	-- Assertion to check that the count is correct
	assert (my_count = to_integer(unsigned(count))) report "Count incorrect";

	-- If statement to find that the count is correct
	if (my_count /= to_integer(unsigned(count))) then
		report "count incorrect" serverity ERROR;
	end if;

	-- You only want to use the to_integer(unsigned(x)) wrapper if
	--	you are trying to look at something which represents a number.
	-- 
	-- If you are checking a one-bit std_logic signal, you want to use something
	--	that looks like
	assert (clr = '0') report "Clear is incorrect";
	--
	-- If you are looking at a std_logic_vector, then you want to use a string
	--	of bits for comparison which would look something like
	assert(count = "11111111") report "count is not 255";

	-- If you want to get more advanced, you can try to match only certain
	--	bits of a std_logic_vector using the std_match operator, where '-'
	--	in a bit string represents a 'don't care'. The code below will only
	--	check that bits 0, 6 and 7 are '1' and doesn't care about the rest of them.
	assert(std_match(count, "11-----1")) report "bits 7, 6, and 0 of count are not set";

	-- If you want to concatenate several signals into one assertion, you can do 
	--	so using the '&' operator
	assert( (set&clr) = "00") report "either set or clear is set";

	my_count := (my_count + 1) mod 256;

	wait for 100 ps;                                                       

END PROCESS always;                                          
END test_modelsim_arch;

--
-- NOTE about adding randomness to test benches. 
--

--	ALWAYS explicitly write out your edge cases and add randomness
--		if you want as further testing. RANDOMNESS IS NOT AN EXCUSE
--		TO NOT WRITE OUT ESGE CASES. Randomness is a supplement, 
--		not a solution. 
--
--  With that being said, if you want to use VHDL's built-in random
--		number generation, you can do so by adding the following code
--		to your variables section in a process:
        variable seed1, seed2 : positive;
    	variable rand, rand_in_range : real;
--
--	And the following code within your process to create the random 
--		number. You will need to fill in constants for max_val and
--		min_val, and as a note, if you want max_val to be 
--		50 and the min_val to be 10, you need to write them 
--		as 50.0 and 10.0, not 50 and 10 in the code. This is 
--		because they are being used as "real" types, and "real"
--		types require a specification of a decimal value in VHDL.

            -- Get a random value on the interval [0,1].
            UNIFORM(seed1, seed2, rand);
            -- Map the random value to [min_val, max_val]
            rand_in_range := rand*(max_val - min_val) + min_val;
