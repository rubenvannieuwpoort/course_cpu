library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bram is
	generic(
		SIZE: integer := 1024;
		ADDR_WIDTH: integer := 10;
		COL_WIDTH: integer := 8;
		NB_COL: integer := 4
	);
	port(
		clka: in std_logic;
		ena: in std_logic;
		wea: in std_logic_vector(NB_COL - 1 downto 0);
		addra: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
		dia: in std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);
		doa: out std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);
		clkb: in std_logic;
		enb: in std_logic;
		addrb: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
		dob: out std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0)
	);
end bram;

architecture rtl of bram is
	type ram_type is array (0 to SIZE - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);
	shared variable RAM: ram_type := (others => (others => '0'));

begin

	-- port A
	process(clka)
	begin
		if rising_edge(clka) then
			if ena = '1' then
				for i in 0 to NB_COL - 1 loop
					if wea(i) = '1' then
						RAM(conv_integer(addra))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) := dia((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
					end if;
				end loop;
				doa <= RAM(conv_integer(addra));
			end if;
		end if;
	end process;

	-- port B
	process(clkb)
	begin
		if rising_edge(clkb) then
			if enb = '1' then
				dob <= RAM(conv_integer(addrb));
			end if;
		end if;
	end process;
end rtl;
