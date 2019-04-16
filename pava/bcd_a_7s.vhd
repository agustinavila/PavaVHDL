--los segmentos se encienden con la salida en bajo
--ademas de los numeros del 0 al 9
--se incluye los caracteres "E", "r" y "-"
--si se quiere representar un numero de 3 digitos,
--al solo tener 2 escribe "Er"
--si se llegase a escribir un valor no valido, escribe "--"

--eso es parte del bin_a_dec

library ieee;
use ieee.std_logic_1164.all;

entity bcd_a_7s is
    port(
        bcd     : in std_logic_vector(3 downto 0);
        display : out std_logic_vector(6 downto 0)
    );
end bcd_a_7s;

architecture behaviour of bcd_a_7s is
	
    begin
   with bcd select	
	display <= 		"1000000" when "0000", --0 
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"0000010" when "0110", --6
					"1111000" when "0111", --7
					"0000000" when "1000", --8
					"0010000" when "1001", --9
					"0000110" when "1111", --E
					"0101111" when "1110", --r
					"0111111" when others; --"-"
end architecture behaviour;