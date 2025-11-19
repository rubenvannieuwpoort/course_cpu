library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity memory is
	port (
		clk: in std_logic;
		input: in execute_output_t;
		output: out memory_output_t := DEFAULT_MEMORY_OUTPUT
	);
end memory;


architecture rtl of memory is
begin

	process (clk)
	begin
		if rising_edge(clk) then
			-- TODO: implement
		end if;
	end process;

end rtl;
