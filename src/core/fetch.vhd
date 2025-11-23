library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity fetch is
	port (
		clk: in std_logic;
		pipeline_ready: in std_logic;
		output: out fetch_output_t := DEFAULT_FETCH_OUTPUT
	);
end fetch;


architecture rtl of fetch is
	type instruction_memory_t is array(0 to 15) of std_logic_vector(31 downto 0);
	signal imem: instruction_memory_t := (
		X"00108093", X"00108093", X"00000003", X"00000004", X"00000005", X"00000006", X"00000007", X"00000008",
		X"00000009", X"0000000A", X"0000000B", X"0000000C", X"0000000D", X"0000000E", X"0000000F", X"00000010"
	);

	signal pc: unsigned(31 downto 0) := (others => '0');

begin

	process (clk)
	begin
		if rising_edge(clk) then
			if pipeline_ready = '1' then
				pc <= pc + 4;

				output.is_active <= '1';
				output.instr <= imem(to_integer(pc(5 downto 2)));
			else
				output <= DEFAULT_FETCH_OUTPUT;
			end if;
		end if;
	end process;

end rtl;
