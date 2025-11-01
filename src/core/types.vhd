library ieee;
use ieee.std_logic_1164.all;


package core_types is
	type decode_output_type is record
		alu_function: std_logic_vector(4 downto 0);

		writeback_register: std_logic_vector(4 downto 0);

		operand_1_type: std_logic;
		operand_1_immediate: std_logic_vector(31 downto 0);
		operand_1_register: std_logic_vector(4 downto 0);

		operand_2_type: std_logic;
		operand_2_immediate: std_logic_vector(31 downto 0);
		operand_2_register: std_logic_vector(4 downto 0);
	end record decode_output_type;
end package core_types;
