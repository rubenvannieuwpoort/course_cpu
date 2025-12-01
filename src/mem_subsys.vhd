library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;


entity mem_subsys is
	port (
		clk: in std_logic;
		req: in mem_req_t
	);
end mem_subsys;


architecture rtl of mem_subsys is
begin
end rtl;
