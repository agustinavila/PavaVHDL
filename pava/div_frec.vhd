--Componente divisor de frecuencia
--se le asigna como entrada un clk del FPGA
--cuya frecuencia es de 50MHz
--Y se obtiene una salida de 100Hz

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity frec_div is
	port (
		clk			: in std_logic;
		clock_out	: out std_logic
		);
end frec_div;
 
architecture behaviour of frec_div is
	signal count	: integer:=1;
	signal salida	: std_logic := '0';
begin
	process(clk)
		begin
			if(rising_edge(clk)) then
				count <=count+1;
				if (count = 250000) then 	--divide en 250k para obtener un clk de 100hz
					salida <= not salida;	--ya que el fpga utilizado tiene un clk de 50MHz
					count <= 1;
				end if;
			end if;
		clock_out <= salida;
	end process;
 
end behaviour;