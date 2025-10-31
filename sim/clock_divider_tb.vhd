library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clock_divider_tb is
end clock_divider_tb;


architecture behavioral of clock_divider_tb is
	constant clk_period: time := 10 ns;

	signal clk: std_logic := '1';
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
	clk_process :process
	begin
		clk <= '1';
		wait for clk_period / 2;
		clk <= '0';
		wait for clk_period / 2;
	end process;

	clock_div: clock_divider generic map(div => 10) port map(clk_in => clk, clk_en_out => clk_en);

end behavioral;
