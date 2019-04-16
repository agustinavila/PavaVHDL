--se me hace que uso librerias de mas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
entity contador is
	port (
		clk			: in std_logic;
		contador 	: out std_logic_vector(7 downto 0);
		cont256		: out std_logic 	--tira un pulso cada 256 ciclos, para sincronizar el pwm
		);
end contador;
 
architecture behaviour of contador is
	--signal cont	: std_logic_vector(7 downto 0):="00000000";
	signal c256 : std_logic;
 
begin
 
	process(clk)
	variable cont : std_logic_vector(7 downto 0);
		begin
			if(rising_edge(clk)) then
				if (cont = "11111111") then 	--cuando llega a 256 vuelve a 0
					cont := "00000000";
					c256 <= '1';					--y tira un pulso
				else 
					cont :=cont + '1';			--si no es 256, suma
					c256 <= '0';					--apaga el pulso
				end if;
			end if;
		contador <= cont;
		cont256	<= c256;
	end process;
 
end behaviour;