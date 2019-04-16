--deberia mostrar ki o kp
--el tema es que esos valores estan integrados en el PI
--al final no me dio el tiempo para integrar esto
--pero estaria bueno que funcione

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity k is
	port(
	clk		: in std_logic;
	kikp		: in std_logic;
	suma		: in std_logic;
	resta		: in std_logic;
	ki_in	: in std_logic_vector(7 downto 0);
	kp_in	: in std_logic_vector(7 downto 0);
	display	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behaviour of k is

	signal ki : std_logic_vector(7 downto 0):="01000000";
	signal kp : std_logic_vector(7 downto 0):="00010000";

begin

	process(kikp,ki,kp)		--revisar esto, probablemente ni ande
		--variable kk : unsigned(7 downto 0);
		begin
		if(kikp='1') then			--con kikp en 1 modifica ki, en 0 modifica kp
			--kk<=to_unsigned(ki);	
		 display<=ki;
		else
			--kk<=to_unsigned(kp);
			display<=kp;
		end if;
	
	
	
	end process;

	ki<=ki_in;
	kp<=kp_in;

end behaviour;