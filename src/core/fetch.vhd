library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity fetch is
	port (
		clk: in std_logic;
		pipeline_ready: in std_logic;
		jump: in std_logic;
		jump_address: in std_logic_vector(31 downto 0);
		output: out fetch_output_t := DEFAULT_FETCH_OUTPUT
	);
end fetch;


architecture rtl of fetch is
	type instruction_memory_t is array(0 to 15) of std_logic_vector(31 downto 0);
	signal imem: instruction_memory_t := (
		X"00112023", X"00108093", X"00209113", X"ff5ff06f", X"00000000", X"00000000", X"00000000", X"00000000",
		X"0000006f", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000"
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
				output.pc <= std_logic_vector(pc);

				assert jump = '0' report "Fetching and jumping at the same cycle is not supported";
			elsif jump = '1' then
				pc <= unsigned(jump_address);
			else
				output <= DEFAULT_FETCH_OUTPUT;
			end if;
		end if;
	end process;

end rtl;
