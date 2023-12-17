library ieee ;
use ieee.std_logic_1164 .all;

entity Logica is
port(
	Clock, Up, Down			:	in std_logic;
	B, SEL						: 	out std_logic
);

end Logica;

architecture logica of Logica is

signal s1, s2, s3, s4, s5, s6	:	std_logic;

begin
	s1 <=	((not Down) and Up);
	s2 <=	((not Up) and Down);
	s3 <= ((not s1) and s2);
	s4 <= ((not Clock) and Up);
	s5 <= ((not Clock) and Down);
	s6 <= (s4 xor s5);
	
	B <= s6;
	SEL <= s3;
	
end logica;