library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fetch is
	port (
		clk_in: in std_logic
	);
end fetch;


architecture rtl of fetch is
	type instr_list is array(0 to 15) of std_logic_vector(31 downto 0);
	signal instructions: instr_list := (
		X"00000000", X"00000001", X"00000002", X"00000003", X"00000004", X"00000005", X"00000006", X"00000007",
		X"00000008", X"00000009", X"0000000a", X"0000000b", X"0000000c", X"0000000d", X"0000000e", X"0000000f"
	);

	signal pc: unsigned(31 downto 0) := (others => '0');
begin
	process(clk_in)
	begin
		if rising_edge(clk_in) then
			pc <= pc + 4;
		end if;
	end process;

end rtl;
