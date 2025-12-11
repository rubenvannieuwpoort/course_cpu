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
		output: out fetch_output_t := DEFAULT_FETCH_OUTPUT
	);
end fetch;


architecture rtl of fetch is
	type instruction_memory_t is array(0 to 31) of std_logic_vector(31 downto 0);
	signal imem: instruction_memory_t := (
		X"deadc0b7", X"eef08093", X"00102023", X"00101223", X"00101523", X"00100623", X"001008a3", X"00100b23",
		X"00100da3", X"00002103", X"00405183", X"00a05203", X"00c04283", X"01104303", X"01604383", X"01b04403",
		X"00401483", X"00a01503", X"00c00583", X"01100603", X"01600683", X"01b00703", X"0000006f", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000"
	);

	signal pc: unsigned(31 downto 0) := (others => '0');

begin
	mem_req.active <= pipeline_ready;
	mem_req.address <= std_logic_vector(pc);

	process (clk)
	begin
		if rising_edge(clk) then
			if pipeline_ready = '1' then
				pc <= pc + 4;

				output.is_active <= '1';
				output.instr <= imem(to_integer(pc(6 downto 2)));
				output.pc <= std_logic_vector(pc);

				assert jump = '0' report "Fetching and jumping at the same cycle is not supported";
			elsif jump = '1' then
				pc <= unsigned(jump_address);
			else
				output <= DEFAULT_FETCH_OUTPUT;
			end if;
		end if;
	end process;

end rtl;
