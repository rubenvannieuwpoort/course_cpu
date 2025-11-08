library ieee;
use ieee.std_logic_1164.all;

use work.core_types.all;


package core_constants is
	constant TYPE_REGISTER  : std_logic := '0';
	constant TYPE_IMMEDIATE : std_logic := '1';

	constant STATUS_NORMAL         : std_logic_vector(1 downto 0) := "00";
	constant STATUS_IGNORE         : std_logic_vector(1 downto 0) := "01";
	constant STATUS_INVALID_OPCODE : std_logic_vector(1 downto 0) := "10";

	constant DEFAULT_DECODER_OUTPUT: dram_port := (
		command_enable => '0',
		command => (others => '0'),
		burst_length => (others => '0'),
		address => (others => '0'),
		write_enable => '0',
		write_mask => (others => '0'),
		write_data => (others => '0'),
		read_enable => '0'
	);
end package core_constants;
