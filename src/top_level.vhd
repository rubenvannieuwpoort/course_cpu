library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;


entity top_level is
	port (
		clk: in std_logic;
		led: out std_logic_vector(7 downto 0)
	);
end top_level;


architecture rtl of top_level is
	signal mem_req_1: mem_req_t;
	signal mem_req_2: mem_read_req_t := DEFAULT_MEM_READ_REQ;
	signal mem_res_1, mem_res_2: std_logic_vector(31 downto 0);

	component core is
		port (
			clk: in std_logic;
			mem_req: out mem_req_t;
			mem_res: in std_logic_vector(31 downto 0);
			led: out std_logic_vector(7 downto 0)
		);
	end component;

	component mem_subsys is
		port (
			clk: in std_logic;
			req_1: in mem_req_t;
			req_2: in mem_read_req_t;
			res_1: out std_logic_vector(31 downto 0);
			res_2: out std_logic_vector(31 downto 0)
		);
	end component;

begin

	core_inst: core port map(clk => clk, mem_req => mem_req_1, mem_res => mem_res_1, led => led);

	mem_subsys_inst: mem_subsys port map(clk => clk, req_1 => mem_req_1, res_1 => mem_res_1, req_2 => mem_req_2, res_2 => open);

end rtl;
