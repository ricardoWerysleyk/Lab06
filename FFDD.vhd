library ieee ;
use ieee.std_logic_1164 .all;

entity FFDD is
port(
	Ligar_cancelarx, Addx				:	in std_logic;
	Entry										:	in std_logic_vector (5 downto 0);
	clksys									:	in std_logic  := '0';
	Red, Blue, Green, Lig, Error, S_3, S_2, S_1, SaidaTemp2_1X, SaidaTemp2_0X, SVXX		: 	out std_logic;
	Seg2										: 	out std_logic_vector(0 to 6);
	Seg1										: 	out std_logic_vector(0 to 6)
);

end FFDD;

architecture Main of FFDD is
-----------------------------------------------
component Controle_Painel is
port(
	P1, Verde, Clock, Ligado			:		in std_logic;
	Saida										:		out std_logic_vector (1 downto 0)
	);
end component;
-----------------------------------------------
component bcd_fpga is
port(
	bcdentry: in std_logic_vector (3 downto 0);
	bcdout: out std_logic_vector (6 downto 0)
    );
end component;
-----------------------------------------------
component contador_de_clicks is
port(
	Ld, Clr	: in std_logic;
	Clock		: in std_logic;
	S0			: out std_logic
	);
end component;
-----------------------------------------------
component Temp20 is
port(
clk			: in std_logic;
clr, set		: in std_logic;
entry			: in std_logic;
q				: out std_logic
);
end component;
-----------------------------------------------
component Temp5 is
port(
	clk		: in std_logic;
	clr, set	: in std_logic;
	d			: in std_logic;
	q			: out std_logic
);
end component;
-----------------------------------------------
component TempLedAzul is
port(
	clk			: in std_logic;
	clr, set		: in std_logic;
	d				: in std_logic;
	led			: out std_logic
);
end component;
-----------------------------------------------
component Painel is
port(
		Chaves		: 		in std_logic_vector(5 downto 0);
		Selct			:	 	in std_logic_vector(1 downto 0);
		Dez			: 		out std_logic_vector(3 downto 0);
		Uni			: 		out std_logic_vector(3 downto 0)
	);
end component;
-----------------------------------------------
component Corretor is
port(
	E										:		in std_logic_vector (5 downto 0);
	LD										:		in std_logic;
	S										:		out std_logic_vector (5 downto 0)
	);
end component;
-----------------------------------------------
component Comparador_6b is
port(
	A, B								:		in std_logic_vector (5 downto 0);
	AiB, AMaB, AMeB				:		out std_logic
	);
end component;
-----------------------------------------------
component seletor_comparacao is
port(
	C1, C0, A_igual_B		: in std_logic;
	S2, S1, S0				: out std_logic
	);
end component;
-----------------------------------------------
component Registrador3bits is
port(
	Entry0, Entry1, Entry2		:	in std_logic;
	Clock , clear					: 	in std_logic;
	Cont								: 	in std_logic_vector(1 downto 0);
	S0, S1, S2 						: 	out std_logic
);
end component;

-----------------------------------------------
component contador_2_bits is
port(
	Ld, Clr		: in std_logic;
	Clock			: in std_logic;
	S1,S0			: out std_logic
	);
end component;
-----------------------------------------------
component Temp2 is
port(
	clk			: in std_logic;
	clr, set		: in std_logic;
	d				: in std_logic;
	q				: out std_logic
);
end component;
-----------------------------------------------
component CLK_Div is port ( 
  clk_in : in std_logic ;
  clk_out : out std_logic
);end component ;
-----------------------------------------------
component mux6p1 is
port(
		A, B, C					: in std_logic_vector(5 downto 0);
		sel						: in std_logic_vector(1 downto 0);
	   s							: out std_logic_vector(5 downto 0));
end component;
-----------------------------------------------
--signal aux: std_logic := '0';
	signal S0, S1, S2, SV, Load, Cancel, P1, Cont1, Cont0, AiB, AiB_atrasado, Lcont2, Clrcont2	: std_logic;
	signal Vermelho, Verde, Azul, Ligado, Erro, Entazul, Saidazul, SaidaTemp2_1, SaidaTemp2_0		: std_logic;
	signal Clock, Ligar_cancelar, Add																				: std_logic;
	
	signal EntClick, Stpazul, zzz, kk, EntrReg, AiB_Duplo		:		std_logic;
	signal SaiCorr, SaidaMux6											:		std_logic_vector (5 downto 0);
	signal Senha1, Senha2, Senha3										:		std_logic_vector (5 downto 0);
	signal Cont, SelBinBCD												: 		std_logic_vector (1 downto 0);
	signal SinalReg														: 		std_logic_vector (2 downto 0);
	signal Seg_2, Seg_1													: 		std_logic_vector(3 downto 0);
	
begin
----------------------------------
	
	Divisor: CLK_Div port map(clksys, Clock);
	SaidaTemp2_1X <= SaidaTemp2_1;
	SaidaTemp2_0X <= SaidaTemp2_0;
	SVXX <= SV;
	
	
	S_3 <= S2;
	S_2 <= S1;
	S_1 <= S0;
	Senha1 <= ("000010");
	Senha2 <= ("000010");
	Senha3 <= ("000010");
	
	Ligar_cancelar <= (not Ligar_cancelarx);
	Add <= (not Addx);
	Telacofre: Painel port map(Entry, SelBinBCD, Seg_2, Seg_1);
	
	Controle: Controle_Painel port map( P1, Verde, Clock, Ligado, SelBinBCD);
	
	Load <= (Add and Ligado and (not Azul));
	Cancel <= Ligar_cancelar;
	C1: Temp20 port map(Clock, '0', '1', Verde, SV);
	
	EntClick <= (Erro or SV or Cancel);
	C2: contador_de_clicks port map(EntClick, '0', Clock, Ligado);
	
	C3: TempLedAzul port map(Clock, '0', '1', Ligar_cancelar, Stpazul);
	
	P1 <= (Stpazul and (not Ligado));
	
	C4: Corretor port map(Entry, Load, SaiCorr);
	Mult6: mux6p1 port map(Senha1, Senha2, Senha3, Cont, SaidaMux6);--<=
	
	C5: Comparador_6b port map(Entry, SaidaMux6, AiB, zzz, kk);
	
	EntrReg <= (Cancel or SV or Erro);
--------------------------------------------------------------	
	Teste_atraso: Temp2 port map(Clock, '0', '1', AiB, AiB_atrasado);
	
	AiB_Duplo <= (AiB or AiB_atrasado);
---------------------------------------------------------------------	
	C6: seletor_comparacao port map(Cont(1), Cont(0), AiB_Duplo, SinalReg(2), SinalReg(1), SinalReg(0));

-------------------------------------------------------------------------
	CRegister: Registrador3bits port map(SinalReg(0), SinalReg(1), SinalReg(2), Clock, EntrReg, Cont, S0, S1, S2);
-------------------------------------------------------------------------
	
	
	Lcont2 <= (((not Azul) and Load) or ((not Azul) and (not Verde) and Cont(1) and Cont(0)));
	Clrcont2 <= (Cancel or Erro or SV);
	
	C7: contador_2_bits port map(Lcont2, Clrcont2, Clock, Cont1, Cont0);
	
	Cont(1) <= Cont1;
	Cont(0) <= Cont0;
	Entazul <= (Load or Cancel);
	
	C8: TempLedAzul port map(Clock, '0', '1', Entazul, Saidazul);
	
	Azul <= (Saidazul and (not SV));
	
	Verde <= (S2 and S1 and S0 and (Cont(1)) and (Cont(0)) and (not Azul));
	
	Vermelho <= ((not Verde) and (not Azul));
	
	C9: Temp2 port map(Clock, '0', '1', Cont(1), SaidaTemp2_1);
	C10: Temp2 port map(Clock, '0', '1', Cont(0), SaidaTemp2_0);
	
	Erro <= ((not (S2 and S1 and S0)) and SaidaTemp2_1 and SaidaTemp2_0 and (not SV) and Ligado and (not Azul));
-------------------------------------
	
	Red <= Vermelho;
	Blue <= Azul;
	Green <= Verde;
	Lig <= Ligado;
	Error <= Erro;
	
	
	Display_Dez: bcd_fpga port map(Seg_2, Seg2);
	Display_Uni: bcd_fpga port map(Seg_1, Seg1);
	
end Main;