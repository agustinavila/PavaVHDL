--este componente convierte una entrada en binario
--a una salida en BCD.
--Para ello, utiliza el algoritmo "double dabble"
--Esta pensado para una salida de 2 digitos, ya que
--el agua dificilmente supere los 100ºC, por tanto 
--se supone que con dos digitos bastaba.
--Al tener una entrada de 8 bits, hay muchas combinaciones
--que no se pueden representar, por lo tanto
--si se observa que el valor es de 3 digitos, escribe "Er"

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bin_a_dec is
   port (
      bin : in std_logic_vector(7 downto 0);		--la entrada de 8 bits
      unidad : out std_logic_vector(3 downto 0);	--salida de las unidades en bcd
      decena : out std_logic_vector(3 downto 0)		--salida de las decenas en bcd
      );
end bin_a_dec;

architecture behaviour of bin_a_dec is

begin		

   process(bin)
	variable temp : std_logic_vector(7 downto 0); 	--aqui se registra la entrada y se desplaza
	variable bcd  : unsigned(11 downto 0); 			--es de 12 bits para notar si la salida es de 3 digitos
	begin
		temp := bin;
		bcd := (others => '0');
		
		for i in 0 to 7 loop		--como la entrada es de 8 bits, tiene que hacer 8 desplazamientos
    
			if bcd(3 downto 0) > 4 then 				--analiza las unidades
				bcd(3 downto 0) := bcd(3 downto 0) + 3; --si es mayor o igual a 5 le suma 3
			end if;

			if bcd(7 downto 4) > 4 then 				--analiza las decenas
				bcd(7 downto 4) := bcd(7 downto 4) + 3; --si es mayor o igual a 5 le suma 3
			end if;
			--no analiza las centenas porque alcanzan a representar los 8bits
			bcd	:= bcd(10 downto 0) & temp(7); 			--desplaza la salida y le mete un bit de la entrada a la izquierda
			temp	:= temp(6 downto 0) & '0';			--LLS? Desplaza la entrada tambien
		end loop;
		
	if bcd(11 downto 8) > 0 then
		unidad <= "1110";		--si es de tres digitos
		decena <= "1111";		--escribe "Er"
	else
		unidad <= std_logic_vector(bcd(3 downto 0));	--si no, escribe las salidas
		decena <= std_logic_vector(bcd(7 downto 4));
	end if;
end process;
end architecture behaviour;