library ieee ;
use ieee.std_logic_1164 .all;

entity Adder3bit is
port(
	B, M						:		in std_logic;
	A 							:		in std_logic_vector (2 downto 0);
	Co							:		out std_logic;
	S							:		out std_logic_vector (2 downto 0)
	);
end Adder3bit;

architecture soma of Adder3bit is

component Fulladder is
port(
	A, B, Ci		:		in std_logic;
	S, Co			:		out std_logic
	);
end component;

	signal I2, I1, I0, C1, C0		:		std_logic;
	
begin
	
	I0 <= (M xor B);
	I1 <= M;
	I2 <= M;
	
	SOMA0 : Fulladder port map(A(0), I0, M, S(0), C0);
	SOMA1 : Fulladder port map(A(1), I1, C0, S(1), C1);
	SOMA2 : Fulladder port map(A(2), I2, C1, S(2), Co);

end soma;
	