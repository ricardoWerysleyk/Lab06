library ieee;
use ieee.std_logic_1164.all;

entity Lab_06 is
port
(
	Clear, clksys					: 		in std_logic;

	UP, DO, LE, RI					: 		in std_logic;
	COL, LIN							: 		out std_logic_vector (7 downto 0)
);
end Lab_06;

architecture leds of Lab_06 is

component Registrador3bits is
port(
	Entry							:	in std_logic_vector (2 downto 0);
	Clock , clear , Enable	: 	in std_logic;
	S 								: 	out std_logic_vector (2 downto 0)
);

end component;

component Logica is
port(
	Clock, Up, Down			:	in std_logic;
	B, SEL						: 	out std_logic
);

end component;

component Adder3bit is
port(
	B, M						:		in std_logic;
	A 							:		in std_logic_vector (2 downto 0);
	Co							:		out std_logic;
	S							:		out std_logic_vector (2 downto 0)
	);
end component;

component LINCOL is
port(
	C			:		in std_logic_vector (2 downto 0);
	S			:		out std_logic_vector (7 downto 0)
	);
end component;

component CLK_Div is
port
(
		clk_in	: in std_logic;
		clk_out	: out std_logic
);
end component;

	signal BL, SELL, BC, SELC, SC2, SC1, SC0, COUT_L, COUT_C, Clock 	:	std_logic;
	signal A, B, SL, SC																:	std_logic_vector (2 downto 0);
	
begin
	
	
	--C0: CLK_div port map(clksys, Clock);
	
	Clock <= clksys; --Apagar essa linha
	
	LogicaL : Logica port map(Clock, DO, UP, BL, SELL);
	LogicaC : Logica port map(Clock, RI, LE, BC, SELC);
	
	SOMAL : Adder3bit port map(BL, SELL, B, COUT_L, SL);
	SOMAC : Adder3bit port map(BC, SELC, A, COUT_C, SC);
	
	REGL : Registrador3bits port map(SL, Clock, Clear, '1', B);
	REGC : Registrador3bits port map(SC, Clock, Clear, '1', A);
	
	LINHAS		: LINCOL port map(B, LIN);
	COLUNAS		: LINCOL port map(A, COL);

	
end architecture;
