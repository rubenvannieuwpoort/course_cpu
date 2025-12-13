library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;


entity mem_subsys is
	port (
		clk: in std_logic;
		req_1: in mem_req_t;
		req_2: in mem_read_req_t;
		res_1: out std_logic_vector(31 downto 0);
		res_2: out std_logic_vector(31 downto 0)
	);
end mem_subsys;


architecture rtl of mem_subsys is
	component bram is
		port(
			clka: in std_logic;
			ena: in std_logic;
			wea: in std_logic_vector(3 downto 0);
			addra: in std_logic_vector(11 downto 0);
			dia: in std_logic_vector(31 downto 0);
			doa: out std_logic_vector(31 downto 0);
			clkb: in std_logic;
			enb: in std_logic;
			addrb: in std_logic_vector(11 downto 0);
			dob: out std_logic_vector(31 downto 0)
		);
	end component;

begin
	bram_inst: bram port map(
		clka => clk, ena => req_1.active, wea => req_1.write_enable, addra => req_1.address(13 downto 2), dia => req_1.value, doa => res_1,
		clkb => clk, enb => req_2.active, addrb => req_2.address(13 downto 2), dob => res_2
	);

end rtl;
