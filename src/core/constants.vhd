library ieee;
use ieee.std_logic_1164.all;

use work.core_types.all;


package core_constants is
	constant DEFAULT_FETCH_OUTPUT: fetch_output_t := (
		is_active => '0',
		instr => (others => '0')
	);

	constant DEFAULT_DECODE_OUTPUT: decode_output_t := (
		operation => OP_ADD,
		operand1 => (others => '0'),
		operand2 => (others => '0'),
		destination_reg => (others => '0')
	);

	constant DEFAULT_EXECUTE_OUTPUT: execute_output_t := (
		placeholder => '0'
	);

	constant DEFAULT_MEMORY_OUTPUT: memory_output_t := (
		placeholder => '0'
	);
end package core_constants;
