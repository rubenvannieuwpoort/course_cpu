library ieee;
use ieee.std_logic_1164.all;

use work.core_types.all;


package core_constants is
	constant DEFAULT_FETCH_OUTPUT: fetch_output_t := ();
	constant DEFAULT_DECODE_OUTPUT: decode_output_t := ();
	constant DEFAULT_EXECUTE_OUTPUT: execute_output_t := ();
	constant DEFAULT_MEMORY_OUTPUT: memory_output_t := ();
end package core_constants;
