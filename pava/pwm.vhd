--PWM
--Le ingresa el clock de 100Hz, por lo tanto su periodo es de 2,56s
--su resolucion es de 8bits (de ahi salen los 2,56 seg)
--en la entrada del registro en realidad es la salida del controlador PI
--que define cuanto tiempo debe estar encendida la salida.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
  
entity pwm is
    PORT(
        clk    : IN  STD_LOGIC;
        reset  : IN  STD_LOGIC;
        registro: IN  STD_LOGIC_VECTOR(7 downto 0);	--el registro indica el duty cycle
        salida : OUT STD_LOGIC
    );
end pwm;
  
architecture Behaviour of pwm is
    signal cnt : unsigned(7 downto 0);
begin

    contador: process (clk, reset, registro) begin
        if reset = '1' then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if cnt = 255 then       --directamente lo declaro como numero
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;		--esto va sumando 1 al contador con cada pulso del clock
            end if;
        end if;
    end process;
    -- Asignación de señales --
    salida <= '1' when (cnt < UNSIGNED(registro)) else '0';		--mientras el contador sea menor al registro, la salida es 1
end Behaviour;



