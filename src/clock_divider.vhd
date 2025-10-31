library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity clock_divider is
	generic (
		div: integer
	);
	port (
		clk_in : in std_logic;
		clk_en_out : out std_logic
	);
end clock_divider;


architecture rtl of clock_divider is
	signal count: unsigned(integer(ceil(log2(real(div - 1)))) - 1 downto 0) := (others => '0');

begin
	process (clk_in)
	begin
		if rising_edge(clk_in) then
			if count < div then
				count <= count + 1;
				clk_en_out <= '0';
			else
				count <= (others => '0');
				clk_en_out <= '1';
			end if;
		end if;
	end process;

end rtl;
