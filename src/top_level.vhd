library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;


entity top_level is
	port (
		clk: in std_logic;
		led: out std_logic_vector(7 downto 0)
	);
end top_level;


architecture rtl of top_level is
	signal mem_req: mem_req_t;
	signal mem_res: std_logic_vector(31 downto 0);

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
			req: in mem_req_t;
			res: out std_logic_vector(31 downto 0)
		);
	end component;

begin

	core_inst: core port map(clk => clk, mem_req => mem_req, mem_res => mem_res, led => led);

	mem_subsys_inst: mem_subsys port map(clk => clk, req => mem_req, res => mem_res);

end rtl;
