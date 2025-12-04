library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;


entity mem_subsys is
	port (
		clk: in std_logic;
		req: in mem_req_t;
		res: out std_logic_vector(31 downto 0)
	);
end mem_subsys;


architecture rtl of mem_subsys is
	type ram_t is array (0 to 1023) of std_logic_vector(31 downto 0);
	signal ram: ram_t := (others => (others => '0'));

begin

	process (clk)
	begin
		if rising_edge(clk) then
			if req.active = '1' then
				if req.cmd = MEM_CMD_WRITE then
					ram(to_integer(unsigned(req.address(11 downto 2)))) <= req.value;
				else
					res <= ram(to_integer(unsigned(req.address(11 downto 2))));
				end if;
			else
				res <= (others => '0');
			end if;
		end if;
	end process;
end rtl;
