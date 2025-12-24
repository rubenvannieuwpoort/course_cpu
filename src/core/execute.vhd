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
		instr_retire: in std_logic;
		output: out execute_output_t := DEFAULT_EXECUTE_OUTPUT;
		mem_req: out mem_req_t := DEFAULT_MEM_REQ;
		jump: out std_logic := '0';
		jump_address: out std_logic_vector(31 downto 0) := (others => '0');
		led: out std_logic_vector(7 downto 0) := (others => '0')
	);
end execute;


architecture rtl of execute is
	signal mstatus_mpie, mstatus_mie: std_logic := '0';
	signal mtie: std_logic := '0';
	signal mtvec_address: std_logic_vector(29 downto 0) := (others => '0');
	signal mtvec_mode: std_logic := '0';
	signal mscratch: std_logic_vector(31 downto 0) := (others => '0');
	signal mepc: std_logic_vector(29 downto 0) := (others => '0');
	signal mcause_int: std_logic := '0';
	signal mcause_code: std_logic_vector(3 downto 0) := (others => '0');
	signal mtval: std_logic_vector(31 downto 0) := (others => '0');
	signal mcycle: std_logic_vector(31 downto 0) := (others => '0');
	signal minstret: std_logic_vector(31 downto 0) := (others => '0');
	signal mcycleh: std_logic_vector(31 downto 0) := (others => '0');
	signal minstreth: std_logic_vector(31 downto 0) := (others => '0');
	signal mtime: std_logic_vector(31 downto 0) := (others => '0');
	signal mtimeh: std_logic_vector(31 downto 0) := (others => '0');
	signal mtimecmp: std_logic_vector(31 downto 0) := (others => '0');
	signal mtimecmph: std_logic_vector(31 downto 0) := (others => '0');
	signal s_led: std_logic_vector(7 downto 0) := (others => '0');
begin

	led <= s_led;

	process (clk)
		variable v_output: execute_output_t;
		variable v_sign: std_logic_vector(31 downto 0);
		variable v_jump: std_logic;
		variable v_jump_address: std_logic_vector(31 downto 0);
		variable v_mem_req: mem_req_t;
		variable v_mstatus_mpie, v_mstatus_mie: std_logic;
		variable v_mcycle_inc, v_mcycleh_inc: std_logic_vector(31 downto 0);
		variable v_mcycle, v_mcycleh: std_logic_vector(31 downto 0);
		variable v_minstret_inc, v_minstreth_inc: std_logic_vector(31 downto 0);
		variable v_minstret, v_minstreth: std_logic_vector(31 downto 0);
		variable v_mepc: std_logic_vector(29 downto 0);
		variable v_mcause_int: std_logic;
		variable v_mcause_code: std_logic_vector(3 downto 0);
		variable v_mtime_inc, v_mtimeh_inc: std_logic_vector(31 downto 0);
		variable v_mtime, v_mtimeh: std_logic_vector(31 downto 0);
		variable v_mtimecmp, v_mtimecmph: std_logic_vector(31 downto 0);
		variable v_mtip: std_logic;
		variable v_mtval: std_logic_vector(31 downto 0);
		variable v_mtie: std_logic;
		variable v_mtvec_address: std_logic_vector(29 downto 0);
		variable v_mtvec_mode: std_logic;
		variable v_mscratch: std_logic_vector(31 downto 0);
		variable v_led: std_logic_vector(7 downto 0);

		variable v_address, v_value: std_logic_vector(31 downto 0);
		
		variable csr_set_bits, csr_clear_bits: std_logic_vector(31 downto 0);
		variable v_temp: unsigned(63 downto 0);

		variable has_exception: boolean;

	begin
		if rising_edge(clk) then
			v_output := DEFAULT_EXECUTE_OUTPUT;
			v_output.is_active := input.is_active;
			v_mem_req := DEFAULT_MEM_REQ;
			v_jump := '0';
			v_jump_address := (others => '0');

			v_mstatus_mie := mstatus_mie;
			v_mstatus_mpie := mstatus_mpie;

			v_temp := unsigned(mcycleh & mcycle) + 1;
			v_mcycle_inc := std_logic_vector(v_temp(31 downto 0));
			v_mcycle := v_mcycle_inc;
			v_mcycleh_inc := std_logic_vector(v_temp(63 downto 32));
			v_mcycleh := v_mcycleh_inc;

			v_mepc := mepc;
			v_mcause_int := mcause_int;
			v_mcause_code := mcause_code;

			v_temp := unsigned(mtimeh & mtime) + 1;
			v_mtime_inc := std_logic_vector(v_temp(31 downto 0));
			v_mtime := v_mtime_inc;
			v_mtimeh_inc := std_logic_vector(v_temp(63 downto 32));
			v_mtimeh := v_mtimeh_inc;
			v_mtimecmp := mtimecmp;
			v_mtimecmph := mtimecmph;
			v_mtval := mtval;
			v_mtie := mtie;
			v_mtvec_address := mtvec_address;
			v_mtvec_mode := mtvec_mode;
			v_mscratch := mscratch;

			has_exception := false;

			v_temp := unsigned(minstreth & minstret);
			if instr_retire = '1' then
				v_temp := v_temp + 1;
			end if;

			v_minstret_inc := std_logic_vector(v_temp(31 downto 0));
			v_minstreth_inc := std_logic_vector(v_temp(63 downto 32));
			v_minstret := v_minstret_inc;
			v_minstreth := v_minstret_inc;

			if unsigned(mtimeh & mtime) > unsigned(mtimecmph & mtimecmp) then
				v_mtip := '1';
			else
				v_mtip := '0';
			end if;

			if input.is_active = '1' then
				if input.is_invalid_address = '1' then
					has_exception := true;
					v_mcause_code := EX_CAUSE_INSTRUCTION_ACCESS_FAULT;
				elsif input.is_invalid = '1' then
					has_exception := true;
					v_mcause_code := EX_CAUSE_ILLEGAL_INSTRUCTION;
				else
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
					elsif input.operation = OP_SB then
						v_address := input.operand1;
						v_value := input.operand2;

						v_mem_req.active := '1';
						v_mem_req.address := v_address;

						if v_address(1 downto 0) = "00" then
							v_mem_req.value := x"000000" & v_value(7 downto 0);
							v_mem_req.write_enable := "0001";
						elsif v_address(1 downto 0) = "01" then
							v_mem_req.value := x"0000" & v_value(7 downto 0) & x"00";
							v_mem_req.write_enable := "0010";
						elsif v_address(1 downto 0) = "10" then
							v_mem_req.value := x"00" & v_value(7 downto 0) & x"0000";
							v_mem_req.write_enable := "0100";
						else
							v_mem_req.value := v_value(7 downto 0) & x"000000";
							v_mem_req.write_enable := "1000";
						end if;

						if not (MEM_ADDRESS_MIN <= v_address and v_address <= MEM_ADDRESS_MAX) then
							has_exception := true;
							v_mcause_code := EX_CAUSE_STORE_ACCESS_FAULT;
						end if;
					elsif input.operation = OP_SH then
						v_address := input.operand1;
						v_value := input.operand2;

						v_mem_req.active := '1';
						v_mem_req.address := v_address;

						if input.operand1(1 downto 0) = "00" then
							v_mem_req.value := x"0000" & v_value(15 downto 0);
							v_mem_req.write_enable := "0011";
						else
							v_mem_req.value := v_value(15 downto 0) & x"0000";
							v_mem_req.write_enable := "1100";
						end if;

						if v_address(0) /= '0' then
							has_exception := true;
							v_mcause_code := EX_CAUSE_STORE_ADDRESS_MISALIGNED;
						elsif not (MEM_ADDRESS_MIN <= v_address and v_address <= MEM_ADDRESS_MAX) then
							has_exception := true;
							v_mcause_code := EX_CAUSE_STORE_ACCESS_FAULT;
						end if;
					elsif input.operation = OP_SW then
						v_address := input.operand1;

						if v_address = MTIME_ADDRESS then
							v_mtime := input.operand2;
						elsif v_address = MTIMEH_ADDRESS then
							v_mtimeh := input.operand2;
						elsif v_address = MTIMECMP_ADDRESS then
							v_mtimecmp := input.operand2;
						elsif v_address = MTIMECMPH_ADDRESS then
							v_mtimecmph := input.operand2;
						else
							v_mem_req.active := '1';
							v_mem_req.address := v_address;
							v_mem_req.write_enable := "1111";
							v_mem_req.value := input.operand2;

							if v_address(1 downto 0) /= "00" then
								has_exception := true;
								v_mcause_code := EX_CAUSE_STORE_ADDRESS_MISALIGNED;
							elsif not (MEM_ADDRESS_MIN <= v_address and v_address <= MEM_ADDRESS_MAX) then
								has_exception := true;
								v_mcause_code := EX_CAUSE_STORE_ACCESS_FAULT;
							end if;
						end if;
					elsif input.operation = OP_LB or input.operation = OP_LH or input.operation = OP_LW or input.operation = OP_LBU or input.operation = OP_LHU then
						v_address := input.operand1;

						if input.operation = OP_LW and v_address = MTIME_ADDRESS then
							v_output.result := mtime;
						elsif input.operation = OP_LW and v_address = MTIMEH_ADDRESS then
							v_output.result := mtimeh;
						elsif input.operation = OP_LW and v_address = MTIMECMP_ADDRESS then
							v_output.result := mtimecmp;
						elsif input.operation = OP_LW and v_address = MTIMECMPH_ADDRESS then
							v_output.result := mtimecmph;
						else
							v_output.use_mem := '1';
							v_output.mem_addr := v_address(1 downto 0);
							v_mem_req.active := '1';
							v_mem_req.address := v_address;

							if input.operation = OP_LB or input.operation = OP_LH then
								v_output.mem_sign_extend := '1';
							end if;

							if input.operation = OP_LB or input.operation = OP_LBU then
								v_output.mem_size := SIZE_BYTE;
								if not (MEM_ADDRESS_MIN <= v_address and v_address <= MEM_ADDRESS_MAX) then
									has_exception := true;
									v_mcause_code := EX_CAUSE_LOAD_ACCESS_FAULT;
								end if;
							elsif input.operation = OP_LH or input.operation = OP_LHU then
								v_output.mem_size := SIZE_HALFWORD;
								if v_address(0) /= '0' then
									has_exception := true;
									v_mcause_code := EX_CAUSE_LOAD_ADDRESS_MISALIGNED;
								elsif not (MEM_ADDRESS_MIN <= v_address and v_address <= MEM_ADDRESS_MAX) then
									has_exception := true;
									v_mcause_code := EX_CAUSE_LOAD_ACCESS_FAULT;
								end if;
							else
								v_output.mem_size := SIZE_WORD;
								if v_address(1 downto 0) /= "00" then
									has_exception := true;
									v_mcause_code := EX_CAUSE_LOAD_ADDRESS_MISALIGNED;
								elsif not (MEM_ADDRESS_MIN <= v_address and v_address <= MEM_ADDRESS_MAX) then
									has_exception := true;
									v_mcause_code := EX_CAUSE_LOAD_ACCESS_FAULT;
								end if;
							end if;
						end if;
					elsif input.operation = OP_CSRRW or input.operation = OP_CSRRS or input.operation = OP_CSRRC then
						if input.operation = OP_CSRRW then
							csr_set_bits := input.operand1;
							csr_clear_bits := input.operand1;
						elsif input.operation = OP_CSRRS then
							csr_set_bits := input.operand1;
							csr_clear_bits := (others => '1');
						elsif input.operation = OP_CSRRC then
							csr_clear_bits := not input.operand1;
						else
							assert false report "Unhandled CSR operation in execute stage" severity failure;
						end if;

						-- TODO: implementations for CSR read-write registers

						if input.operand2(11 downto 0) = CSR_MSTATUS then
							v_output.result := "000000000000000000011000" & mstatus_mpie & "000" & mstatus_mie & "000";
							v_mstatus_mie := (mstatus_mie or csr_set_bits(3)) and csr_clear_bits(3);
							v_mstatus_mpie := (mstatus_mpie or csr_set_bits(7)) and csr_clear_bits(7);
						elsif input.operand2(11 downto 0) = CSR_MISA then
							v_output.result := MISA_VALUE;
						elsif input.operand2(11 downto 0) = CSR_MIE then
							v_output.result := "000000000000000000000000" & mtie & "0000000";
							v_mtie := (mtie or csr_set_bits(7)) and csr_clear_bits(7);
						elsif input.operand2(11 downto 0) = CSR_MTVEC then
							v_output.result := mtvec_address & "0" & mtvec_mode;
							v_mtvec_address := (mtvec_address or csr_set_bits(31 downto 2)) and csr_clear_bits(31 downto 2);
							v_mtvec_mode := (mtvec_mode or csr_set_bits(0)) and csr_clear_bits(0);
						elsif input.operand2(11 downto 0) = CSR_MSTATUSH then
							v_output.result := (others => '0');
						elsif input.operand2(11 downto 0) = CSR_MSCRATCH then
							v_output.result := mscratch;
							v_mscratch := (mscratch or csr_set_bits) and csr_clear_bits;
						elsif input.operand2(11 downto 0) = CSR_MEPC then
							v_output.result := mepc & "00";
							v_mepc := (mepc or csr_set_bits(31 downto 2)) and csr_clear_bits(31 downto 2);
						elsif input.operand2(11 downto 0) = CSR_MCAUSE then
							v_output.result := mcause_int & "000000000000000000000000000" & mcause_code;
							v_mcause_int := (mcause_int or csr_set_bits(31)) and csr_clear_bits(31);
							v_mcause_code := (mcause_code or csr_set_bits(5 downto 0)) and csr_clear_bits(5 downto 0);
						elsif input.operand2(11 downto 0) = CSR_MTVAL then
							v_output.result := mtval;
							v_mtval := (mtval or csr_set_bits) and csr_clear_bits;
						elsif input.operand2(11 downto 0) = CSR_MIP then
							v_output.result := "000000000000000000000000" & v_mtip & "0000000";
						elsif input.operand2(11 downto 0) = CSR_MCYCLE then
							v_output.result := mcycle;
							v_mcycle := (mcycle or csr_set_bits) and csr_clear_bits;
						elsif input.operand2(11 downto 0) = CSR_MINSTRET then
							v_output.result := minstret;
							v_minstret := (minstret or csr_set_bits) and csr_clear_bits;
						elsif unsigned(CSR_MHPMCOUNTER3) <= unsigned(input.operand2(11 downto 0)) and unsigned(input.operand2(11 downto 0)) <= unsigned(CSR_MHPMCOUNTER31) then
							v_output.result := (others => '0');
						elsif input.operand2(11 downto 0) = CSR_MCYCLEH then
							v_output.result := mcycleh;
							v_mcycleh := (mcycleh or csr_set_bits) and csr_clear_bits;
						elsif input.operand2(11 downto 0) = CSR_MINSTRETH then
							v_output.result := minstreth;
							v_minstreth := (minstreth or csr_set_bits) and csr_clear_bits;
						elsif unsigned(CSR_MHPMCOUNTER3H) <= unsigned(input.operand2(11 downto 0)) and unsigned(input.operand2(11 downto 0)) <= unsigned(CSR_MHPMCOUNTER31H) then
							v_output.result := (others => '0');
						elsif unsigned(CSR_MHPMEVENT3) <= unsigned(input.operand2(11 downto 0)) and unsigned(input.operand2(11 downto 0)) <= unsigned(CSR_MHPMEVENT31) then
							v_output.result := (others => '0');
						elsif unsigned(CSR_MHPMEVENT3H) <= unsigned(input.operand2(11 downto 0)) and unsigned(input.operand2(11 downto 0)) <= unsigned(CSR_MHPMEVENT31H) then
							v_output.result := (others => '0');
						elsif input.csr_read_only = '1' then
							-- read-only CSRs
							if input.operand2(11 downto 0) = CSR_MVENDORID then
								v_output.result := MVENDORID_VALUE;
							elsif input.operand2(11 downto 0) = CSR_MARCHID then
								v_output.result := MARCHID_VALUE;
							elsif input.operand2(11 downto 0) = CSR_MIMPID then
								v_output.result := MIMPID_VALUE;
							elsif input.operand2(11 downto 0) = CSR_MHARTID then
								v_output.result := MHARTID_VALUE;
							elsif input.operand2(11 downto 0) = CSR_MCONFIGPTR then
								v_output.result := MCONFIGPTR_VALUE;
							else
								-- trying to read non-existent CSR
								has_exception := true;
								v_mcause_code := EX_CAUSE_ILLEGAL_INSTRUCTION;
							end if;
						else
							-- trying to write to non-existent or read-only CSR
							has_exception := true;
							v_mcause_code := EX_CAUSE_ILLEGAL_INSTRUCTION;
						end if;
					elsif input.operation = OP_MRET then
						v_mstatus_mie := mstatus_mpie;
						v_mstatus_mpie := '1';
						v_jump := '1';
						v_jump_address := mepc & "00";
						-- TODO: reset mepc?
					elsif input.operation = OP_ECALL then
						has_exception := true;
						v_mcause_code := EX_CAUSE_ENVIRONMENT_CALL;
					elsif input.operation = OP_EBREAK then
						has_exception := true;
						v_mcause_code := EX_CAUSE_BREAKPOINT;
					elsif input.operation = OP_LED then
						v_led := input.operand1(7 downto 0);
					else
						assert false report "Unhandled operation value in execute stage" severity failure;
					end if;

					v_output.destination_reg := input.destination_reg;
				end if;

				if mstatus_mie = '1' and mtie = '1' and v_mtip = '1' then
					has_exception := true;
					v_mcause_int := '1';
					v_mcause_code := INT_CAUSE_MACHINE_TIMER_INTERRUPT;
				elsif v_jump = '1' and v_jump_address(1) /= '0' then
					has_exception := true;
					v_mcause_code := EX_CAUSE_INSTRUCTION_ADDRESS_MISALIGNED;
				end if;

				if has_exception then
					v_output := DEFAULT_EXECUTE_OUTPUT;
					v_output.is_active := '1';  -- needed to trigger the next instruction
					v_mem_req := DEFAULT_MEM_REQ;
					v_jump := '1';
					v_jump_address := mtvec_address & "00";
					v_mcycle := v_mcycle_inc;
					v_mcycleh := v_mcycleh_inc;
					v_mtime := v_mtime_inc;
					v_mtimeh := v_mtimeh_inc;
					v_mtimecmp := mtimecmp;
					v_mtimecmph := mtimecmph;
					v_minstret := v_minstret_inc;
					v_minstreth := v_minstreth_inc;
					v_mepc := input.pc(31 downto 2);
					v_mtval := (others => '0');
					v_mstatus_mie := '0';
					v_mstatus_mpie := mstatus_mie;
					v_mtie := mtie;
					v_mtvec_address := mtvec_address;
					v_mtvec_mode := mtvec_mode;
					v_mscratch := mscratch;
					v_mcause_int := mcause_int;
					v_mcause_code := mcause_code;
					v_led := s_led;
				end if;
			end if;

			output <= v_output;
			mem_req <= v_mem_req;
			jump <= v_jump;
			jump_address <= v_jump_address(31 downto 1) & "0";
			mcycle <= v_mcycle;
			mcycleh <= v_mcycleh;
			mtime <= v_mtime;
			mtimeh <= v_mtimeh;
			mtimecmp <= v_mtimecmp;
			mtimecmph <= v_mtimecmph;
			minstret <= v_minstret;
			minstreth <= v_minstreth;
			mepc <= v_mepc;
			mcause_int <= v_mcause_int;
			mcause_code <= v_mcause_code;
			mtval <= v_mtval;
			mstatus_mie <= v_mstatus_mie;
			mstatus_mpie <= v_mstatus_mpie;
			mtie <= v_mtie;
			mtvec_address <= v_mtvec_address;
			mtvec_mode <= v_mtvec_mode;
			mscratch <= v_mscratch;
			mcause_int <= v_mcause_int;
			mcause_code <= v_mcause_code;
			s_led <= v_led;
		end if;
	end process;

end rtl;
