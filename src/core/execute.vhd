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
		variable v_output: execute_output_t;
	begin
		if rising_edge(clk) then
			v_output := DEFAULT_EXECUTE_OUTPUT;
			v_output.is_active := input.is_active;

			if input.is_active = '1' and input.is_invalid = '0' then
				if input.operation = OP_ADD then
					v_output.result := std_logic_vector(unsigned(input.operand1) + unsigned(input.operand2));
				else
					assert false report "Unhandled operation value in execute stage" severity failure;
				end if;

				v_output.destination_reg := input.destination_reg;
			end if;

			output <= v_output;
		end if;
	end process;

end rtl;
