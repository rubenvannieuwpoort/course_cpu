library ieee;
use ieee.std_logic_1164.all;


package core_types is
	type operation_t is (OP_ADD);

	type fetch_output_t is record
		is_active: std_logic;
		instr: std_logic_vector(31 downto 0);
	end record fetch_output_t;

	type decode_output_t is record
		is_active: std_logic;
		operation: operation_t;
		operand1: std_logic_vector(31 downto 0);
		operand2: std_logic_vector(31 downto 0);
		destination_reg: std_logic_vector(4 downto 0);
	end record decode_output_t;

	type execute_output_t is record
		placeholder: std_logic;
	end record execute_output_t;

	type memory_output_t is record
		placeholder: std_logic;
	end record memory_output_t;
end package core_types;
