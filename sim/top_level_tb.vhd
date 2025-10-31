library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level_tb is
end top_level_tb;


architecture behavioral of top_level_tb is
	constant clk_period: time := 10 ns;
	signal clk: std_logic := '1';
	signal led: std_logic_vector(7 downto 0);

	component top_level is
		port (
			clk_in: in std_logic;
			led_out: out std_logic_vector(7 downto 0)
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

	top_level_inst: top_level port map(clk_in => clk, led_out => led);

end behavioral;
