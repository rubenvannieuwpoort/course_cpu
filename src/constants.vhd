library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;


package constants is
	constant DEFAULT_MEM_REQ: mem_req_t := (
		active => '0',
		write_enable => "0000",
		address => (others => '0'),
		value => (others => '0')
	);

	constant DEFAULT_MEM_READ_REQ: mem_read_req_t := (
		active => '0',
		address => (others => '0')
	);

	constant MEM_ADDRESS_BITS: integer := 14;
	constant MEM_ADDRESS_MIN: std_logic_vector(31 downto 0) := (others => '0');
	constant MEM_ADDRESS_MAX: std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned((2**MEM_ADDRESS_BITS) - 1, 32));
end package constants;
