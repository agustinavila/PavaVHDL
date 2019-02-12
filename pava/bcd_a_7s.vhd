library ieee;
use ieee.std_logic_1164.all;

--los segmentos se encienden con la salida en bajo
--ademas de los numeros del 0 al 9
--se incluye los caracteres "E", "r" y "-"
--si se quiere representar un numero de 3 digitos,
--al solo tener 2 escribe "Er"
--si se llegase a escribir un valor no valido, escribe "--"


--deberian cambiar lo de que escribe er, es obvio que lo copiaron si no
--eso es parte del bin_a_dec

entity bcd_a_7s is
    port(
        bcd     : in std_logic_vector(3 downto 0);
        display : out std_logic_vector(6 downto 0)
    );
end bcd_a_7s;

architecture behaviour of bcd_a_7s is
	
    begin
   with bcd select	
	display <= 	"1000000" when "0000", 
					"1111001" when "0001",
					"0100100" when "0010", 
					"0110000" when "0011",
					"0011001" when "0100",
					"0010010" when "0101", 
					"0000010" when "0110", 
					"1111000" when "0111",
					"0000000" when "1000",
					"0010000" when "1001", 
					"0000110" when "1111",
					"0101111" when "1110",   --r
					"0111111" when others;  -- "-"

end architecture behaviour;