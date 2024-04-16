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
  port (
    iCLK      : in std_logic;
    iRST      : in std_logic;
    iInstLd   : in std_logic;
    iInstAddr : in std_logic_vector(N - 1 downto 0);
    iInstExt  : in std_logic_vector(N - 1 downto 0);
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
    generic (
      ADDR_WIDTH : integer;
      DATA_WIDTH : integer);
    port (
      clk  : in std_logic;
      addr : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
      data : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      we   : in std_logic := '1';
      q    : out std_logic_vector((DATA_WIDTH - 1) downto 0));
  end component;

  component ALU is
    port (
      i_ALU_A        : in std_logic_vector(N - 1 downto 0); -- ALU Input A
      i_ALU_B        : in std_logic_vector(N - 1 downto 0); -- ALU Input B
      i_ALU_Ctl      : in std_logic_vector(7 downto 0);     -- ALU Control Input [5]SLT bit, used only for SLT. [4]Signed or unsidned, [3]shift L or A, [2]selector, [1]selector, [0]selector
      o_ALU_Carry    : out std_logic;                       -- ALU Indicator for a carry out bit.
      o_ALU_Zero     : out std_logic;                       -- ALU Indicator that an operation has resulting in a 0 output.
      o_ALU_Overflow : out std_logic;                       -- ALU Indicator that an overflow has occured.
      o_branch       : out std_logic;
      o_ALU_I_Result : out std_logic_vector(N - 1 downto 0)); -- ALU add Sub Results.
  end component;

  component Shifter is
    port (
      i_in        : in std_logic_vector(N - 1 downto 0);
      i_shift_C   : in std_logic; --0 = Logical, 1 = Arithmetic
      i_Direction : in std_logic; --0 = left, 1 = right
      i_Shamt     : in std_logic_vector(4 downto 0);
      o_Out       : out std_logic_vector(N - 1 downto 0));
  end component;

  component ByteShifter is
    port (
      i_word   : in std_logic_vector(31 downto 0); -- Instruction bits 31-26
      i_offset : in std_logic_vector(1 downto 0);  -- two bits is all we need to represent 0 to 3 offsets.
      o_Output : out std_logic_vector(31 downto 0);
      i_signed : in std_logic
    );
  end component;

  component WordShifter is
    port (
      i_word   : in std_logic_vector(31 downto 0); -- Instruction bits 31-26
      i_offset : in std_logic;                     -- two bits is all we need to represent 0 to 3 offsets.
      o_Output : out std_logic_vector(31 downto 0);
      i_signed : in std_logic
    );
  end component;

  component mux2t1_N is
    port (
      i_s  : in std_logic;
      i_D0 : in std_logic_vector(N - 1 downto 0);
      i_D1 : in std_logic_vector(N - 1 downto 0);
      o_O  : out std_logic_vector(N - 1 downto 0)
    );
  end component;

  component mux4t1_N is
    generic (N : integer);
    port (
      i_w0, i_w1, i_w2, i_w3 : in std_logic_vector(N - 1 downto 0);
      i_s0, i_s1             : in std_logic;
      o_Y                    : out std_logic_vector(N - 1 downto 0));
  end component;

  component andg2 is
    port (
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic);
  end component;

  component org2 is
    port (
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic);
  end component;

  component RippleCarryAdder is
    port (
      A        : in std_logic_vector(N - 1 downto 0);
      B        : in std_logic_vector(N - 1 downto 0);
      Carry    : out std_logic;
      Sum      : out std_logic_vector(N - 1 downto 0);
      Overflow : out std_logic);
  end component;

  component pc_dffg is
    port (
      i_CLK : in std_logic;                          -- Clock input
      i_RST : in std_logic;                          -- Reset input
      i_WE  : in std_logic;                          -- Write enable input
      i_D   : in std_logic_vector(N - 1 downto 0);   -- Data value input
      o_Q   : out std_logic_vector(N - 1 downto 0)); -- Data value output
  end component;

  component controller is
    port (
      i_instruct31_26 : in std_logic_vector(5 downto 0);
      i_instruct5_0   : in std_logic_vector(5 downto 0);
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
      i_CLK      : in std_logic;                         -- Clock input
      i_RST      : in std_logic;                         -- Reset input
      i_WE       : in std_logic;                         -- Write enable input
      i_rs_addrs : in std_logic_vector(4 downto 0);      -- addresss for rs
      i_rt_addrs : in std_logic_vector(4 downto 0);      -- addresss for rt
      i_rd_addrs : in std_logic_vector(4 downto 0);      -- addresss for rd
      i_rd_data  : in std_logic_vector(N - 1 downto 0);  -- data for rd
      o_rs_data  : out std_logic_vector(N - 1 downto 0); -- data from rs
      o_rt_data  : out std_logic_vector(N - 1 downto 0)  -- data from rt
    );
  end component;

  component extender16t32 is
    port (
      i_Imm16 : in std_logic_vector(15 downto 0);
      i_ctl   : in std_logic;
      o_Imm32 : out std_logic_vector(31 downto 0));
  end component;

  component IF_ID_pipe is
    port (
      i_CLK          : in std_logic;                         -- Clock input
      i_RST          : in std_logic;                         -- Reset input
      i_WE           : in std_logic;                         -- Write enable
      i_IF_PC_P4     : in std_logic_vector(N - 1 downto 0);  -- PC + 4
      i_IF_instr31t0 : in std_logic_vector(N - 1 downto 0);  -- Entire instruction
      o_ID_PC_P4     : out std_logic_vector(N - 1 downto 0); -- PC + 4
      o_ID_instr31t0 : out std_logic_vector(N - 1 downto 0)  -- Entire instruction
    );
  end component;

  component ID_EX_pipe is
    port (
      i_CLK            : in std_logic;                        -- Clock input
      i_RST            : in std_logic;                        -- Reset input
      i_WE             : in std_logic;                        -- Write enable
      i_ID_halt        : in std_logic;                        -- Halt control signal
      i_ID_STD_Shift   : in std_logic;                        -- STD Shift control signal
      i_ID_ALU_Src     : in std_logic;                        -- ALU Source control signal
      i_ID_ALU_Control : in std_logic_vector(7 downto 0);     -- ALU Control signals
      i_ID_MemToReg    : in std_logic_vector(1 downto 0);     -- MemToReg control signal
      i_ID_MemWrite    : in std_logic;                        -- Memory write control signal
      i_ID_RegWrite    : in std_logic;                        -- Register write control signal
      i_ID_RegDst      : in std_logic_vector(1 downto 0);     -- Register destination control signal
      i_ID_Jump        : in std_logic;                        -- Jump control signal
      i_ID_ext_ctl     : in std_logic;                        -- Sign extension control signal
      i_ID_jal         : in std_logic;                        -- Jump and link write back control signal
      i_ID_jr          : in std_logic;                        -- Jump return control signal
      i_ID_PCP4        : in std_logic_vector(N - 1 downto 0); -- PC+4 value
      i_ID_instr20t16  : in std_logic_vector(4 downto 0);     -- Register Rt address signal
      i_ID_instr15t11  : in std_logic_vector(4 downto 0);     -- Register Rd address signal
      i_ID_rs_data_o   : in std_logic_vector(N - 1 downto 0); -- Output from Rs address
      i_ID_rt_data_o   : in std_logic_vector(N - 1 downto 0); -- Output from Rt address
      i_ID_ext_o       : in std_logic_vector(N - 1 downto 0); -- Extension control output
      i_ID_s120_o      : in std_logic_vector(27 downto 0);    -- Instruction [25:0] shifted left 2
      ------------------------------------------------------------------------------------
      -- outputs
      ------------------------------------------------------------------------------------
      o_EX_halt        : out std_logic;                        -- Halt control signal
      o_EX_STD_Shift   : out std_logic;                        -- STD Shift control signal
      o_EX_ALU_Src     : out std_logic;                        -- ALU Source control signal
      o_EX_ALU_Control : out std_logic_vector(7 downto 0);     -- ALU Control signals
      o_EX_MemToReg    : out std_logic_vector(1 downto 0);     -- MemToReg control signal
      o_EX_MemWrite    : out std_logic;                        -- Memory write control signal
      o_EX_RegWrite    : out std_logic;                        -- Register write control signal
      o_EX_RegDst      : out std_logic_vector(1 downto 0);     -- Register destination control signal
      o_EX_Jump        : out std_logic;                        -- Jump control signal
      o_EX_ext_ctl     : out std_logic;                        -- Sign extension control signal
      o_EX_jal         : out std_logic;                        -- Jump and link write back control signal
      o_EX_jr          : out std_logic;                        -- Jump return control signal
      o_EX_PCP4        : out std_logic_vector(N - 1 downto 0); -- PC+4 value
      o_EX_instr20t16  : out std_logic_vector(4 downto 0);     -- Register Rt address signal
      o_EX_instr15t11  : out std_logic_vector(4 downto 0);     -- Register Rd address signal
      o_EX_rs_data_o   : out std_logic_vector(N - 1 downto 0); -- Output from Rs address
      o_EX_rt_data_o   : out std_logic_vector(N - 1 downto 0); -- Output from Rt address
      o_EX_ext_o       : out std_logic_vector(N - 1 downto 0); -- Extension control output
      o_EX_s120_o      : out std_logic_vector(27 downto 0)     -- Instruction [25:0] shifted left 2
    );
  end component;

  component EX_MEM_pipe is
    port (
      i_CLK           : in std_logic;                        -- Clock input
      i_RST           : in std_logic;                        -- Reset input
      i_WE            : in std_logic;                        -- Write enable
      i_EX_halt       : in std_logic;                        -- Halt control signal
      i_EX_MemToReg   : in std_logic_vector(1 downto 0);     -- MemToReg control signal
      i_EX_MemWrite   : in std_logic;                        -- Memory write control signal
      i_EX_RegWrite   : in std_logic;                        -- Register write control signal
      i_EX_Jump       : in std_logic;                        -- Jump control signal
      i_EX_ext_ctl    : in std_logic;                        -- Sign extension control signal
      i_EX_jal        : in std_logic;                        -- Jump and link write back control signal
      i_EX_jr         : in std_logic;                        -- Jump return control signal
      i_EX_branch     : in std_logic;                        -- Branch output from ALU
      i_EX_PCP4       : in std_logic_vector(N - 1 downto 0); -- PC+4 value
      i_EX_rs_data_o  : in std_logic_vector(N - 1 downto 0); -- Output from Rs address
      i_EX_rt_data_o  : in std_logic_vector(N - 1 downto 0); -- Output from Rt address
      i_EX_pc4_s120_o : in std_logic_vector(N - 1 downto 0); -- Jump address
      i_EX_RegWrAddr  : in std_logic_vector(4 downto 0);     -- Write address
      i_EX_Dmem_Addr  : in std_logic_vector(N - 1 downto 0); -- Output from the ALU
      i_EX_add1_mux2  : in std_logic_vector(N - 1 downto 0); -- Output from Adder 1
      ------------------------------------------------------------------------------------
      -- outputs
      ------------------------------------------------------------------------------------
      o_MEM_halt       : out std_logic;                        -- Halt control signal
      o_MEM_MemToReg   : out std_logic_vector(1 downto 0);     -- MemToReg control signal
      o_MEM_MemWrite   : out std_logic;                        -- Memory write control signal
      o_MEM_RegWrite   : out std_logic;                        -- Register write control signal
      o_MEM_Jump       : out std_logic;                        -- Jump control signal
      o_MEM_ext_ctl    : out std_logic;                        -- Sign extension control signal
      o_MEM_jal        : out std_logic;                        -- Jump and link write back control signal
      o_MEM_jr         : out std_logic;                        -- Jump return control signal
      o_MEM_branch     : out std_logic;                        -- Branch output from ALU
      o_MEM_PCP4       : out std_logic_vector(N - 1 downto 0); -- PC+4 value
      o_MEM_rs_data_o  : out std_logic_vector(N - 1 downto 0); -- Output from Rs address
      o_MEM_rt_data_o  : out std_logic_vector(N - 1 downto 0); -- Output from Rt address
      o_MEM_pc4_s120_o : out std_logic_vector(N - 1 downto 0); -- Jump address
      o_MEM_RegWrAddr  : out std_logic_vector(4 downto 0);     -- Write address
      o_MEM_Dmem_Addr  : out std_logic_vector(N - 1 downto 0); -- Output from the ALU
      o_MEM_add1_mux2  : out std_logic_vector(N - 1 downto 0)  -- Output from Adder 1
    );
  end component;

  component MEM_WB_pipe is
    port (
      i_CLK           : in std_logic;                        -- Clock input
      i_RST           : in std_logic;                        -- Reset input
      i_WE            : in std_logic;                        -- Write enable
      i_MEM_halt      : in std_logic;                        -- Halt control signal
      i_MEM_MemToReg  : in std_logic_vector(1 downto 0);     -- MemToReg control signal
      i_MEM_RegWrite  : in std_logic;                        -- Register write control signal
      i_MEM_jal       : in std_logic;                        -- Jump and link write back control signal
      i_MEM_PCP4      : in std_logic_vector(N - 1 downto 0); -- PC+4 value
      i_MEM_RegWrAddr : in std_logic_vector(4 downto 0);     -- Write address
      i_MEM_Dmem_Addr : in std_logic_vector(N - 1 downto 0); -- Output from the ALU
      i_MEM_Dmem_out  : in std_logic_vector(N - 1 downto 0); -- Output from DMEM
      i_MEM_Dmem_Lb   : in std_logic_vector(N - 1 downto 0); -- Output from byte decoder
      i_MEM_Dmem_Lh   : in std_logic_vector(N - 1 downto 0); -- Output from word decoder
      ------------------------------------------------------------------------------------
      -- outputs
      ------------------------------------------------------------------------------------
      o_WB_halt      : out std_logic;                        -- Halt control signal
      o_WB_MemToReg  : out std_logic_vector(1 downto 0);     -- MemToReg control signal
      o_WB_RegWrite  : out std_logic;                        -- Register write control signal
      o_WB_jal       : out std_logic;                        -- Jump and link write back control signal
      o_WB_PCP4      : out std_logic_vector(N - 1 downto 0); -- PC+4 value
      o_WB_RegWrAddr : out std_logic_vector(4 downto 0);     -- Write address
      o_WB_Dmem_Addr : out std_logic_vector(N - 1 downto 0); -- Output from the ALU
      o_WB_Dmem_out  : out std_logic_vector(N - 1 downto 0); -- Output from DMEM
      o_WB_Dmem_Lb   : out std_logic_vector(N - 1 downto 0); -- Output from byte decoder
      o_WB_Dmem_Lh   : out std_logic_vector(N - 1 downto 0)  -- Output from word decoder
    );
  end component;

  -- IF signals and wires
  signal s_IF_pc_p4      : std_logic_vector(N - 1 downto 0);
  signal w_IF_pc_next    : std_logic_vector(N - 1 downto 0);
  signal s_add0_carry    : std_logic;
  signal s_add0_overflow : std_logic; -- 1 if overflow
  -- ID signals and wires
  signal s_ID_pc_p4     : std_logic_vector(N - 1 downto 0);
  signal s_ID_Inst      : std_logic_vector(N - 1 downto 0);
  signal s_ID_Halt      : std_logic;
  signal s_ID_DMemWr    : std_logic;
  signal s_ID_STD_SHIFT : std_logic;
  signal s_ID_ALU_Ctl   : std_logic_vector(7 downto 0);
  signal s_ID_RegWr     : std_logic;
  signal s_ID_MemtoReg  : std_logic_vector(1 downto 0);
  signal s_ID_RegDst    : std_logic_vector(1 downto 0);
  signal s_ID_Branch    : std_logic;
  signal s_ID_Alu_Src   : std_logic;
  signal s_ID_ext_ctl   : std_logic;
  signal s_ID_Jump      : std_logic;
  signal s_ID_jr        : std_logic;
  signal s_ID_jal       : std_logic;
  signal w_ID_ext_o     : std_logic_vector(N - 1 downto 0);
  signal w_ID_s120_o    : std_logic_vector(27 downto 0);
  signal s_ID_rs_data_o : std_logic_vector(N - 1 downto 0);
  signal s_ID_rt_data_o : std_logic_vector(N - 1 downto 0);
  -- EX signals and wires
  signal s_EX_halt         : std_logic;                        -- Halt control signal
  signal s_EX_STD_Shift    : std_logic;                        -- STD Shift control signal
  signal s_EX_ALU_Src      : std_logic;                        -- ALU Source control signal
  signal s_EX_ALU_Control  : std_logic_vector(7 downto 0);     -- ALU Control signals
  signal s_EX_MemToReg     : std_logic_vector(1 downto 0);     -- MemToReg control signal
  signal s_EX_MemWrite     : std_logic;                        -- Memory write control signal
  signal s_EX_RegWr        : std_logic;                        -- Register write control signal
  signal s_EX_RegDst       : std_logic_vector(1 downto 0);     -- Register destination control signal
  signal s_EX_Jump         : std_logic;                        -- Jump control signal
  signal s_EX_ext_ctl      : std_logic;                        -- Sign extension control signal
  signal s_EX_jal          : std_logic;                        -- Jump and link write back control signal
  signal s_EX_jr           : std_logic;                        -- Jump return control signal
  signal s_EX_PCP4         : std_logic_vector(N - 1 downto 0); -- PC+4 value
  signal s_EX_instr20t16   : std_logic_vector(4 downto 0);     -- Register Rt address signal
  signal s_EX_instr15t11   : std_logic_vector(4 downto 0);     -- Register Rd address signal
  signal s_EX_rs_data_o    : std_logic_vector(N - 1 downto 0); -- Output from Rs address
  signal s_EX_rt_data_o    : std_logic_vector(N - 1 downto 0); -- Output from Rt address
  signal s_EX_ext_o        : std_logic_vector(N - 1 downto 0); -- Extension control output
  signal s_EX_s120_o       : std_logic_vector(27 downto 0);    -- Instruction [25:0] shifted left 2
  signal s_EX_pc4_s120_o   : std_logic_vector(N - 1 downto 0); -- Full jump address
  signal w_EX_mux1_alu_rtn : std_logic_vector(N - 1 downto 0);
  signal w_EX_mux7_iD1     : std_logic_vector(N - 1 downto 0);
  signal w_EX_mux7_alu_rtn : std_logic_vector(N - 1 downto 0);
  signal s_EX_ALU_Carry    : std_logic;
  signal s_EX_ALU_Zero     : std_logic;
  signal s_EX_branch       : std_logic;
  signal w_EX_shift_add1   : std_logic_vector(N - 1 downto 0);
  signal s_EX_add1_mux2    : std_logic_vector(N - 1 downto 0);
  signal s_add1_carry      : std_logic;
  signal s_add1_overflow   : std_logic; -- 1 if overflow
  -- MEM signals and wires
  signal s_MEM_MemWrite   : std_logic; -- Memory write control signal
  signal s_MEM_RegWr      : std_logic;
  signal s_MEM_diff_addr  : std_logic;
  signal s_MEM_PC_next    : std_logic_vector(N - 1 downto 0);
  signal s_MEM_branch     : std_logic;
  signal s_MEM_jr         : std_logic; -- Jump return control signal
  signal s_MEM_Jump       : std_logic; -- Jump control signal
  signal s_MEM_ext_ctl    : std_logic; -- Sign extension control signal
  signal w_MEM_or1_or2    : std_logic;
  signal w_MEM_mux2_mux3  : std_logic_vector(N - 1 downto 0);
  signal w_MEM_mux3_mux5  : std_logic_vector(N - 1 downto 0);
  signal s_MEM_halt       : std_logic;                        -- Halt control signal
  signal s_MEM_MemToReg   : std_logic_vector(1 downto 0);     -- MemToReg control signal
  signal s_MEM_jal        : std_logic;                        -- Jump and link write back control signal
  signal s_MEM_PCP4       : std_logic_vector(N - 1 downto 0); -- PC+4 value
  signal s_MEM_RegWrAddr  : std_logic_vector(4 downto 0);     -- Write address
  signal s_MEM_Dmem_Addr  : std_logic_vector(N - 1 downto 0); -- Output from the ALU
  signal s_MEM_Dmem_Lb    : std_logic_vector(N - 1 downto 0); -- Output from byte decoder
  signal s_MEM_Dmem_Lh    : std_logic_vector(N - 1 downto 0); -- Output from word decoder
  signal s_MEM_rs_data_o  : std_logic_vector(N - 1 downto 0); -- Output from Rs address
  signal s_MEM_rt_data_o  : std_logic_vector(N - 1 downto 0); -- Output from Rt address
  signal s_MEM_pc4_s120_o : std_logic_vector(N - 1 downto 0); -- Jump address
  signal s_MEM_add1_mux2  : std_logic_vector(N - 1 downto 0);
  signal s_EX_RegWrAddr   : std_logic_vector(4 downto 0); -- Final register write address
  signal s_EX_Dmem_Addr   : std_logic_vector(N - 1 downto 0);

  -- WB signals and wires
  signal s_WB_halt        : std_logic;                        -- Halt control signal
  signal s_WB_MemToReg    : std_logic_vector(1 downto 0);     -- MemToReg control signal
  signal s_WB_RegWr       : std_logic;                        -- Register write control signal
  signal s_WB_jal         : std_logic;                        -- Jump and link write back control signal
  signal s_WB_PCP4        : std_logic_vector(N - 1 downto 0); -- PC+4 value
  signal s_WB_RegWrAddr   : std_logic_vector(4 downto 0);     -- Write address
  signal s_WB_Dmem_Addr   : std_logic_vector(N - 1 downto 0); -- Output from the ALU
  signal s_WB_Dmem_out    : std_logic_vector(N - 1 downto 0); -- Output from DMEM
  signal s_WB_Dmem_Lb     : std_logic_vector(N - 1 downto 0); -- Output from byte decoder
  signal s_WB_Dmem_Lh     : std_logic_vector(N - 1 downto 0); -- Output from word decoder
  signal w_WB_mux_reg_rtn : std_logic_vector(N - 1 downto 0);

begin

  ----------------------------------------------------------------------------------------------------------
  -- Fetch stage
  ----------------------------------------------------------------------------------------------------------
  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
    iInstAddr when others;

  IMem : mem
  generic map(
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => N)
  port map(
    clk  => iCLK,
    addr => s_IMemAddr(11 downto 2),
    data => iInstExt,
    we   => iInstLd,
    q    => s_Inst);

  mux8 : mux2t1_N
  port map(
    i_s  => s_MEM_diff_addr,
    i_D0 => s_IF_pc_p4,
    i_D1 => s_MEM_PC_next,
    o_O  => w_IF_pc_next);

  add0 : RippleCarryAdder
  port map(
    A        => s_NextInstAddr,
    B        => x"00000004",
    Sum      => s_IF_pc_p4,
    Carry    => s_add0_carry,
    Overflow => s_add0_overflow);

  pc_dff : pc_dffg
  port map(
    i_CLK => iCLK,            -- Clock input
    i_RST => iRST,            -- Reset input
    i_WE  => '1',             -- Write enable input
    i_D   => w_IF_pc_next,    -- Data value input
    o_Q   => s_NextInstAddr); -- Data value output

  ----------------------------------------------------------------------------------------------------------
  -- PIPE
  ----------------------------------------------------------------------------------------------------------

  IFID_pipe : IF_ID_pipe
  port map(
    i_CLK          => iCLK,       -- Clock input
    i_RST          => iRST,       -- Reset input
    i_WE           => '1',        -- Write enable
    i_IF_PC_P4     => s_IF_pc_p4, -- PC + 4
    i_IF_instr31t0 => s_Inst,     -- Entire instruction
    o_ID_PC_P4     => s_ID_pc_p4, -- PC + 4
    o_ID_instr31t0 => s_ID_Inst); -- Entire instruction

  ----------------------------------------------------------------------------------------------------------
  -- Decode stage
  ----------------------------------------------------------------------------------------------------------

  w_ID_s120_o <= s_ID_Inst(25 downto 0) & b"00"; -- shift_left2_0

  control : controller
  port map(
    i_instruct31_26 => s_ID_Inst(31 downto 26), -- opcode
    i_instruct5_0   => s_ID_Inst(5 downto 0),   -- funct field
    o_halt          => s_ID_Halt,
    o_STD_SHIFT     => s_ID_STD_SHIFT,
    o_ALU_Ctl       => s_ID_ALU_Ctl,
    o_RegWrite      => s_ID_RegWr,
    o_MemtoReg      => s_ID_MemtoReg,
    o_MemWrite      => s_ID_DMemWr,
    o_RegDst        => s_ID_RegDst,
    o_Alu_Src       => s_ID_Alu_Src,
    o_ext_ctl       => s_ID_ext_ctl,
    o_Jump          => s_ID_Jump,
    o_jr            => s_ID_jr,
    o_jal           => s_ID_jal);

    s_RegWr <= s_WB_RegWr;
    s_RegWrAddr <= s_WB_RegWrAddr;
    s_RegWrData <= w_WB_mux_reg_rtn;

  regist : reg
  port map(
    i_CLK      => iCLK,
    i_RST      => iRST,
    i_WE       => s_RegWr,
    i_rs_addrs => s_ID_Inst(25 downto 21), -- Rs address
    i_rt_addrs => s_ID_Inst(20 downto 16), -- Rt address
    i_rd_addrs => s_RegWrAddr,
    i_rd_data  => s_RegWrData,
    o_rs_data  => s_ID_rs_data_o,
    o_rt_data  => s_ID_rt_data_o);

  ext : extender16t32
  port map(
    i_Imm16 => s_ID_Inst(15 downto 0), -- Immediate value
    i_ctl   => s_ID_ext_ctl,
    o_Imm32 => w_ID_ext_o);

  ----------------------------------------------------------------------------------------------------------
  -- PIPE
  ----------------------------------------------------------------------------------------------------------

  IDEX_pipe : ID_EX_pipe
  port map(
    i_CLK            => iCLK,                    -- Clock input
    i_RST            => iRST,                    -- Reset input
    i_WE             => '1',                     -- Write enable
    i_ID_halt        => s_ID_Halt,               -- Halt control signal
    i_ID_STD_Shift   => s_ID_STD_SHIFT,          -- STD Shift control signal
    i_ID_ALU_Src     => s_ID_Alu_Src,            -- ALU Source control signal
    i_ID_ALU_Control => s_ID_ALU_Ctl,            -- ALU Control signals
    i_ID_MemToReg    => s_ID_MemtoReg,           -- MemToReg control signal
    i_ID_MemWrite    => s_ID_DMemWr,             -- Memory write control signal
    i_ID_RegWrite    => s_ID_RegWr,              -- Register write control signal
    i_ID_RegDst      => s_ID_RegDst,             -- Register destination control signal
    i_ID_Jump        => s_ID_Jump,               -- Jump control signal
    i_ID_ext_ctl     => s_ID_ext_ctl,            -- Sign extension control signal
    i_ID_jal         => s_ID_jal,                -- Jump and link write back control signal
    i_ID_jr          => s_ID_jr,                 -- Jump return control signal
    i_ID_PCP4        => s_ID_pc_p4,              -- PC+4 value
    i_ID_instr20t16  => s_ID_Inst(20 downto 16), -- Register Rt address signal
    i_ID_instr15t11  => s_ID_inst(15 downto 11), -- Register Rd address signal
    i_ID_rs_data_o   => s_ID_rs_data_o,          -- Output from Rs address
    i_ID_rt_data_o   => s_ID_rt_data_o,          -- Output from Rt address
    i_ID_ext_o       => w_ID_ext_o,              -- Extension control output
    i_ID_s120_o      => w_ID_s120_o,             -- Instruction [25:0] shifted left 2
    ------------------------------------------------------------------------------------
    -- outputs
    ------------------------------------------------------------------------------------
    o_EX_halt        => s_EX_halt,        -- Halt control signal
    o_EX_STD_Shift   => s_EX_STD_Shift,   -- STD Shift control signal
    o_EX_ALU_Src     => s_EX_ALU_Src,     -- ALU Source control signal
    o_EX_ALU_Control => s_EX_ALU_Control, -- ALU Control signals
    o_EX_MemToReg    => s_EX_MemToReg,    -- MemToReg control signal
    o_EX_MemWrite    => s_EX_MemWrite,    -- Memory write control signal
    o_EX_RegWrite    => s_EX_RegWr,       -- Register write control signal
    o_EX_RegDst      => s_EX_RegDst,      -- Register destination control signal
    o_EX_Jump        => s_EX_Jump,        -- Jump control signal
    o_EX_ext_ctl     => s_EX_ext_ctl,     -- Sign extension control signal
    o_EX_jal         => s_EX_jal,         -- Jump and link write back control signal
    o_EX_jr          => s_EX_jr,          -- Jump return control signal
    o_EX_PCP4        => s_EX_PCP4,        -- PC+4 value
    o_EX_instr20t16  => s_EX_instr20t16,  -- Register Rt address signal
    o_EX_instr15t11  => s_EX_instr15t11,  -- Register Rd address signal
    o_EX_rs_data_o   => s_EX_rs_data_o,   -- Output from Rs address
    o_EX_rt_data_o   => s_EX_rt_data_o,   -- Output from Rt address
    o_EX_ext_o       => s_EX_ext_o,       -- Extension control output
    o_EX_s120_o      => s_EX_s120_o);     -- Instruction [25:0] shifted left 2

  ----------------------------------------------------------------------------------------------------------
  -- Execution stage
  ----------------------------------------------------------------------------------------------------------

  s_EX_pc4_s120_o <= s_EX_PCP4(31 downto 28) & s_EX_s120_o;

  w_EX_shift_add1 <= s_EX_ext_o(29 downto 0) & b"00";

  add1 : RippleCarryAdder
  port map(
    A        => s_EX_PCP4,
    B        => w_EX_shift_add1,
    Sum      => s_EX_add1_mux2,
    Carry    => s_add1_carry,
    Overflow => s_add1_overflow);

  mux0 : mux4t1_N
  generic map(N => 5)
  port map(
    i_w0 => s_EX_instr20t16,                      -- Non-R type write address (Rt)
    i_w1 => s_EX_instr15t11,                      -- R type write address (Rd)
    i_w2 => std_logic_vector(to_unsigned(31, 5)), -- hardcoded address of $ra
    i_w3 => std_logic_vector(to_unsigned(31, 5)), -- hardcoded address of $ra
    i_s0 => s_EX_RegDst(0),
    i_s1 => s_EX_RegDst(1),
    o_Y  => s_EX_RegWrAddr);

  mux1 : mux2t1_N
  port map(
    i_S  => s_EX_ALU_Src,
    i_D0 => s_EX_rt_data_o,
    i_D1 => s_EX_ext_o,
    o_O  => w_EX_mux1_alu_rtn);

  w_EX_mux7_iD1 <= (b"000000" & s_EX_ext_o(31 downto 6));
  mux7 : mux2t1_N
  port map(
    i_S  => s_EX_STD_Shift,
    i_D0 => s_EX_rs_data_o,
    i_D1 => w_EX_mux7_iD1, -- makes bits 5-0 the shamt field
    o_O  => w_EX_mux7_alu_rtn);

  oALUOut <= s_EX_Dmem_Addr; --signal for the alu out, is only read by the top level, so need no for extra name.

  ALU0 : ALU
  port map(
    i_ALU_A        => w_EX_mux7_alu_rtn,
    i_ALU_B        => w_EX_mux1_alu_rtn,
    i_ALU_Ctl      => s_EX_ALU_Control,
    o_ALU_Carry    => s_EX_ALU_Carry,
    o_ALU_Zero     => s_EX_ALU_Zero,
    o_ALU_Overflow => s_Ovfl,
    o_branch       => s_EX_branch,
    o_ALU_I_Result => s_EX_Dmem_Addr);

  ----------------------------------------------------------------------------------------------------------
  -- PIPE
  ----------------------------------------------------------------------------------------------------------
  EXMEM_pipe : EX_MEM_pipe
  port map(
    i_CLK           => iCLK,            -- Clock input
    i_RST           => iRST,            -- Reset input
    i_WE            => '1',             -- Write enable
    i_EX_halt       => s_EX_halt,       -- Halt control signal
    i_EX_MemToReg   => s_EX_MemToReg,   -- MemToReg control signal
    i_EX_MemWrite   => s_EX_MemWrite,   -- Memory write control signal
    i_EX_RegWrite   => s_EX_RegWr,      -- Register write control signal
    i_EX_Jump       => s_EX_Jump,       -- Jump control signal
    i_EX_ext_ctl    => s_EX_ext_ctl,    -- Sign extension control signal
    i_EX_jal        => s_EX_jal,        -- Jump and link write back control signal
    i_EX_jr         => s_EX_jr,         -- Jump return control signal
    i_EX_branch     => s_EX_branch,     -- Branch output from ALU
    i_EX_PCP4       => s_EX_PCP4,       -- PC+4 value
    i_EX_rs_data_o  => s_EX_rs_data_o,  -- Output from Rs address
    i_EX_rt_data_o  => s_EX_rt_data_o,  -- Output from Rt address
    i_EX_pc4_s120_o => s_EX_pc4_s120_o, -- Jump address
    i_EX_RegWrAddr  => s_EX_RegWrAddr,  -- Write address
    i_EX_Dmem_Addr  => s_EX_Dmem_Addr,  -- Output from the ALU
    i_EX_add1_mux2  => s_EX_add1_mux2,  -- Output from Adder 1
    ------------------------------------------------------------------------------------
    -- outputs
    ------------------------------------------------------------------------------------
    o_MEM_halt       => s_MEM_halt,       -- Halt control signal
    o_MEM_MemToReg   => s_MEM_MemToReg,   -- MemToReg control signal
    o_MEM_MemWrite   => s_MEM_MemWrite,   -- Memory write control signal
    o_MEM_RegWrite   => s_MEM_RegWr,      -- Register write control signal
    o_MEM_Jump       => s_MEM_Jump,       -- Jump control signal
    o_MEM_ext_ctl    => s_MEM_ext_ctl,    -- Sign extension control signal
    o_MEM_jal        => s_MEM_jal,        -- Jump and link write back control signal
    o_MEM_jr         => s_MEM_jr,         -- Jump return control signal
    o_MEM_branch     => s_MEM_branch,     -- Branch output from ALU
    o_MEM_PCP4       => s_MEM_PCP4,       -- PC+4 value
    o_MEM_rs_data_o  => s_MEM_rs_data_o,  -- Output from Rs address
    o_MEM_rt_data_o  => s_MEM_rt_data_o,  -- Output from Rt address
    o_MEM_pc4_s120_o => s_MEM_pc4_s120_o, -- Jump address
    o_MEM_RegWrAddr  => s_MEM_RegWrAddr,  -- Write address
    o_MEM_Dmem_Addr  => s_MEM_Dmem_Addr,  -- Output from the ALU
    o_MEM_add1_mux2  => s_MEM_add1_mux2); -- Output from Adder 1
  ----------------------------------------------------------------------------------------------------------
  -- Memory stage
  ----------------------------------------------------------------------------------------------------------

  mux2 : mux2t1_N
  port map(
    i_s  => s_MEM_branch,
    i_D0 => s_MEM_PCP4,
    i_D1 => s_MEM_add1_mux2,
    o_O  => w_MEM_mux2_mux3);

  mux3 : mux2t1_N
  port map(
    i_S  => s_MEM_Jump,
    i_D0 => w_MEM_mux2_mux3,
    i_D1 => s_MEM_pc4_s120_o,
    o_O  => w_MEM_mux3_mux5);

  mux5 : mux2t1_N
  port map(
    i_S  => s_MEM_jr,
    i_D0 => w_MEM_mux3_mux5,
    i_D1 => s_MEM_rs_data_o,
    o_O  => s_MEM_PC_next);

  or1 : org2
  port map(
    i_A => s_MEM_Jump,
    i_B => s_MEM_jr,
    o_F => w_MEM_or1_or2);

  or2 : org2
  port map(
    i_A => s_MEM_branch,
    i_B => w_MEM_or1_or2,
    o_F => s_MEM_diff_addr);

  s_DMemData <= s_MEM_rt_data_o;
  s_DMemAddr <= s_MEM_Dmem_Addr;
  s_DMemWr   <= s_MEM_MemWrite;

  DMem : mem
  generic map(
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => N)
  port map(
    clk  => iCLK,
    addr => s_DMemAddr(11 downto 2),
    data => s_DMemData,
    we   => s_DMemWr,
    q    => s_DMemOut);

  ByteShifter0 : ByteShifter
  port map(
    i_word   => s_DMemOut,
    i_offset => s_DMemAddr(1 downto 0),
    o_Output => s_MEM_Dmem_Lb,
    i_signed => s_MEM_ext_ctl
  );

  WordShifter0 : WordShifter
  port map(
    i_word   => s_DMemOut,
    i_offset => s_DMemAddr(1),
    o_Output => s_MEM_Dmem_Lh,
    i_signed => s_MEM_ext_ctl
  );

  ----------------------------------------------------------------------------------------------------------
  -- PIPE
  ----------------------------------------------------------------------------------------------------------
 s_Halt <= s_WB_halt;

  MEMWB_pipe : MEM_WB_pipe
  port map(
    i_CLK           => iCLK,
    i_RST           => iRST,
    i_WE            => '1',
    i_MEM_halt      => s_MEM_halt,      -- Halt control signal
    i_MEM_MemToReg  => s_MEM_MemToReg,  -- MemToReg control signal
    i_MEM_RegWrite  => s_MEM_RegWr,     -- Register write control signal
    i_MEM_jal       => s_MEM_jal,       -- Jump and link write back control signal
    i_MEM_PCP4      => s_MEM_PCP4,      -- PC+4 value
    i_MEM_RegWrAddr => s_MEM_RegWrAddr, -- Write address
    i_MEM_Dmem_Addr => s_MEM_Dmem_Addr, -- Output from the ALU
    i_MEM_Dmem_out  => s_DMemOut,       -- Output from DMEM
    i_MEM_Dmem_Lb   => s_MEM_Dmem_Lb,   -- Output from byte decoder
    i_MEM_Dmem_Lh   => s_MEM_Dmem_Lh,
    ------------------------------------------------------------------------------------
    -- outputs
    ------------------------------------------------------------------------------------
    o_WB_halt      => s_WB_halt,      -- Halt control signal
    o_WB_MemToReg  => s_WB_MemToReg,  -- MemToReg control signal
    o_WB_RegWrite  => s_WB_RegWr,     -- Register write control signal
    o_WB_jal       => s_WB_jal,       -- Jump and link write back control signal
    o_WB_PCP4      => s_WB_PCP4,      -- PC+4 value
    o_WB_RegWrAddr => s_WB_RegWrAddr, -- Write address
    o_WB_Dmem_Addr => s_WB_Dmem_Addr, -- Output from the ALU
    o_WB_Dmem_out  => s_WB_Dmem_out,  -- Output from DMEM
    o_WB_Dmem_Lb   => s_WB_Dmem_Lb,   -- Output from byte decoder
    o_WB_Dmem_Lh   => s_WB_Dmem_Lh);  -- Output from word decoder
  ----------------------------------------------------------------------------------------------------------
  -- Write Back stage
  ----------------------------------------------------------------------------------------------------------

  mux4 : mux4t1_N -- added for lb, lbu, lh, and lhu.
  generic map(N => 32)
  port map(
    i_w0 => s_WB_Dmem_Addr, --[00]
    i_w1 => s_WB_Dmem_Lb,   --[01]
    i_w2 => s_WB_Dmem_Lh,   --[10]
    i_w3 => s_WB_Dmem_out,  --[11] 
    i_s0 => s_WB_MemToReg(0),
    i_s1 => s_WB_MemToReg(1),
    o_Y  => w_WB_mux_reg_rtn);

  mux6 : mux2t1_N
  port map(
    i_S  => s_WB_jal,
    i_D0 => w_WB_mux_reg_rtn,
    i_D1 => s_WB_PCP4,
    o_O  => s_RegWrData);

end architecture;