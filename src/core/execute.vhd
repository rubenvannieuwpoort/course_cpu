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
			if input.is_active = '1' and input.is_invalid = '0' then
				output.result <= (others => '0');  -- TODO: fill this with the result from the operation
				output.destination_reg <= input.destination_reg;
			else
				output <= DEFAULT_EXECUTE_OUTPUT;
			end if;
		end if;
	end process;

end rtl;
