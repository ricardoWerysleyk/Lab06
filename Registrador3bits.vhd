library ieee ;
use ieee.std_logic_1164 .all;

entity Registrador3bits is
port(
	Entry							:	in std_logic_vector (2 downto 0);
	Clock , clear , Enable	: 	in std_logic;
	S 								: 	out std_logic_vector (2 downto 0)
);

end Registrador3bits;

architecture logica of Registrador3bits is
begin		
	process (Clock, clear , Enable)
		begin
		if (Enable = '1') then
			if (clear = '1') then
				S(0) <= '0';
				S(1) <= '0';
				S(2) <= '0';
			elsif (Clock' event and Clock = '1') then
				S(0) <= Entry(0);
				S(1) <= Entry(1);
				S(2) <= Entry(2);
			end if;
		end if;
	end process ;
end logica;