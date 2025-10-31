library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fetch_tb is
end fetch_tb;


architecture behavioral of fetch_tb is
	constant clk_period: time := 10 ns;
	signal clk: std_logic := '1';

	component fetch is
		port (
			clk_in: in std_logic
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

	fetch_inst: fetch port map(clk_in => clk);

end behavioral;
