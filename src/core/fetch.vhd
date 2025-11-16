library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fetch is
	port (
		clk: in std_logic
	);
end fetch;


architecture rtl of fetch is
begin

	process (clk)
	begin
		if rising_edge(clk) then
			-- TODO: implement
		end if;
	end process;

end rtl;
