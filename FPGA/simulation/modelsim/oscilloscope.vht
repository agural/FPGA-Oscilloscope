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
-- Generated on "03/04/2014 04:13:26"
                                                            
-- Vhdl Test Bench template for design  :  oscilloscope
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;    
USE ieee.numeric_std.all;                                
USE ieee.std_logic_misc.all;
USE ieee.math_real.all;                            

ENTITY oscilloscope_vhd_tst IS
END oscilloscope_vhd_tst;

ARCHITECTURE oscilloscope_arch OF oscilloscope_vhd_tst IS
	-- constants                                                 
	-- signals                                                   
	SIGNAL CLK_IN 	: STD_LOGIC;
	SIGNAL RESET_IN : STD_LOGIC;
	SIGNAL DCLK 	: STD_LOGIC;
	SIGNAL HSYNC 	: STD_LOGIC;
	SIGNAL SC 		: STD_LOGIC;
	SIGNAL SRT 		: STD_LOGIC;
	SIGNAL VSYNC 	: STD_LOGIC;

	COMPONENT oscilloscope
		PORT (
			CLK_IN 		: IN  STD_LOGIC;
			RESET_IN 	: IN  STD_LOGIC;
			DCLK 		: OUT STD_LOGIC;
			HSYNC 		: OUT STD_LOGIC;
			SC 			: OUT STD_LOGIC;
			SRT 		: OUT STD_LOGIC;
			VSYNC 		: OUT STD_LOGIC
		);
	END COMPONENT;

	BEGIN
		i1 : oscilloscope
		PORT MAP (
			-- list connections between master ports and signals
			CLK_IN => CLK_IN,
			RESET_IN => RESET_IN,
			DCLK => DCLK,
			HSYNC => HSYNC,
			SC => SC,
			SRT => SRT,
			VSYNC => VSYNC
		);


	clock : PROCESS                                               
		-- variable declarations
		variable go : integer := 1;                                     
		--constant syshalfclk : integer := 50;
		BEGIN     
			if (go = 1) then
		    	CLK_IN <= '1';
		    	wait for 50 ps;
		    	CLK_IN <= '0';
		    	wait for 50 ps;
		    end if;
	END PROCESS clock; 


	init : PROCESS                                               
		-- variable declarations                                     
		BEGIN                                                        
		        -- code that executes only once                      
		        RESET_IN <= '1';
		        wait for 400 ps;
		        RESET_IN <= '0';
		WAIT;                                                       
	END PROCESS init;                                           


	always : PROCESS                                              
		-- optional sensitivity list                                  
		-- (        )                                                 
		-- variable declarations                                 
		variable h_count		: integer := 0; -- For current horizontal display
		variable h_pulse_cnt	: integer := 0; -- Counts horizontal pulses
		variable v_count		: integer := 0; -- For current vertical display
		variable v_pulse_cnt	: integer := 0; -- Counts vertical pulses

		constant h_pulse		: integer :=  41; -- Expected horizontal pulse length
		constant h_back_porch	: integer :=  43; -- Expected horizontal back porch
		constant h_front_porch	: integer := 523; -- Expected horizontal front porch
		constant v_pulse		: integer :=  10; -- Expected vertical pulse length
		constant v_back_porch	: integer :=  12; -- Expected vertical back porch
		constant v_front_porch	: integer := 284; -- Expected vertical front porch

		--constant vramhalfclk	: integer := 200;
		--constant offset			: integer := 400;

		BEGIN                                                         
		    -- code executes for every event on sensitivity list
		    wait for 801 ps;
		    while true loop
			    for row in 0 to 285 loop
			    	for col in 0 to 524 loop
			    		if (row < v_pulse) then
			    			assert(VSYNC = '0') report "VSYNC sync not low during vertical pulse";
			    		else
			    			assert(VSYNC = '1') report "VSYNC sync not high during non-pulse";
			    		end if;

			    		if (col < h_pulse) then
			    			assert(HSYNC = '0') report "HSYNC sync not low during horizontal pulse";
			    		else
			    			assert(HSYNC = '1') report "HSYNC sync not high during non-pulse";
			    		end if;

			    		assert(DCLK = '1') report "DCLK not high when expected";
			    		
			    		if (v_back_porch <= row and row < v_front_porch and
			    			h_back_porch <= col and col < h_front_porch) then
			    			assert(SC = '1') report "SC not high when expected";
			    		end if;
			    		
			    		if (v_back_porch <= row and row < v_front_porch and
			    			col = h_front_porch) then
			    			assert(SRT = '1') report "Serial transfer not triggering as expected";
			    		else
			    			assert(SRT = '0') report "Serial transfer triggering unexpectedly";
			    		end if;

			    		wait for 200 ps;

			    		
			    		assert(DCLK = '0') report "DCLK not low when expected";
			    		
			    		assert(SC = '0') report "SC not low when expected";
			    		
			    		wait for 200 ps;
			    	
			    	end loop;
			    end loop;
			end loop;
	END PROCESS always;                                          

END oscilloscope_arch;
