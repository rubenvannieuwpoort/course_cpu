library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;

use work.core_types.all;
use work.core_constants.all;


entity core is
	port (
		clk: in std_logic;
		mem_req_1: out mem_req_t;
		mem_req_2: out mem_read_req_t;
		mem_res_1: in std_logic_vector(31 downto 0);
		mem_res_2: in std_logic_vector(31 downto 0);
		led: out std_logic_vector(7 downto 0)
	);
end core;


architecture rtl of core is
	signal fetch_output: fetch_output_t;
	signal decode_output: decode_output_t;
	signal execute_output: execute_output_t;
	signal memory_output: execute_output_t;
	signal pipeline_ready: std_logic;
	signal jump: std_logic;
	signal jump_address: std_logic_vector(31 downto 0);

	component fetch is
		port (
			clk: in std_logic;
			pipeline_ready: in std_logic;
			jump: in std_logic;
			jump_address: in std_logic_vector(31 downto 0);
			mem_req: out mem_read_req_t;
			output: out fetch_output_t
		);
	end component;

	component decode_write is
		port (
			clk: in std_logic;
			decode_input: in fetch_output_t;
			decode_output: out decode_output_t;
			write_input: in execute_output_t;
			mem_res: in std_logic_vector(31 downto 0);
			pipeline_ready: out std_logic
		);
	end component;

	component execute is
		port (
			clk: in std_logic;
			input: in decode_output_t;
			output: out execute_output_t;
			mem_req: out mem_req_t;
			jump: out std_logic := '0';
			jump_address: out std_logic_vector(31 downto 0);
			led: out std_logic_vector(7 downto 0)
		);
	end component;

	component memory is
		port (
			clk: in std_logic;
			input: in execute_output_t;
			output: out execute_output_t
		);
	end component;

begin
	fetch_inst: fetch port map(clk => clk, pipeline_ready => pipeline_ready, jump => jump, jump_address => jump_address, mem_req => mem_req_2, output => fetch_output);

	decode_write_inst: decode_write port map(clk => clk, decode_input => fetch_output, decode_output => decode_output, write_input => memory_output, mem_res => mem_res_1, pipeline_ready => pipeline_ready);

	execute_inst: execute port map(clk => clk, input => decode_output, output => execute_output, mem_req => mem_req_1, jump => jump, jump_address => jump_address, led => led);

	memory_inst: memory port map(clk => clk, input => execute_output, output => memory_output);

end rtl;
