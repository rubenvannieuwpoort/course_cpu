library ieee;
use ieee.std_logic_1164.all;


package core_types is
	type operation_t is (
		OP_ADD,
		OP_SLT,
		OP_SLTU,
		OP_XOR,
		OP_OR,
		OP_AND,
		OP_SLL,
		OP_SRL,
		OP_SRA,
		OP_SUB,
		OP_JAL,
		OP_BEQ,
		OP_BNE,
		OP_BLT,
		OP_BGE,
		OP_BLTU,
		OP_BGEU,
		OP_SB,
		OP_SH,
		OP_SW,
		OP_LW,
		OP_LED
	);

	type fetch_output_t is record
		is_active: std_logic;
		instr: std_logic_vector(31 downto 0);
		pc: std_logic_vector(31 downto 0);
	end record fetch_output_t;

	type decode_output_t is record
		is_active: std_logic;
		is_invalid: std_logic;
		operation: operation_t;
		operand1: std_logic_vector(31 downto 0);
		operand2: std_logic_vector(31 downto 0);
		operand3: std_logic_vector(31 downto 0);
		destination_reg: std_logic_vector(4 downto 0);
	end record decode_output_t;

	type execute_output_t is record
		is_active: std_logic;
		use_mem: std_logic;
		result: std_logic_vector(31 downto 0);
		destination_reg: std_logic_vector(4 downto 0);
	end record execute_output_t;
end package core_types;
