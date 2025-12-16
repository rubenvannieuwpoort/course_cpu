library ieee;
use ieee.std_logic_1164.all;

use work.core_types.all;


package core_constants is
	constant DEFAULT_FETCH_OUTPUT: fetch_output_t := (
		is_active => '0',
		instr => (others => 'Z'),
		pc => (others => '0')
	);

	constant DEFAULT_DECODE_OUTPUT: decode_output_t := (
		is_active => '0',
		is_invalid => '0',
		operation => OP_ADD,
		operand1 => (others => '0'),
		operand2 => (others => '0'),
		operand3 => (others => '0'),
		destination_reg => (others => '0'),
		csr_read_only => '0'
	);

	constant DEFAULT_EXECUTE_OUTPUT: execute_output_t := (
		is_active => '0',
		result => (others => '0'),
		destination_reg => (others => '0'),
		use_mem => '0',
		mem_sign_extend => '0',
		mem_size => SIZE_WORD,
		mem_addr => "00"
	);

	-- privileged CSRs
	constant CSR_MVENDORID: std_logic_vector(11 downto 0) := X"F11";
	constant CSR_MARCHID: std_logic_vector(11 downto 0) := X"F12";
	constant CSR_MIMPID: std_logic_vector(11 downto 0) := X"F13";
	constant CSR_MHARTID: std_logic_vector(11 downto 0) := X"F14";
	constant CSR_MCONFIGPTR: std_logic_vector(11 downto 0) := X"F15";

	constant CSR_MSTATUS: std_logic_vector(11 downto 0) := X"300";
	constant CSR_MISA: std_logic_vector(11 downto 0) := X"301";
	constant CSR_MIE: std_logic_vector(11 downto 0) := X"304";
	constant CSR_MTVEC: std_logic_vector(11 downto 0) := X"305";
	constant CSR_MSTATUSH: std_logic_vector(11 downto 0) := X"310";

	constant CSR_MSCRATCH: std_logic_vector(11 downto 0) := X"340";
	constant CSR_MEPC: std_logic_vector(11 downto 0) := X"341";
	constant CSR_MCAUSE: std_logic_vector(11 downto 0) := X"342";
	constant CSR_MTVAL: std_logic_vector(11 downto 0) := X"343";
	constant CSR_MIP: std_logic_vector(11 downto 0) := X"344";

	constant CSR_MCYCLE: std_logic_vector(11 downto 0) := X"B00";
	constant CSR_MINSTRET: std_logic_vector(11 downto 0) := X"B02";
	constant CSR_MHPMCOUNTER3: std_logic_vector(11 downto 0) := X"B03";
	-- ...
	constant CSR_MHPMCOUNTER31: std_logic_vector(11 downto 0) := X"B1F";
	constant CSR_MCYCLEH: std_logic_vector(11 downto 0) := X"B80";
	constant CSR_MINSTRETH: std_logic_vector(11 downto 0) := X"B82";
	constant CSR_MHPMCOUNTER3H: std_logic_vector(11 downto 0) := X"B83";
	-- ...
	constant CSR_MHPMCOUNTER31H: std_logic_vector(11 downto 0) := X"B9F";

	constant CSR_MHPMEVENT3: std_logic_vector(11 downto 0) := X"323";
	-- ...
	constant CSR_MHPMEVENT31: std_logic_vector(11 downto 0) := X"33f";
	constant CSR_MHPMEVENT3H: std_logic_vector(11 downto 0) := X"723";
	-- ...
	constant CSR_MHPMEVENT31H: std_logic_vector(11 downto 0) := X"73f";
end package core_constants;
