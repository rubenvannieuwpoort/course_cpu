library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;

use work.core_types.all;
use work.core_constants.all;


entity fetch is
	port (
		clk: in std_logic;
		pipeline_ready: in std_logic;
		jump: in std_logic;
		jump_address: in std_logic_vector(31 downto 0);
		mem_req: out mem_read_req_t := DEFAULT_MEM_READ_REQ;
		mem_res: in std_logic_vector(31 downto 0);
		output: out fetch_output_t := DEFAULT_FETCH_OUTPUT
	);
end fetch;


architecture rtl of fetch is
	signal pc: unsigned(31 downto 0) := (others => '0');

begin
	mem_req.active <= pipeline_ready;
	mem_req.address <= std_logic_vector(pc);
	output.instr <= mem_res;

	process (clk)
	begin
		if rising_edge(clk) then
			if pipeline_ready = '1' then
				pc <= pc + 4;

				output.is_active <= '1';
				output.pc <= std_logic_vector(pc);

				assert jump = '0' report "Fetching and jumping at the same cycle is not supported";
			elsif jump = '1' then
				pc <= unsigned(jump_address);
			else
				output.is_active <= DEFAULT_FETCH_OUTPUT.is_active;
				output.pc <= DEFAULT_FETCH_OUTPUT.pc;
			end if;
		end if;
	end process;

end rtl;
