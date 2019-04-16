--REVISAR ESTE COMPONENTE!!!
--Deberia ser el controlador PI
--Pero se solucionó a los golpes
--y directamente es proporcional,
-- tiene una ganancia de 2 para la señal de error
--(salida - setpoint)
-- Cuando aprenda controladores PI digitales lo arreglare

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
uSE ieee.std_logic_unsigned.all;
--todo lo que esta comentado es de la parte integral
-- este archivo es una cochinada
entity pi is
	generic
		(
			N: natural  :=	8
		);

	port
	(
		-- Input ports
		temp_in	: in std_logic_vector(N-1 downto 0);
		temp_ref : in std_logic_vector(N-1 downto 0);
		CLK,RST	: in  std_logic;

		-- Output ports
		pwm	: out std_logic_vector(N-1 downto 0);
		kp_out: out std_logic_vector(N-1 downto 0);
		ki_out: out std_logic_vector(N-1 downto 0)
				
	);
end pi;


architecture comportamiento of pi is



---le saque todas las señales para el integral y todas esas giladas

constant kp :std_logic_vector(N-1 downto 0)				:=x"02";
constant ki  :std_logic_vector(N-1 downto 0)				:=x"19";
--constant zero  :std_logic_vector(N-1 downto 0)			:="00000000";
--
--constant Limite_cont  :std_logic_vector(11 downto 0)	:=x"bb8";-- hBB8=3000
--
--
signal temp_reg  :std_logic_vector(N-1 downto 0);
--signal pre_suma : std_logic_vector(N-1 downto 0);
--signal sumatoria : std_logic_vector(N-1 downto 0);
signal error : std_logic_vector(N-1 downto 0);
--signal integral : std_logic_vector((N*2)-1 downto 0);
signal proporcional : std_logic_vector((N)-1 downto 0);
--signal accion  :std_logic_vector((N*2)-1 downto 0);


begin

kp_out <= kp;
ki_out <= ki;

		--- este registro guarda la temp
	Registro_RPM:process (CLK,RST)
	begin
		if (RST='1') then
			temp_reg<=(others => '0');
		elsif (rising_edge(CLK)) then
			temp_reg<=temp_in;
		end if;
	end process;
	
	
		--- este integra el error
--   Registro_Sumatoria:process (CLK,RST)
--	begin
--		if (RST='1') then
--			pre_suma<=zero;
--		elsif (rising_edge(CLK)) then
--				pre_suma<=sumatoria;
--			
--		end if;
--	end process;
	
	error<=temp_ref-temp_reg;
--	Sumatoria<=pre_suma+error; --aca va acumulando el error
--	integral<=sumatoria*ki;
	--proporcional<=error*kp;
--	accion<=proporcional+integral;
	
	proporcional <= error(n-2 downto 0) & '0';	--esto desplaza la señal, es decir multiplica por dos
																--deberian cambiarl porque el guzzo se va a dar cuenta
	
--basicamente podria hacer que proporcional <= error(n-2 downto 0) & '0'	
--eso seria multiplicarlo por dos. No lo hago asi para usar el ki y kp
	
   Registro_accion:process (CLK,RST)
	begin
		if (RST='1') then
			   pwm<="00000000";
		elsif (rising_edge(CLK)) then
				pwm<=proporcional(n-1 downto 0);
		end if;
	end process;	
	
		
end comportamiento;