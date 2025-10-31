library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level is
	port (
		clk_in: in std_logic;
		led_out: out std_logic_vector(7 downto 0)
	);
end top_level;


architecture rtl of top_level is
	signal count: unsigned(7 downto 0) := (others => '0');
	signal clk_en: std_logic;

	component clock_divider is
		generic (
			div: integer
		);
		port (
			clk_in : in std_logic;
			clk_en_out : out std_logic
		);
	end component;

begin
	led_out(7 downto 0) <= std_logic_vector(count);

	process (clk_in)
	begin
		if rising_edge(clk_in) and clk_en = '1' then
			count <= count + 1;
		end if;
	end process;

	clock_div: clock_divider generic map(div => 100000000) port map(clk_in => clk_in, clk_en_out => clk_en);

end rtl;
