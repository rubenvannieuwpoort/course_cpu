library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity execute is
	port (
		clk: in std_logic;
		input: in decode_output_t;
		output: out execute_output_t := DEFAULT_EXECUTE_OUTPUT
	);
end execute;


architecture rtl of execute is
begin

	process (clk)
	begin
		if rising_edge(clk) then
			-- TODO: implement
		end if;
	end process;

end rtl;
