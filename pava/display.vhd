library ieee;
use ieee.std_logic_1164.all;

--convierte de binario de 8bits
--a dos displays de 7 segmentos
--por lo tanto, solo representa hasta 99
--si no, escribe "Er"

entity display is
port(
bin		: in std_logic_vector(7 downto 0);        --entran los 8 bits a representar
rst		: in std_logic;
display0 : out std_logic_vector(6 downto 0);    --esto podria ser una salida
display1 : out std_logic_vector(6 downto 0)     --en vez de dos
);					                                --pero va a ser mas facil para mapear los pines
end display;

architecture behaviour of display is

    component bin_a_dec
        port (
           bin : in std_logic_vector(7 downto 0);
           unidad : out std_logic_vector(3 downto 0);
           decena : out std_logic_vector(3 downto 0)
           );
			  end component;

    component bcd_a_7s
        port(
            bcd     : in std_logic_vector(3 downto 0);
            display : out std_logic_vector(6 downto 0)
				);
end component;

signal sbin     : std_logic_vector(7 downto 0);    --creo que es innecesaria, une los puertos de entrada con el componente
signal dsp0 : std_logic_vector(3 downto 0);    --une la salida del conversor a bcd con 
signal dsp1 : std_logic_vector(3 downto 0);    --los conversores a 7s
signal salida0  : std_logic_vector(6 downto 0);    --creo que innecesario, une los puertos con las salidas
signal salida1  : std_logic_vector(6 downto 0);    --idem

begin

    bin_dec : bin_a_dec PORT MAP (  bin     => sbin,
                                    unidad  => dsp0,
                                    decena  => dsp1);

    bcd0    : bcd_a_7s PORT MAP  (  bcd     => dsp0,
                                    display => salida0);

    bcd1    : bcd_a_7s PORT MAP  (  bcd     => dsp1,
                                    display => salida1);
process(bin, rst)
begin
	if(rst='1') then
    sbin        <= bin;         --creo
	else sbin <= "00000000";
	end if;
	end process;
    display0    <= salida0;     --esto
    display1    <= salida1;     --no hace falta

end behaviour;


----------------------------------------------------------------------

