library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level is
	port (
		clk: in std_logic;
		led: out std_logic_vector(7 downto 0)
	);
end top_level;


architecture rtl of top_level is
	signal count: unsigned(31 downto 0) := (others => '0');

	component core is
		port (
			clk: in std_logic;
			led: out std_logic_vector(7 downto 0)
		);
	end component;

begin

	core_inst: core port map(clk => clk, led => led);

end rtl;
