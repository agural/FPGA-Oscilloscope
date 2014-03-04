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
-- Generated on "03/04/2014 13:51:33"
                                                            
-- Vhdl Test Bench template for design  :  oscilloscope
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
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
	SIGNAL CS_IN 	: STD_LOGIC;
	SIGNAL RW_IN 	: STD_LOGIC;
	SIGNAL HSYNC_IN : STD_LOGIC;
	SIGNAL SRT_IN 	: STD_LOGIC;
	SIGNAL ADDR 	: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL RAS 		: STD_LOGIC;
	SIGNAL CAS 		: STD_LOGIC;
	SIGNAL TRG 		: STD_LOGIC;
	SIGNAL WE 		: STD_LOGIC;
	SIGNAL BUSY		: STD_LOGIC;

	COMPONENT oscilloscope
		PORT (
			CLK_IN 		: IN  STD_LOGIC;
			RESET_IN 	: IN  STD_LOGIC;
			CS_IN 		: IN  STD_LOGIC;
			RW_IN 		: IN  STD_LOGIC;
			HSYNC_IN 	: IN  STD_LOGIC;
			SRT_IN 		: IN  STD_LOGIC;
			ADDR 		: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			RAS 		: OUT STD_LOGIC;
			CAS 		: OUT STD_LOGIC;
			TRG 		: OUT STD_LOGIC;
			WE 			: OUT STD_LOGIC
		);
	END COMPONENT;

	BEGIN
		i1 : oscilloscope
		PORT MAP (
			-- list connections between master ports and signals
			CLK_IN 		=> CLK_IN,
			RESET_IN 	=> RESET_IN,
			CS_IN 		=> CS_IN,
			RW_IN 		=> RW_IN,
			HSYNC_IN 	=> HSYNC_IN,
			SRT_IN 		=> SRT_IN,
			ADDR 		=> ADDR,
			RAS 		=> RAS,
			CAS 		=> CAS,
			TRG 		=> TRG,
			WE 			=> WE
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
		        CS_IN <= '0';
		        RW_IN <= '0';
		        HSYNC_IN <= '0';
		        SRT_IN <= '0';

		        RESET_IN <= '1';
		        wait for 100 ps;
		        RESET_IN <= '0';
		WAIT;                                                       
	END PROCESS init;   


	always : PROCESS                                              
		-- optional sensitivity list                                  
		-- (        )                                                 
		-- variable declarations                                      
		constant crit_time_min	: integer := 0;
		constant crit_time_max 	: integer := 15;


		BEGIN                                                         
		    -- code executes for every event on sensitivity list  
		    CS_IN <= '0';
		    RW_IN <= '0';
		    HSYNC_IN <= '0';
		    SRT_IN <= '0';
		    
		    for read_time in crit_time_min to crit_time_max loop
		    	for write_time in crit_time_min to crit_time_max loop
		       		for srt_time in crit_time_min to crit_time_max loop
		       			for t in 0 to crit_time_max-1 loop
		       				if (t = read_time) then
		       					CS_IN <= '1';
		       					RW_IN <= '1';
		       				elsif (t = write_time) then
		       					CS_IN <= '1';
		       					RW_IN <= '0';
		       				end if;

		       				if (BUSY = '0') then -- Processor gets data and releases CS/RW
		       					CS_IN <= '0';
		       					RW_IN <= '0';
		       				end if;

		       				if (t = srt_time) then
		       					SRT_IN <= '1';
		       				else
		       					SRT_IN <= '0';
		       				end if;

		       				wait for 100 ps;
		       			end loop;
		       			
		       			HSYNC_IN <= '1'; -- Increment SRT address
		       			wait for 100 ps;
		       			HSYNC_IN <= '0';
		       		end loop;
		       	end loop;
		    end loop;

	END PROCESS always;

END oscilloscope_arch;
