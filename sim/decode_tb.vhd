library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity decode_tb is
end decode_tb;


architecture behavioral of decode_tb is
	constant clk_period: time := 10 ns;
	signal clk: std_logic := '1';

	component decode is
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

	decode_inst: decode port map(clk_in => clk);

end behavioral;
