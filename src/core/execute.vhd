library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.constants.all;

use work.core_types.all;
use work.core_constants.all;


entity execute is
	port (
		clk: in std_logic;
		input: in decode_output_t;
		output: out execute_output_t := DEFAULT_EXECUTE_OUTPUT;
		mem_req: out mem_req_t := DEFAULT_MEM_REQ;
		jump: out std_logic := '0';
		jump_address: out std_logic_vector(31 downto 0) := (others => '0');
		led: out std_logic_vector(7 downto 0) := (others => '0')
	);
end execute;


architecture rtl of execute is
begin

	process (clk)
		variable v_output: execute_output_t;
		variable v_sign: std_logic_vector(31 downto 0);
		variable v_jump: std_logic;
		variable v_jump_address: std_logic_vector(31 downto 0);
		variable v_mem_req: mem_req_t;
		
	begin
		if rising_edge(clk) then
			v_output := DEFAULT_EXECUTE_OUTPUT;
			v_output.is_active := input.is_active;
			v_mem_req := DEFAULT_MEM_REQ;
			v_jump := '0';
			v_jump_address := (others => '0');

			if input.is_active = '1' and input.is_invalid = '0' then
				if input.operation = OP_ADD then
					v_output.result := std_logic_vector(unsigned(input.operand1) + unsigned(input.operand2));
				elsif input.operation = OP_SUB then
					v_output.result := std_logic_vector(unsigned(input.operand1) - unsigned(input.operand2));
				elsif input.operation = OP_SLT then
					if signed(input.operand1) < signed(input.operand2) then
						v_output.result := std_logic_vector(to_unsigned(1, 32));
					else
						v_output.result := (others => '0');
					end if;
				elsif input.operation = OP_SLTU then
					if unsigned(input.operand1) < unsigned(input.operand2) then
						v_output.result := std_logic_vector(to_unsigned(1, 32));
					else
						v_output.result := (others => '0');
					end if;
				elsif input.operation = OP_XOR then
					v_output.result := input.operand1 xor input.operand2;
				elsif input.operation = OP_OR then
					v_output.result := input.operand1 or input.operand2;
				elsif input.operation = OP_AND then
					v_output.result := input.operand1 and input.operand2;
				elsif input.operation = OP_SLL then
					v_output.result := input.operand1;

					if input.operand2(4) = '1' then
						v_output.result := v_output.result(15 downto 0) & "0000000000000000";
					end if;
					if input.operand2(3) = '1' then
						v_output.result := v_output.result(23 downto 0) & "00000000";
					end if;
					if input.operand2(2) = '1' then
						v_output.result := v_output.result(27 downto 0) & "0000";
					end if;
					if input.operand2(1) = '1' then
						v_output.result := v_output.result(29 downto 0) & "00";
					end if;
					if input.operand2(0) = '1' then
						v_output.result := v_output.result(30 downto 0) & "0";
					end if;
				elsif input.operation = OP_SRL or input.operation = OP_SRA then
					v_output.result := input.operand1;

					if input.operation = OP_SRL then
						v_sign := (others => '0');
					else
						v_sign := (others => input.operand1(31));
					end if;

					if input.operand2(4) = '1' then
						v_output.result := v_sign(15 downto 0) & v_output.result(31 downto 16);
					end if;
					if input.operand2(3) = '1' then
						v_output.result := v_sign(7 downto 0) & v_output.result(31 downto 8);
					end if;
					if input.operand2(2) = '1' then
						v_output.result := v_sign(3 downto 0) & v_output.result(31 downto 4);
					end if;
					if input.operand2(1) = '1' then
						v_output.result := v_sign(2 downto 0) & v_output.result(31 downto 3);
					end if;
					if input.operand2(0) = '1' then
						v_output.result := v_sign(1 downto 0) & v_output.result(31 downto 2);
					end if;
				elsif input.operation = OP_JAL then
					v_jump := '1';
					v_jump_address := std_logic_vector(unsigned(input.operand1) + unsigned(input.operand2));
					v_output.result := input.operand3;
				elsif input.operation = OP_BEQ then
					if input.operand1 = input.operand2 then
						v_jump := '1';
						v_jump_address := input.operand3;
					end if;
				elsif input.operation = OP_BNE then
					if input.operand1 /= input.operand2 then
						v_jump := '1';
						v_jump_address := input.operand3;
					end if;
				elsif input.operation = OP_BLT then
					if signed(input.operand1) < signed(input.operand2) then
						v_jump := '1';
						v_jump_address := input.operand3;
					end if;
				elsif input.operation = OP_BGE then
					if signed(input.operand1) >= signed(input.operand2) then
						v_jump := '1';
						v_jump_address := input.operand3;
					end if;
				elsif input.operation = OP_BLTU then
					if unsigned(input.operand1) < unsigned(input.operand2) then
						v_jump := '1';
						v_jump_address := input.operand3;
					end if;
				elsif input.operation = OP_BGEU then
					if unsigned(input.operand1) >= unsigned(input.operand2) then
						v_jump := '1';
						v_jump_address := input.operand3;
					end if;
				elsif input.operation = OP_SW then
					v_mem_req.active := '1';
					v_mem_req.write := '1';
					v_mem_req.address := input.operand1;
					v_mem_req.value := input.operand2;
				elsif input.operation = OP_LW then
					v_output.use_mem := '1';
					v_mem_req.active := '1';
					v_mem_req.write := '0';
					v_mem_req.address := input.operand1;
				elsif input.operation = OP_LED then
					led <= input.operand1(7 downto 0);
				else
					assert false report "Unhandled operation value in execute stage" severity failure;
				end if;

				v_output.destination_reg := input.destination_reg;
			end if;

			output <= v_output;

			mem_req <= v_mem_req;

			jump <= v_jump;
			jump_address <= v_jump_address(31 downto 1) & "0";
		end if;
	end process;

end rtl;
