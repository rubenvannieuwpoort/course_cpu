library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity fetch is
	port (
		clk: in std_logic;
		output: out fetch_output_t := DEFAULT_FETCH_OUTPUT
	);
end fetch;


architecture rtl of fetch is
	type instruction_memory_t is array(0 to 15) of std_logic_vector(31 downto 0);
	signal imem: instruction_memory_t := (
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000"
	);

begin

	process (clk)
	begin
		if rising_edge(clk) then
			-- TODO: implement
		end if;
	end process;

end rtl;
