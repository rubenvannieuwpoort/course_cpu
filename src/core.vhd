library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity core is
	port (
		clk: in std_logic
	);
end core;


architecture rtl of core is
	signal fetch_output: fetch_output_t;
	signal decode_output: decode_output_t;
	signal execute_output: execute_output_t;
	signal memory_output: memory_output_t;

	component fetch is
		port (
			clk: in std_logic;
			output: out fetch_output_t
		);
	end component;

	component decode is
		port (
			clk: in std_logic;
			input: in fetch_output_t;
			output: out decode_output_t
		);
	end component;

	component execute is
		port (
			clk: in std_logic;
			input: in decode_output_t;
			output: out execute_output_t
		);
	end component;

	component memory is
		port (
			clk: in std_logic;
			input: in execute_output_t;
			output: out memory_output_t
		);
	end component;

	component write is
		port (
			clk: in std_logic;
			input: in memory_output_t
		);
	end component;

begin
	fetch_inst: fetch port map(clk => clk, output => fetch_output);

	decode_inst: decode port map(clk => clk, input => fetch_output, output => decode_output);

	execute_inst: execute port map(clk => clk, input => decode_output, output => execute_output);

	memory_inst: memory port map(clk => clk, input => execute_output, output => memory_output);

	write_inst: write port map(clk => clk, input => memory_output);

end rtl;
