library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity execute is
	port (
		clk: in std_logic;
		input: in decode_output_t;
		output: out execute_output_t := DEFAULT_EXECUTE_OUTPUT;
		led: out std_logic_vector(7 downto 0) := (others => '0')
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
				elsif input.operation = OP_SLT then
					if signed(input.operand1) < signed(input.operand2) then
						v_output.result := std_logic_vector(to_unsigned(1, 32));
					else
						v_output.result := (others => '0');
					end if;
				elsif input.operation = OP_SLTU then
					if unsigned(input.operand1) < unsigned(input.operand2) then
						v_output.result := std_logic_vector(to_unsigned(1, 32));
					else
						v_output.result := (others => '0');
					end if;
				elsif input.operation = OP_XOR then
					v_output.result := input.operand1 xor input.operand2;
				elsif input.operation = OP_OR then
					v_output.result := input.operand1 or input.operand2;
				elsif input.operation = OP_AND then
					v_output.result := input.operand1 and input.operand2;
				elsif input.operation = OP_LED then
					led <= input.operand1(7 downto 0);
				else
					assert false report "Unhandled operation value in execute stage" severity failure;
				end if;

				v_output.destination_reg := input.destination_reg;
			end if;

			output <= v_output;
		end if;
	end process;

end rtl;
