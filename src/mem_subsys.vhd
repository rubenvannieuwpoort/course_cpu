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
	component bram is
        generic(
            SIZE: integer := 1024;
            ADDR_WIDTH: integer := 10;
            COL_WIDTH: integer := 8;
            NB_COL: integer := 4
        );
		port(
			clka: in std_logic;
			ena: in std_logic;
			wea: in std_logic_vector(NB_COL - 1 downto 0);
			addra: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
			dia: in std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);
			doa: out std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0)
		);
	end component;

begin
	bram_inst: bram port map(clka => clk, ena => req.active, wea => req.write_enable, addra => req.address(11 downto 2), dia => req.value, doa => res);

end rtl;
