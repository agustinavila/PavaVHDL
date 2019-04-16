--Es un simple registro de 8bit.
--tiene anulado el reset, en su momento necesitaba hacerlo andar rapido
--tiene margen para mejorar

library ieee;
use ieee.std_logic_1164.all;

entity registro is

port(
   CLK		: in std_logic;
	entrada 	: in std_logic_vector(7 downto 0);
	salida 	: out std_logic_vector(7 downto 0)
	);	
end registro;
	
architecture prueba of registro is
	signal ssalida : std_logic_vector(7 downto 0);
begin
	process (CLK)
		begin
			--if (RST='1') then
					if (rising_edge(clk)) then
						ssalida <= entrada;
					end if;				
			--else ssalida <= (others=>'0');
			--end if;
	end process;
	
	salida <= ssalida;	
end prueba;