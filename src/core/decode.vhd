library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity decode is
	port (
		clk_in: in std_logic;
		opcode_in: out std_logic_vector(31 downto 0);
		output: out decode_output_type
	);
end decode;


architecture behavioral of decode is
begin
end behavioral;
