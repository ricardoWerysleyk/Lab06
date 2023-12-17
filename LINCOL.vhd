library ieee ;
use ieee.std_logic_1164 .all;

entity LINCOL is
port(
	C			:		in std_logic_vector (2 downto 0);
	S			:		out std_logic_vector (7 downto 0)
	);
end LINCOL;

architecture logic of LINCOL is
begin
	S(0) <=	((not C(0)) and (not C(1)) and (not C(2)));
	S(1) <=	((not C(2)) and (not C(1)) and C(0));
	S(2) <=	((not C(0)) and C(1) and (not C(2)));	
	S(3) <=	((not C(2)) and C(1) and C(0));	
	S(4) <=	(C(2) and (not(C(1))) and (not C(0)));	
	S(5) <=	(C(0) and (not(C(1))) and C(2));	
	S(6) <=	(C(2) and C(1) and (not C(0)));
	S(7) <=	(C(0) and C(1) and C(2));

end logic;

