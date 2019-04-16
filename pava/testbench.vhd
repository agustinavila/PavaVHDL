--testbench. Revisar.

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity testbench is
end entity;


architecture behaviour of testbench is


component pava
	port(
		--entradas
		kikp				: in std_logic;						--llave que selecciona entre kp y ki
		run				: in std_logic;						--va a una llave que arranca o para la pava
		clock,clock_adc: in std_logic; 					--va conectado con el reloj interno
		suma				: in std_logic;						--agranda ki/kp
		resta				: in std_logic;						--achica el valor de ki/kp
		setpoint			: in std_logic_vector(6 downto 0); 	--debe ir conectado a las 7 llaves
		--salidas
		led_opto			: out std_logic;					--esto controlaria el triac
		display_setpoint0 	: out std_logic_vector(6 downto 0);	--son los ultimos 2 displays
		display_setpoint1 	: out std_logic_vector(6 downto 0);
		display_actual0		: out std_logic_vector(6 downto 0); --dsp 3 y 4
		display_actual1 	: out std_logic_vector(6 downto 0);
		display_k0		 	: out std_logic_vector(6 downto 0); --dsp 5 y 6
		display_k1		 	: out std_logic_vector(6 downto 0)
		);
end component;


--aca van las señales
		--entradas
	signal	kikp_t				:  std_logic;		--llave que selecciona entre kp y ki
	signal	run_t				:  std_logic;						--va a una llave que arranca o para la pava
	signal	clock_t,clock_adc_t:  std_logic:='0'; 					--va conectado con el reloj interno
	signal	suma_t				:  std_logic;						--agranda ki/kp
	signal	resta_t				:  std_logic;						--achica el valor de ki/kp
	signal	setpoint_t			:  std_logic_vector(6 downto 0); 	--debe ir conectado a las 7 llaves
	signal	led_opto_t			:  std_logic;					--esto controlaria el triac
	signal	display_setpoint0_t 	:  std_logic_vector(6 downto 0);	--son los ultimos 2 displays
	signal	display_setpoint1_t 	:  std_logic_vector(6 downto 0);
	signal	display_actual0_t		:  std_logic_vector(6 downto 0); --dsp 3 y 4
	signal	display_actual1_t 	:  std_logic_vector(6 downto 0);
	signal	display_k0_t		 	:  std_logic_vector(6 downto 0); --dsp 5 y 6
	signal	display_k1_t		 	:  std_logic_vector(6 downto 0);

begin

clock_t<= not clock_t after (10 ns);
clock_adc_t <= not clock_adc_t after (50 ns);

dut : pava PORT MAP(kikp=>kikp_t,
							run=>run_t,
							clock=>clock_t,
							clock_adc=>clock_adc_t,
							suma=>suma_t,
							resta=>resta_t,
							setpoint=>setpoint_t,
							led_opto=>led_opto_t,
							display_setpoint0=>display_setpoint0_t,
							display_setpoint1=>display_setpoint1_t,
							display_actual0=>display_actual0_t,
							display_actual1=>display_actual1_t,
							display_k0=>display_k0_t,
							display_k1=>display_k1_t);


process

begin
setpoint_t<="1100011";

end process;

end behaviour;
