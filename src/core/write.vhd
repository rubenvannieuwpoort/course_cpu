library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity write is
	port (
		clk: in std_logic;
		input: in memory_output_t
	);
end write;


architecture rtl of write is
begin

	process (clk)
	begin
		if rising_edge(clk) then
			-- TODO: implement
		end if;
	end process;

end rtl;
