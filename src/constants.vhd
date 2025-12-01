library ieee;
use ieee.std_logic_1164.all;

use work.types.all;


package constants is
	constant DEFAULT_MEM_REQ: mem_req_t := (
		active => '0',
		address => (others => '0'),
		value => (others => '0')
	);
end package constants;
