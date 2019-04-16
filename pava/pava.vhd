-- Trabajo práctico para la materia Electronica Digital 2
-- de la carrera Ingenieria Electronica en la UNSJ

--El codigo pertenece a una pava electrica con control digital de temperatura
--lee la temperatura de un ADC, compara con una temperatura seteada
--y realiza una accion de control (deberia ser un controlador PI, pero solo es proporcional)
--Al mismo tiempo, muestra el setpoint y la temperatura actual en 4 displays de 7 segmentos.
--Actualiza cada 2,56s la accion de control, segun la temp actual es es tiempo activo de la salida.
--Agustin Avila, 2018

library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pava is

	port(
		--entradas
		kikp				: in std_logic;						--llave que selecciona entre kp y ki
		run				: in std_logic;						--va a una llave que arranca o para la pava
		clock,clock_adc: in std_logic; 					--va conectado con el reloj interno
		suma				: in std_logic;						--agranda ki/kp
		resta				: in std_logic;						--achica el valor de ki/kp
		setpoint			: in std_logic_vector(6 downto 0); 	--debe ir conectado a las 7 llaves
		--adc_temp			: in std_logic_vector(11 downto 0);
-- si el adc es de 12 bits, tenemos que tomar los 8 bits mas significativos
-- pero aparentemente el maximo valor es 5v, no 2,5
-- entonces tendriamos que tomar entre el bit 10 y el 3
-- con eso dividimos la tension en 2 y multiplicamos por 8. no se como explicarlo pero
-- deberia andar joya

		--salidas
		led_opto			: out std_logic;					--esto controlaria el triac

		display_setpoint0 	: out std_logic_vector(6 downto 0);	--son los ultimos 2 displays
		display_setpoint1 	: out std_logic_vector(6 downto 0);
		
		display_actual0		: out std_logic_vector(6 downto 0); --dsp 3 y 4
		display_actual1 	: out std_logic_vector(6 downto 0);
		
		display_k0		 	: out std_logic_vector(6 downto 0); --dsp 5 y 6
		display_k1		 	: out std_logic_vector(6 downto 0)
		);

end pava;

architecture behaviour of pava is 


	component adc_prueba is
		port (
			CLOCK : in  std_logic                     := 'X'; -- clk
			RESET : in  std_logic                     := 'X'; -- reset
			CH0   : out std_logic_vector(11 downto 0)        -- CH0
			--CH1   : out std_logic_vector(11 downto 0);        -- CH1
			--CH2   : out std_logic_vector(11 downto 0);        -- CH2
			--CH3   : out std_logic_vector(11 downto 0);        -- CH3
			--CH4   : out std_logic_vector(11 downto 0);        -- CH4
			--CH5   : out std_logic_vector(11 downto 0);        -- CH5
			--CH6   : out std_logic_vector(11 downto 0);        -- CH6
			--CH7   : out std_logic_vector(11 downto 0)         -- CH7
		);
	end component adc_prueba;


component display
	port(
			bin		 : in std_logic_vector(7 downto 0);
			rst		: in std_logic;
			display0 : out std_logic_vector(6 downto 0);
			display1 : out std_logic_vector(6 downto 0)
	);          
	end component;

component frec_div
	port (
		clk			: in std_logic;
		clock_out	: out std_logic
		);
end component;

component pwm
	port(
		registro	: in std_logic_vector(7 downto 0);
		clk		: in std_logic;
		reset		: in std_logic;
		salida	: out std_logic);
end component;

component pi
	generic
		(
			N: natural  :=	8
		);
	port(
		-- Input ports
		temp_in	: in std_logic_vector(N-1 downto 0);
		temp_ref : in std_logic_vector(N-1 downto 0);
		CLK,RST	: in  std_logic;

		-- Output ports
		pwm	: out std_logic_vector(N-1 downto 0);
		kp_out: out std_logic_vector(N-1 downto 0);
		ki_out: out std_logic_vector(N-1 downto 0)
				
	);
	end component;

component k
	port(
	clk		: in std_logic;
	kikp		: in std_logic;
	suma		: in std_logic;
	resta		: in std_logic;
	ki_in	: in std_logic_vector(7 downto 0);
	kp_in	: in std_logic_vector(7 downto 0);
	display	: out std_logic_vector(7 downto 0)
	);
end component;

signal clkadc			:std_logic;
signal clk_50m			:std_logic;
signal clk_100			: std_logic;
signal set 				: std_logic_vector(7 downto 0);	--señal para las llaves
signal reset			: std_logic:='1';
signal reset_adc		: std_logic:='0';
signal dsp_set0 		: std_logic_vector(6 downto 0);	--salidas a los displays
signal dsp_set1 		: std_logic_vector(6 downto 0);
signal dsp_actual0 	: std_logic_vector(6 downto 0);	--salidas a los displays
signal dsp_actual1	: std_logic_vector(6 downto 0);
signal dsp_k0		 	: std_logic_vector(6 downto 0);	--salidas a los displays
signal dsp_k1			: std_logic_vector(6 downto 0);
signal temp			 	: std_logic_vector(7 downto 0):="00100000"; --32 en binario
signal adc_temp		: std_logic_vector(11 downto 0);
signal ki_kp			: std_logic;	--selecciona entra varia ki o kp
signal mas				: std_logic;	--incrementa ki/kp. activo en bajo
signal menos			: std_logic;	--decrementa ki/kp. activo en bajo
signal pi_pwm			: std_logic_vector(7 downto 0);
signal ki				: std_logic_vector(7 downto 0);
signal kp				: std_logic_vector(7 downto 0);
signal kikp_display	: std_logic_vector(7 downto 0);



begin

--conexion de señales con entradas
clkadc			<= clock_adc;
set 					<= '0' & setpoint;
clk_50m				<= clock;
ki_kp					<= kikp;
temp					<=adc_temp(10 downto 3);

--conexion interna de señales



--conexion de señales con salidas
display_setpoint0 <= dsp_set0;
display_setpoint1 <= dsp_set1;
display_actual0	<= dsp_actual0;
display_actual1	<= dsp_actual1;
display_k0			<= dsp_k0;
display_k1			<= dsp_k1;


----------------instanciacion de componentes----------------------
display_setpoint	: display PORT MAP(bin=>set,
												rst=>reset,
												display0=>dsp_actual0,
												display1=>dsp_actual1);
									
display_actual  	: display PORT MAP(bin=>temp,
												rst=>reset,
												display0=>dsp_set0,
												display1=>dsp_set1);
												
display_kikp		: display PORT MAP(bin=>kikp_display,
												rst=>reset,
												display0=>dsp_k0,
												display1=>dsp_k1);
									
divisor				: frec_div PORT MAP(clk=>clk_50m,
												clock_out=>clk_100);
												
	pwm1				: pwm 	PORT MAP(clk=>clk_100,
												reset=>reset_adc,
												registro=>pi_pwm,
												salida=>led_opto);
												
	controlador		: pi		PORT MAP(temp_in=>temp,
												temp_ref=>set,
												clk=>clk_100,
												ki_out=>ki,
												kp_out=>kp,
												--run=>run,
												pwm=>pi_pwm,
												rst=>reset_adc);

	k_control		: k		PORT MAP(clk=>clk_100,
												kikp=>ki_kp,
												suma=>suma,
												resta=>resta,
												ki_in=>ki,
												kp_in=>kp,
												display=>kikp_display);
												
	adc0 				: adc_prueba
		port map (
			CLOCK => clkadc, --      clk.clk
			RESET => reset_adc, --    reset.reset
			CH0   => adc_temp   -- readings.CH0
--			CH1   => CONNECTED_TO_CH1,   --         .CH1
--			CH2   => CONNECTED_TO_CH2,   --         .CH2
--			CH3   => CONNECTED_TO_CH3,   --         .CH3
--			CH4   => CONNECTED_TO_CH4,   --         .CH4
--			CH5   => CONNECTED_TO_CH5,   --         .CH5
--			CH6   => CONNECTED_TO_CH6,   --         .CH6
--			CH7   => CONNECTED_TO_CH7    --         .CH7
		);

--me sudan las bolas.

end behaviour; --y ella ?;
