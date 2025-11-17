library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity decode is
	port (
		clk: in std_logic;
		output: out decode_output_t := DEFAULT_DECODE_OUTPUT
	);
end decode;


architecture rtl of decode is
begin

	process (clk)
	begin
		if rising_edge(clk) then
			-- TODO: implement
		end if;
	end process;

end rtl;
