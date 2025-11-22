library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity decode is
	port (
		clk: in std_logic;
		input: in fetch_output_t;
		output: out decode_output_t := DEFAULT_DECODE_OUTPUT
	);
end decode;


architecture rtl of decode is
	type registers is array(0 to 31) of std_logic_vector(31 downto 0);
	signal reg: registers := (others => (others => '0'));

begin

	process (clk)
		variable opcode: std_logic_vector(6 downto 0);
		variable funct3: std_logic_vector(2 downto 0);
		variable rs1, rs2, rd : std_logic_vector(4 downto 0);

		variable i_imm: std_logic_vector(11 downto 0);
		variable i_imm_s: std_logic_vector(31 downto 0);
	begin
		if rising_edge(clk) then
			opcode := input.instr(6 downto 0);
			rs1    := input.instr(19 downto 15);
			rs2    := input.instr(24 downto 20);
			funct3 := input.instr(14 downto 12);
			rd     := input.instr(11 downto 7);

			i_imm := input.instr(31 downto 20);
			i_imm_s := std_logic_vector(resize(signed(i_imm), 32));

			if input.is_active = '1' then
				if opcode = "0010011" and funct3 = "000" then
					-- ADDI rd, rs, imm (I-type): sets rd to the sum of rs1 and the sign-extended immediate
					output.operation <= OP_ADD;
					output.operand1 <= (others => '0');  -- TODO: load value from register
					output.operand2 <= i_imm_s;
					output.destination_reg <= rd;
				end if;
			else
				output <= DEFAULT_DECODE_OUTPUT;
			end if;
		end if;
	end process;

end rtl;
