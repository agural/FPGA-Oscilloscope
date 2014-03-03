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
-- Generated on "03/02/2014 16:43:54"
                                                            
-- Vhdl Test Bench template for design  :  oscilloscope
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY oscilloscope_vhd_tst IS
END oscilloscope_vhd_tst;
ARCHITECTURE oscilloscope_arch OF oscilloscope_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ADDR : STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL CAS : STD_LOGIC;
SIGNAL DCLK : STD_LOGIC;
SIGNAL HSYNC : STD_LOGIC;
SIGNAL RAS : STD_LOGIC;
SIGNAL SC : STD_LOGIC;
SIGNAL TRG : STD_LOGIC;
SIGNAL VSYNC : STD_LOGIC;
SIGNAL WE : STD_LOGIC;
COMPONENT oscilloscope
	PORT (
	ADDR : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0);
	CAS : BUFFER STD_LOGIC;
	DCLK : BUFFER STD_LOGIC;
	HSYNC : BUFFER STD_LOGIC;
	RAS : BUFFER STD_LOGIC;
	SC : BUFFER STD_LOGIC;
	TRG : BUFFER STD_LOGIC;
	VSYNC : BUFFER STD_LOGIC;
	WE : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : oscilloscope
	PORT MAP (
-- list connections between master ports and signals
	ADDR => ADDR,
	CAS => CAS,
	DCLK => DCLK,
	HSYNC => HSYNC,
	RAS => RAS,
	SC => SC,
	TRG => TRG,
	VSYNC => VSYNC,
	WE => WE
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END oscilloscope_arch;
