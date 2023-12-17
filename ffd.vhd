library ieee ;
use ieee.std_logic_1164 .all;

entity ffd is
port(
	ck , clear , Enable , d	: 	in std_logic;
	q 								: 	out std_logic
);

end ffd;

architecture logica of ffd is

begin
	process (ck , clear , Enable)
		begin
		if (Enable = '0') then q <= '1';
			elsif (clear = '1') then q <= '0';
			elsif (ck ' event and ck = '1') then q <= d;
		end if;
	end process ;
end logica;