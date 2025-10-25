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

begin
	led(7 downto 0) <= std_logic_vector(count(30 downto 23));

	process (clk)
	begin
		if rising_edge(clk) then
			count <= count + 1;
		end if;
	end process;

end rtl;
