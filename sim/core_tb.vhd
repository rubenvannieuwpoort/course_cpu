library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity core_tb is
end core_tb;


architecture behavioral of core_tb is
	constant clk_period: time := 10 ns;
	signal clk: std_logic := '1';

	component core is
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

	core_inst: core port map(clk_in => clk);

end behavioral;
