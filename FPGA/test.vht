
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
SIGNAL sys_clk		: STD_LOGIC;
SIGNAL reset 		: STD_LOGIC;
SIGNAL cs 			: STD_LOGIC;
SIGNAL rw 			: STD_LOGIC;
SIGNAL address		: STD_LOGIC_VECTOR(17 DOWNTO 0);
SIGNAL ADDR 		: STD_LOGIC_VECTOR( 8 DOWNTO 0);
SIGNAL RAS 			: STD_LOGIC;
SIGNAL CAS 			: STD_LOGIC;
SIGNAL TRG 			: STD_LOGIC;
SIGNAL WE 			: STD_LOGIC;
SIGNAL DCLK			: STD_LOGIC;
SIGNAL HSYNC		: STD_LOGIC;
SIGNAL VSYNC		: STD_LOGIC;
SIGNAL SC			: STD_LOGIC;

COMPONENT test_modelsim
	PORT (
		sys_clk : IN STD_LOGIC;
		reset 	: IN STD_LOGIC;
		cs 		: IN STD_LOGIC;
		rw 		: IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		ADDR 	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		RAS 	: OUT STD_LOGIC_VECTOR;
		CAS 	: OUT STD_LOGIC_VECTOR;
		TRG 	: OUT STD_LOGIC_VECTOR;
		WE  	: OUT STD_LOGIC_VECTOR;
		DCLK	: OUT STD_LOGIC_VECTOR;
		HSYNC	: OUT STD_LOGIC_VECTOR;
		VSYNC 	: OUT STD_LOGIC_VECTOR;
		SC  	: OUT STD_LOGIC_VECTOR
	);
END COMPONENT;

BEGIN
	i1 : test_modelsim
	PORT MAP (
		sys_clk => sys_clk,
		reset 	=> reset,
		cs 		=> cs,
		rw 		=> rw,
		address(17 downto 9) 	=> ADDRESSH,
		address( 8 downto 0)	=> ADDRESSL,
		RAS 	=> RAS,
		CAS 	=> CAS,
		TRG 	=> TRG,
		WE  	=> WE,
		DCLK 	=> DCLK,
		HSYNC 	=> HSYNC,
		VSYNC	=> VSYNC,
		SC  	=> SC
	);

clock : PROCESS                                               
-- variable declarations
variable go : integer := 1;                                     
BEGIN     
	if (go = 1) then
    	sys_clk <= '1';
    	wait for 50 ps;
    	sys_clk <= '0';
    	wait for 50 ps;
    end if;
END PROCESS clock; 

init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once  
        reset <= '0';                 
WAIT;                                                       
END PROCESS init; 


always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations
variable test_round 	: integer := 0; -- 0 = idle/refresh, 1 = read, 2 = write
variable read_signal 	: integer := 0; -- same as above, but for a read request
variable write_signal 	: integer := 0; -- same as above, but for a write request
variable in_addr_low 	: bit_vector := "101010101";
variable in_addr_high 	: bit_vector := "110011001";
variable in_addr_full 	: bit_vector := "110011001101010101";
variable in_state		: boolean := 0;
variable t 				: integer := 0;

type TIMING is (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 50, 100, 200,
				270, 271, 272, 273, 280, 281, 282, 283, 284, 285, 300,
				350, 400, 450, 500, 520, 521, 522, 523, 524, 525);

BEGIN  

	for t_read in TIMING
		for t_write in TIMING
			case test_round is
				when 1 =>
					cs <= '1';
					rw <= '1';
					address <= in_addr_full;
					in_state := 1;

				when 2 =>
					cs <= '1';
					rw <= '0';
					address <= in_addr_full;
					in_state := 1;

				when others =>
					in_state := 1;

			end case;

			t := 0;
			while in_state loop

				-- Check for each timestep, that the correct behavior takes place.

				t := (t + 1);
				wait for 27 ns;
			end loop;
		end loop;
	end loop;

	test_round := (test_round + 1) mod 3;

END PROCESS always;                                          
END test_modelsim_arch;
