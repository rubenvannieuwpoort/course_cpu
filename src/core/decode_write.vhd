library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_types.all;
use work.core_constants.all;


entity decode_write is
	port (
		clk: in std_logic;

		decode_input: in fetch_output_t;
		decode_output: out decode_output_t := DEFAULT_DECODE_OUTPUT;

		write_input: in memory_output_t;
		pipeline_ready: out std_logic := '1'
	);
end decode_write;


architecture rtl of decode_write is
	type registers is array(0 to 31) of std_logic_vector(31 downto 0);
	signal reg: registers := (others => (others => '0'));

begin

	process (clk)
		variable opcode: std_logic_vector(6 downto 0);
		variable funct3: std_logic_vector(2 downto 0);
		variable funct7: std_logic_vector(6 downto 0);
		variable rs1, rs2, rd : std_logic_vector(4 downto 0);

		variable i_imm: std_logic_vector(11 downto 0);
		variable i_imm_s: std_logic_vector(31 downto 0);

		variable v_decode_output: decode_output_t;
	begin
		if rising_edge(clk) then
			-- write back result if the destination register is not x0 (which always stays 0)
			if write_input.destination_reg /= "00000" then
				reg(to_integer(unsigned(write_input.destination_reg))) <= write_input.result;
			end if;

			pipeline_ready <= write_input.is_active;

			opcode := decode_input.instr(6 downto 0);
			rs1    := decode_input.instr(19 downto 15);
			rs2    := decode_input.instr(24 downto 20);
			funct3 := decode_input.instr(14 downto 12);
			funct7 := decode_input.instr(31 downto 25);
			rd     := decode_input.instr(11 downto 7);

			i_imm := decode_input.instr(31 downto 20);
			i_imm_s := std_logic_vector(resize(signed(i_imm), 32));

			v_decode_output := DEFAULT_DECODE_OUTPUT;

			if decode_input.is_active = '1' then
				v_decode_output.is_active := '1';
				v_decode_output.is_invalid := '0';

				if opcode = "0010011" and funct3 = "000" then
					-- ADDI rd, rs, imm (I-type): sets rd to the sum of rs1 and the sign-extended immediate
					v_decode_output.operation := OP_ADD;
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := i_imm_s;
					v_decode_output.destination_reg := rd;
				elsif opcode = "0110011" and funct3 = "000" and funct7 = "0000000" then
					-- ADD rd, rs1, rs2 (R-type): sets rd to the sum of rs1 and rs2
					v_decode_output.operation := OP_ADD;
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := reg(to_integer(unsigned(rs2)));
					v_decode_output.destination_reg := rd;
				elsif opcode = "1111111" and funct3 = "000" then
					-- LED rs1: set the LEDs to the 8 least significant bits of rs1
					v_decode_output.operation := OP_LED;
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := (others => '0');
					v_decode_output.destination_reg := (others => '0');
				elsif opcode = "1111111" and funct3 = "001" then
					-- HANG
					v_decode_output := DEFAULT_DECODE_OUTPUT;
				else
					v_decode_output.is_invalid := '1';
				end if;
			else
				decode_output <= DEFAULT_DECODE_OUTPUT;
			end if;

			decode_output <= v_decode_output;
		end if;
	end process;

end rtl;
