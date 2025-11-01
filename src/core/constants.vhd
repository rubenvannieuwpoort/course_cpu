library ieee;
use ieee.std_logic_1164.all;

use work.core_types.all;


package core_constants is
	constant TYPE_REGISTER  : std_logic := '0';
	constant TYPE_IMMEDIATE : std_logic := '1';
end package core_constants;
