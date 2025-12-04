library ieee;
use ieee.std_logic_1164.all;


package types is
	type mem_cmd_t is (MEM_CMD_READ, MEM_CMD_WRITE);

	type mem_req_t is record
		active: std_logic;
		cmd: mem_cmd_t;
		address: std_logic_vector(31 downto 0);
		value: std_logic_vector(31 downto 0);
	end record mem_req_t;
end package types;
