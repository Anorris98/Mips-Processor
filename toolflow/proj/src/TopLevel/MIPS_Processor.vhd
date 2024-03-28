-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.
-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

library work;
  use work.MIPS_types.all;

entity MIPS_Processor is
  generic (N : integer := DATA_WIDTH);
  port (iCLK      : in  std_logic;
        iRST      : in  std_logic;
        iInstLd   : in  std_logic;
        iInstAddr : in  std_logic_vector(N - 1 downto 0);
        iInstExt  : in  std_logic_vector(N - 1 downto 0);
        oALUOut   : out std_logic_vector(N - 1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end entity;

architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr   : std_logic;                        -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr : std_logic_vector(N - 1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData : std_logic_vector(N - 1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut  : std_logic_vector(N - 1 downto 0); -- TODO: use this signal as the data memory output

  -- Required register file signals 
  signal s_RegWr     : std_logic;                        -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr : std_logic_vector(4 downto 0);     -- TODO: use this signal as the final destination register address input
  signal s_RegWrData : std_logic_vector(N - 1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N - 1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N - 1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N - 1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt : std_logic; -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl : std_logic; -- TODO: this signal indicates an overflow exception would have been initiated

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
  component mem is
    generic (ADDR_WIDTH : integer;
             DATA_WIDTH : integer);
    port (
      clk  : in  std_logic;
      addr : in  std_logic_vector((ADDR_WIDTH - 1) downto 0);
      data : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
      we   : in  std_logic := '1';
      q    : out std_logic_vector((DATA_WIDTH - 1) downto 0));
  end component;

  component ALU is
    port (i_ALU_A        : in  std_logic_vector(N - 1 downto 0); -- ALU Input A
          i_ALU_B        : in  std_logic_vector(N - 1 downto 0); -- ALU Input B
          i_ALU_Ctl      : in  std_logic_vector(7 downto 0);     -- ALU Control Input [5]SLT bit, used only for SLT. [4]Signed or unsidned, [3]shift L or A, [2]selector, [1]selector, [0]selector
          o_ALU_Carry    : out std_logic;                        -- ALU Indicator for a carry out bit.
          o_ALU_Zero     : out std_logic;                        -- ALU Indicator that an operation has resulting in a 0 output.
          o_ALU_Overflow : out std_logic;                        -- ALU Indicator that an overflow has occured.
          o_branch       : out std_logic;
          o_ALU_I_Result : out std_logic_vector(N - 1 downto 0)); -- ALU add Sub Results.
  end component;

  component Shifter is
    port (i_in        : in  std_logic_vector(N - 1 downto 0);
          i_shift_C   : in  std_logic; --0 = Logical, 1 = Arithmetic
          i_Direction : in  std_logic; --0 = left, 1 = right
          i_Shamt     : in  std_logic_vector(4 downto 0);
          o_Out       : out std_logic_vector(N - 1 downto 0));
  end component;

  component ByteShifter is
    port (
      i_word   : in  std_logic_vector(31 downto 0); -- Instruction bits 31-26
      i_offset : in  std_logic_vector(1 downto 0);  -- two bits is all we need to represent 0 to 3 offsets.
      o_Output : out std_logic_vector(31 downto 0);
      i_signed : in  std_logic
    );
  end component;

  component WordShifter is
    port (
      i_word   : in  std_logic_vector(31 downto 0); -- Instruction bits 31-26
      i_offset : in  std_logic;                     -- two bits is all we need to represent 0 to 3 offsets.
      o_Output : out std_logic_vector(31 downto 0);
      i_signed : in  std_logic
    );
  end component;

  component mux2t1_N is
    port (
      i_s  : in  std_logic;
      i_D0 : in  std_logic_vector(N - 1 downto 0);
      i_D1 : in  std_logic_vector(N - 1 downto 0);
      o_O  : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component mux4t1_N is
    generic (N : integer);
    port (i_w0, i_w1, i_w2, i_w3 : in  std_logic_vector(N - 1 downto 0);
          i_s0, i_s1             : in  std_logic;
          o_Y                    : out std_logic_vector(N - 1 downto 0));
  end component;

  component andg2 is
    port (i_A : in  std_logic;
          i_B : in  std_logic;
          o_F : out std_logic);
  end component;

  component fetchLogic is
    port (
      i_jump_C        : in  std_logic;
      i_jr_ra_C       : in  std_logic;
      i_CLK           : in  std_logic;
      i_RST           : in  std_logic;
      i_branch        : in  std_logic;
      i_instr_25t0    : in  std_logic_vector(25 downto 0);
      i_ext_imm       : in  std_logic_vector(N - 1 downto 0);
      i_jr_ra_pc_next : in  std_logic_vector(N - 1 downto 0);
      o_pc_p4         : out std_logic_vector(N - 1 downto 0);
      o_pc_next       : out std_logic_vector(N - 1 downto 0));
  end component;

  component controller is
    port (i_instruct31_26 : in  std_logic_vector(5 downto 0);
          i_instruct5_0   : in  std_logic_vector(5 downto 0);
          o_halt          : out std_logic;
          o_STD_SHIFT     : out std_logic; -- Standard shift (1)we are doing a normal shift (0) we are doing a variable shift or does not matter.
          o_ALU_Ctl       : out std_logic_vector(7 downto 0);
          o_RegWrite      : out std_logic;
          o_MemtoReg      : out std_logic_vector(1 downto 0);
          o_MemWrite      : out std_logic;
          o_RegDst        : out std_logic_vector(1 downto 0);
          o_Alu_Src       : out std_logic;
          o_ext_ctl       : out std_logic;
          o_Jump          : out std_logic;
          o_jr            : out std_logic;
          o_jal           : out std_logic);
  end component;

  component reg is
    port (
      i_CLK      : in  std_logic;                        -- Clock input
      i_RST      : in  std_logic;                        -- Reset input
      i_WE       : in  std_logic;                        -- Write enable input
      i_rs_addrs : in  std_logic_vector(4 downto 0);     -- addresss for rs
      i_rt_addrs : in  std_logic_vector(4 downto 0);     -- addresss for rt
      i_rd_addrs : in  std_logic_vector(4 downto 0);     -- addresss for rd
      i_rd_data  : in  std_logic_vector(N - 1 downto 0); -- data for rd
      o_rs_data  : out std_logic_vector(N - 1 downto 0); -- data from rs
      o_rt_data  : out std_logic_vector(N - 1 downto 0)  -- data from rt
    );
  end component;

  component extender16t32 is
    port (
      i_Imm16 : in  std_logic_vector(15 downto 0);
      i_ctl   : in  std_logic;
      o_Imm32 : out std_logic_vector(31 downto 0));
  end component;

  -- control signals
  signal s_STD_SHIFT : std_logic;
  signal s_ALU_Ctl   : std_logic_vector(7 downto 0);
  signal s_MemtoReg  : std_logic_vector(1 downto 0);
  signal s_RegDst    : std_logic_vector(1 downto 0);
  signal s_Branch    : std_logic;
  signal s_Alu_Src   : std_logic;
  signal s_ext_ctl   : std_logic;
  signal s_Jump      : std_logic;
  signal s_jr        : std_logic;
  signal s_jal       : std_logic;
  -- wires
  signal w_mux_reg_rtn  : std_logic_vector(N - 1 downto 0);
  signal w_mux1_alu_rtn : std_logic_vector(N - 1 downto 0);
  signal w_mux7_alu_rtn : std_logic_vector(N - 1 downto 0);
  signal w_dmem_lh      : std_logic_vector(N - 1 downto 0);
  signal w_dmem_lb      : std_logic_vector(N - 1 downto 0);
  -- outputs of main resources
  signal s_pc_p4     : std_logic_vector(N - 1 downto 0);
  signal s_rs_data_o : std_logic_vector(N - 1 downto 0);
  signal s_rt_data_o : std_logic_vector(N - 1 downto 0);
  signal s_ext_o     : std_logic_vector(N - 1 downto 0);
  signal s_ALU_Carry : std_logic;
  signal s_ALU_Zero  : std_logic;
  -- Misc
  signal s_mux7_iD1 : std_logic_vector(N - 1 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
                  iInstAddr      when others;

  IMem: mem
    generic map (ADDR_WIDTH => ADDR_WIDTH,
                 DATA_WIDTH => N)
    port map (clk  => iCLK,
              addr => s_IMemAddr(11 downto 2),
              data => iInstExt,
              we   => iInstLd,
              q    => s_Inst);

  DMem: mem
    generic map (ADDR_WIDTH => ADDR_WIDTH,
                 DATA_WIDTH => N)
    port map (clk  => iCLK,
              addr => s_DMemAddr(11 downto 2),
              data => s_DMemData,
              we   => s_DMemWr,
              q    => s_DMemOut);

  fetch: fetchLogic
    port map (
      i_jump_C        => s_Jump,
      i_jr_ra_C       => s_jr,
      i_CLK           => iCLK,
      i_RST           => iRST,
      i_branch        => s_Branch,
      i_instr_25t0    => s_Inst(25 downto 0), -- jump address
      i_ext_imm       => s_ext_o,
      i_jr_ra_pc_next => s_rs_data_o,
      o_pc_p4         => s_pc_p4,
      o_pc_next       => s_NextInstAddr);

  control: controller
    port map (
      i_instruct31_26 => s_Inst(31 downto 26), -- opcode
      i_instruct5_0   => s_Inst(5 downto 0),   -- funct field
      o_halt          => s_Halt,
      o_STD_SHIFT     => s_STD_SHIFT,
      o_ALU_Ctl       => s_ALU_Ctl,
      o_RegWrite      => s_RegWr,
      o_MemtoReg      => s_MemtoReg,
      o_MemWrite      => s_DMemWr,
      o_RegDst        => s_RegDst,
      o_Alu_Src       => s_Alu_Src,
      o_ext_ctl       => s_ext_ctl,
      o_Jump          => s_Jump,
      o_jr            => s_jr,
      o_jal           => s_jal);

  mux0: mux4t1_N
    generic map (N => 5)
    port map (
      i_w0 => s_Inst(20 downto 16),                 -- Non-R type write address (Rt)
      i_w1 => s_Inst(15 downto 11),                 -- R type write address (Rd)
      i_w2 => std_logic_vector(to_unsigned(31, 5)), -- hardcoded address of $ra
      i_w3 => std_logic_vector(to_unsigned(31, 5)), -- hardcoded address of $ra
      i_s0 => s_RegDst(0),
      i_s1 => s_RegDst(1),
      o_Y  => s_RegWrAddr);

  mux6: mux2t1_N
    port map (
      i_S  => s_jal,
      i_D0 => w_mux_reg_rtn,
      i_D1 => s_pc_p4,
      o_O  => s_RegWrData);

  regist: reg
    port map (
      i_CLK      => iCLK,
      i_RST      => iRST,
      i_WE       => s_RegWr,
      i_rs_addrs => s_Inst(25 downto 21), -- Rs address
      i_rt_addrs => s_Inst(20 downto 16), -- Rt address
      i_rd_addrs => s_RegWrAddr,
      i_rd_data  => s_RegWrData,
      o_rs_data  => s_rs_data_o,
      o_rt_data  => s_rt_data_o);

  s_DMemData <= s_rt_data_o;

  ext: extender16t32
    port map (
      i_Imm16 => s_Inst(15 downto 0), -- Immediate value
      i_ctl   => s_ext_ctl,
      o_Imm32 => s_ext_o);

  mux1: mux2t1_N
    port map (
      i_S  => s_Alu_Src,
      i_D0 => s_rt_data_o,
      i_D1 => s_ext_o,
      o_O  => w_mux1_alu_rtn);

  s_mux7_iD1 <= (b"000000" & s_ext_o(31 downto 6));

  mux7: mux2t1_N
    port map (
      i_S  => s_STD_SHIFT,
      i_D0 => s_rs_data_o,
      i_D1 => s_mux7_iD1, -- makes bits 5-0 the shamt field
      o_O  => w_mux7_alu_rtn);

  oALUOut <= s_DMemAddr; --signal for the alu out, is only read by the top level, so need no for extra name.

  ALU0: ALU
    port map (
      i_ALU_A        => w_mux7_alu_rtn,
      i_ALU_B        => w_mux1_alu_rtn,
      i_ALU_Ctl      => s_ALU_Ctl,
      o_ALU_Carry    => s_ALU_Carry,
      o_ALU_Zero     => s_ALU_Zero,
      o_ALU_Overflow => s_Ovfl,
      o_branch       => s_Branch,
      o_ALU_I_Result => s_DMemAddr);

  ByteShifter0: ByteShifter
    port map (
      i_word   => s_DMemOut,
      i_offset => s_DMemAddr(1 downto 0),
      o_Output => w_dmem_lb,
      i_signed => s_ext_ctl
    );

  WordShifter0: WordShifter
    port map (
      i_word   => s_DMemOut,
      i_offset => s_DMemAddr(1),
      o_Output => w_dmem_lh,
      i_signed => s_ext_ctl
    );

  mux4: mux4t1_N -- added for lb, lbu, lh, and lhu.
    generic map (N => 32)
    port map (
      i_w0 => s_DMemAddr, --[00]
      i_w1 => w_dmem_lb,  --[01]
      i_w2 => w_dmem_lh,  --[10]
      i_w3 => s_DMemOut,  --[11] 
      i_s0 => s_MemtoReg(0),
      i_s1 => s_MemtoReg(1),
      o_Y  => w_mux_reg_rtn
    );

end architecture;

