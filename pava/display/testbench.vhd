library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity testbench is
end;

architecture bench of testbench is

component display
port(
bin		: in std_logic_vector(7 downto 0);        --entran los 8 bits a representar
rst		: in std_logic;
display0 : out std_logic_vector(6 downto 0);    --esto podria ser una salida
display1 : out std_logic_vector(6 downto 0)     --en vez de dos
);					                                --pero va a ser mas facil para mapear los pines
end component;


--señales
	signal bin_t			: std_logic_vector(7 downto 0):="00000000";
	--shared variable bin_t: integer range 0 to 255:=0;
	signal rst_t		 	: std_logic:='0';
	signal display0_t 	: std_logic_vector(6 downto 0);
	signal display1_t 	: std_logic_vector(6 downto 0);
	signal t_clock			: time := 0.5 sec;
	signal clock			: std_logic:='0';
	


begin

	dut : display PORT MAP(bin_t,
									rst_t,
									display0_t,
									display1_t);
								
	
	
	clock <= not clock after (t_clock/2);
	
	process
	begin
	
		wait for (2*t_clock);
		
		rst_t<='1';
		
		wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(5,bin_t'length));
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(10,bin_t'length));
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(23,bin_t'length));
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(45,bin_t'length));
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(67,bin_t'length));
		
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(89,bin_t'length));
				
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(100,bin_t'length));
				
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(170,bin_t'length));
				
		
				wait for (6*t_clock);
		
		bin_t <= std_logic_vector(to_unsigned(240,bin_t'length));
		
	end process;
	
	
end bench;