library ieee;
use ieee.std_logic_1164.all;


package core_types is
	type fetch_output_t is record
		placeholder: std_logic;
	end record fetch_output_t;

	type decode_output_t is record
		placeholder: std_logic;
	end record decode_output_t;

	type execute_output_t is record
		placeholder: std_logic;
	end record execute_output_t;

	type memory_output_t is record
		placeholder: std_logic;
	end record memory_output_t;
end package core_types;
