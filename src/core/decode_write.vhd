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
		mem_res: in std_logic_vector(31 downto 0);
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

		variable b_imm: std_logic_vector(12 downto 0);
		variable b_imm_s: std_logic_vector(31 downto 0);
		variable i_imm: std_logic_vector(11 downto 0);
		variable i_imm_s: std_logic_vector(31 downto 0);
		variable j_imm: std_logic_vector(20 downto 0);
		variable j_imm_s: std_logic_vector(31 downto 0);
		variable s_imm: std_logic_vector(11 downto 0);
		variable s_imm_s: std_logic_vector(31 downto 0);
		variable u_imm: std_logic_vector(31 downto 0);

		variable v_decode_output: decode_output_t;
	begin
		if rising_edge(clk) then
			-- write back result if the destination register is not x0 (which always stays 0)
			if write_input.destination_reg /= "00000" then
				if write_input.use_mem = '1' then
					reg(to_integer(unsigned(write_input.destination_reg))) <= mem_res;
				else
					reg(to_integer(unsigned(write_input.destination_reg))) <= write_input.result;
				end if;
			end if;

			pipeline_ready <= write_input.is_active;

			opcode := decode_input.instr(6 downto 0);
			rs1    := decode_input.instr(19 downto 15);
			rs2    := decode_input.instr(24 downto 20);
			funct3 := decode_input.instr(14 downto 12);
			funct7 := decode_input.instr(31 downto 25);
			rd     := decode_input.instr(11 downto 7);

			b_imm := decode_input.instr(31) & decode_input.instr(7) & decode_input.instr(30 downto 25) & decode_input.instr(11 downto 8) & "0";
			i_imm := decode_input.instr(31 downto 20);
			j_imm := decode_input.instr(31) & decode_input.instr(19 downto 12) & decode_input.instr(20) & decode_input.instr(30 downto 21) & "0";
			s_imm := decode_input.instr(31 downto 25) & decode_input.instr(11 downto 7);
			u_imm := decode_input.instr(31 downto 12) & "000000000000";

			-- sign extension
			b_imm_s := std_logic_vector(resize(signed(b_imm), 32));
			i_imm_s := std_logic_vector(resize(signed(i_imm), 32));
			j_imm_s := std_logic_vector(resize(signed(j_imm), 32));
			s_imm_s := std_logic_vector(resize(signed(s_imm), 32));

			v_decode_output := DEFAULT_DECODE_OUTPUT;

			if decode_input.is_active = '1' then
				v_decode_output.is_active := '1';
				v_decode_output.is_invalid := '0';

				if opcode = "0110111" then
					-- LUI
					v_decode_output.operation := OP_ADD;
					v_decode_output.operand1 := (others => '0');
					v_decode_output.operand2 := u_imm;
					v_decode_output.destination_reg := rd;
				elsif opcode = "0010111" then
					-- AUIPC
					v_decode_output.operation := OP_ADD;
					v_decode_output.operand1 := decode_input.pc;
					v_decode_output.operand2 := u_imm;
					v_decode_output.destination_reg := rd;
				elsif opcode = "1101111" then
					-- JAL
					v_decode_output.operation := OP_JAL;
					v_decode_output.operand1 := decode_input.pc;
					v_decode_output.operand2 := j_imm_s;
					v_decode_output.operand3 := std_logic_vector(unsigned(decode_input.pc) + 4);
					v_decode_output.destination_reg := rd;
				elsif opcode = "1100111" and funct3 = "000" then
					-- JALR
					v_decode_output.operation := OP_JAL;
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := i_imm_s;
					v_decode_output.operand3 := std_logic_vector(unsigned(decode_input.pc) + 4);
					v_decode_output.destination_reg := rd;
				elsif opcode = "1100011" then
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := reg(to_integer(unsigned(rs2)));
					v_decode_output.operand3 := std_logic_vector(unsigned(decode_input.pc) + unsigned(b_imm_s));

					if funct3 = "000" then
						-- BEQ
						v_decode_output.operation := OP_BEQ;
					elsif funct3 = "001" then
						-- BNE
						v_decode_output.operation := OP_BNE;
					elsif funct3 = "100" then
						-- BLT
						v_decode_output.operation := OP_BLT;
					elsif funct3 = "101" then
						-- BGE
						v_decode_output.operation := OP_BGE;
					elsif funct3 = "110" then
						-- BLTU
						v_decode_output.operation := OP_BLTU;
					elsif funct3 = "111" then
						-- BGEU
						v_decode_output.operation := OP_BGEU;
					else
						v_decode_output.is_invalid := '1';
					end if;
				elsif opcode = "0000011" then
					-- load instructions
					v_decode_output.operand1 := std_logic_vector(unsigned(reg(to_integer(unsigned(rs1)))) + unsigned(i_imm_s));
					v_decode_output.destination_reg := rd;

					if funct3 = "000" then
						-- TODO: LB
					elsif funct3 = "001" then
						-- TODO: LH
					elsif funct3 = "010" then
						-- LW
						v_decode_output.operation := OP_LW;
					elsif funct3 = "100" then
						-- TODO: LBU
					elsif funct3 = "101" then
						-- TODO: LHU
					else
						v_decode_output.is_invalid := '1';
					end if;
				elsif opcode = "0100011" then
					-- store instructions
					v_decode_output.operand1 := std_logic_vector(unsigned(reg(to_integer(unsigned(rs1)))) + unsigned(s_imm_s));
					v_decode_output.operand2 := reg(to_integer(unsigned(rs2)));

					if funct3 = "000" then
						-- TODO: SB
					elsif funct3 = "001" then
						-- TODO: SH
					elsif funct3 = "010" then
						-- SW
						v_decode_output.operation := OP_SW;
					else
						v_decode_output.is_invalid := '1';
					end if;
				elsif opcode = "0010011" and funct3 = "001" and funct7 = "0000000" then
					-- SLLI
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := "000000000000000000000000000" & rs2;
					v_decode_output.destination_reg := rd;
					v_decode_output.operation := OP_SLL;
				elsif opcode = "0010011" and funct3 = "101" then
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := "000000000000000000000000000" & rs2;
					v_decode_output.destination_reg := rd;

					if funct7 = "0000000" then
						-- SRLI
						v_decode_output.operation := OP_SRL;
					elsif funct7 = "0000001" then
						-- SRAI
						v_decode_output.operation := OP_SRA;
					else
						v_decode_output.is_invalid := '1';
					end if;
				elsif opcode = "0010011" then
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := i_imm_s;
					v_decode_output.destination_reg := rd;

					if funct3 = "000" then
						-- ADDI
						v_decode_output.operation := OP_ADD;
					elsif funct3 = "010" then
						-- SLTI
						v_decode_output.operation := OP_SLT;
					elsif funct3 = "011" then
						-- SLTIU
						v_decode_output.operation := OP_SLTU;
					elsif funct3 = "100" then
						-- XORI
						v_decode_output.operation := OP_XOR;
					elsif funct3 = "110" then
						-- ORI
						v_decode_output.operation := OP_OR;
					elsif funct3 = "111" then
						-- ANDI
						v_decode_output.operation := OP_AND;
					else
						v_decode_output.is_invalid := '1';
					end if;
				elsif opcode = "0110011" then
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := reg(to_integer(unsigned(rs2)));
					v_decode_output.destination_reg := rd;

					if funct7 = "0000000" and funct3 = "000" then
						-- ADD
						v_decode_output.operation := OP_ADD;
					elsif funct7 = "0100000" and funct3 = "000" then
						-- SUB
						v_decode_output.operation := OP_SUB;
					elsif funct7 = "0000000" and funct3 = "001" then
						-- SLL
						v_decode_output.operation := OP_SLL;
					elsif funct7 = "0000000" and funct3 = "010" then
						-- SLT
						v_decode_output.operation := OP_SLT;
					elsif funct7 = "0000000" and funct3 = "011" then
						-- SLTU
						v_decode_output.operation := OP_SLTU;
					elsif funct7 = "0000000" and funct3 = "100" then
						-- XOR
						v_decode_output.operation := OP_XOR;
					elsif funct7 = "0000000" and funct3 = "101" then
						-- SRL
						v_decode_output.operation := OP_SRL;
					elsif funct7 = "0100000" and funct3 = "101" then
						-- SRA
						v_decode_output.operation := OP_SRA;
					elsif funct7 = "0000000" and funct3 = "110" then
						-- OR
						v_decode_output.operation := OP_OR;
					elsif funct7 = "0000000" and funct3 = "111" then
						-- AND
						v_decode_output.operation := OP_AND;
					else
						v_decode_output.is_invalid := '1';
					end if;
				elsif funct3 = "000" and opcode = "0001111" then
					-- FENCE (implemented as NOP)
				elsif i_imm = "000000000000" and rs1 = "00000" and funct3 = "000" and rd = "00000" and opcode = "1110011" then
					-- ECALL
				elsif i_imm = "000000000001" and rs1 = "00000" and funct3 = "000" and rd = "00000" and opcode = "1110011" then
					-- EBREAK
				elsif opcode = "1111111" and funct3 = "000" then
					-- LED (custom instruction): set the LEDs to the 8 least significant bits of rs1
					v_decode_output.operation := OP_LED;
					v_decode_output.operand1 := reg(to_integer(unsigned(rs1)));
					v_decode_output.operand2 := (others => '0');
					v_decode_output.destination_reg := (others => '0');
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
