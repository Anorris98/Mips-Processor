-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MEM_WB_pipe.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;

entity MEM_WB_pipe is
  generic (N : integer := 32);
  port (
    i_CLK            : in  std_logic;                        -- Clock input
    i_RST            : in  std_logic;                        -- Reset input
    i_WE             : in  std_logic;                        -- Write enable (1 when writing, 0 when stalling)
    i_MEM_halt       : in  std_logic;                        -- Halt control signal
    i_MEM_MemToReg   : in  std_logic_vector(1 downto 0);     -- MemToReg control signal
    i_MEM_RegWrite   : in  std_logic;                        -- Register write control signal
    i_MEM_jal        : in  std_logic;                        -- Jump and link write back control signal
    i_MEM_PCP4       : in  std_logic_vector(N - 1 downto 0); -- PC+4 value
    i_MEM_instr31t26 : in  std_logic_vector(5 downto 0);     -- Itype OpCode signal
    i_MEM_RegWrAddr  : in  std_logic_vector(4 downto 0);     -- Write address
    i_MEM_Dmem_Addr  : in  std_logic_vector(N - 1 downto 0); -- Output from the ALU
    i_MEM_Dmem_out   : in  std_logic_vector(N - 1 downto 0); -- Output from DMEM
    i_MEM_Dmem_Lb    : in  std_logic_vector(N - 1 downto 0); -- Output from byte decoder
    i_MEM_Dmem_Lh    : in  std_logic_vector(N - 1 downto 0); -- Output from word decoder
    i_MEM_Ovfl       : in  std_logic;                        -- Overflow signal
    ------------------------------------------------------------------------------------
    -- outputs
    ------------------------------------------------------------------------------------
    o_WB_halt        : out std_logic;                        -- Halt control signal
    o_WB_MemToReg    : out std_logic_vector(1 downto 0);     -- MemToReg control signal
    o_WB_RegWrite    : out std_logic;                        -- Register write control signal
    o_WB_jal         : out std_logic;                        -- Jump and link write back control signal
    o_WB_PCP4        : out std_logic_vector(N - 1 downto 0); -- PC+4 value
    o_WB_instr31t26  : out std_logic_vector(5 downto 0);     -- Itype OpCode signal
    o_WB_RegWrAddr   : out std_logic_vector(4 downto 0);     -- Write address
    o_WB_Dmem_Addr   : out std_logic_vector(N - 1 downto 0); -- Output from the ALU
    o_WB_Dmem_out    : out std_logic_vector(N - 1 downto 0); -- Output from DMEM
    o_WB_Dmem_Lb     : out std_logic_vector(N - 1 downto 0); -- Output from byte decoder
    o_WB_Dmem_Lh     : out std_logic_vector(N - 1 downto 0); -- Output from word decoder
    o_WB_Ovfl        : out std_logic                         -- Overflow signal
  );

end entity;

architecture mixed of MEM_WB_pipe is
  -- s_D
  --   signal s_MEM_halt       : std_logic;                        -- Halt control signal
  --   signal s_MEM_MemToReg   : std_logic_vector(1 downto 0);     -- MemToReg control signal
  --   signal s_MEM_RegWrite   : std_logic;                        -- Register write control signal
  --   signal s_MEM_jal        : std_logic;                        -- Jump and link write back control signal
  --   signal s_MEM_PCP4       : std_logic_vector(N - 1 downto 0); -- PC+4 value
  --   signal s_MEM_instr31t26 : std_logic_vector(5 downto 0);     -- Itype OpCode signal
  --   signal s_MEM_RegWrAddr  : std_logic_vector(4 downto 0);     -- Write address
  --   signal s_MEM_Dmem_Addr  : std_logic_vector(N - 1 downto 0); -- Output from the ALU
  --   signal s_MEM_Dmem_out   : std_logic_vector(N - 1 downto 0); -- Output from DMEM
  --   signal s_MEM_Dmem_Lb    : std_logic_vector(N - 1 downto 0); -- Output from byte decoder
  --   signal s_MEM_Dmem_Lh    : std_logic_vector(N - 1 downto 0); -- Output from word decoder
  --   signal s_MEM_Ovfl       : std_logic;                        -- Overflow signal
  -- s_Q
  signal s_WB_halt       : std_logic;                        -- Halt control signal
  signal s_WB_MemToReg   : std_logic_vector(1 downto 0);     -- MemToReg control signal
  signal s_WB_RegWrite   : std_logic;                        -- Register write control signal
  signal s_WB_jal        : std_logic;                        -- Jump and link write back control signal
  signal s_WB_PCP4       : std_logic_vector(N - 1 downto 0); -- PC+4 value
  signal s_WB_instr31t26 : std_logic_vector(5 downto 0);     -- Itype OpCode signal
  signal s_WB_RegWrAddr  : std_logic_vector(4 downto 0);     -- Write address
  signal s_WB_Dmem_Addr  : std_logic_vector(N - 1 downto 0); -- Output from the ALU
  signal s_WB_Dmem_out   : std_logic_vector(N - 1 downto 0); -- Output from DMEM
  signal s_WB_Dmem_Lb    : std_logic_vector(N - 1 downto 0); -- Output from byte decoder
  signal s_WB_Dmem_Lh    : std_logic_vector(N - 1 downto 0); -- Output from word decoder
  signal s_WB_Ovfl       : std_logic;                        -- Overflow signal

begin

  -- The output of the FF is fixed to s_Q
  -- o_Q <= s_Q
  o_WB_halt       <= s_WB_halt;       -- Halt control signal
  o_WB_MemToReg   <= s_WB_MemToReg;   -- MemToReg control signal
  o_WB_RegWrite   <= s_WB_RegWrite;   -- Register write control signal
  o_WB_jal        <= s_WB_jal;        -- Jump and link write back control signal
  o_WB_PCP4       <= s_WB_PCP4;       -- PC+4 value
  o_WB_instr31t26 <= s_WB_instr31t26; -- Itype OpCode signal
  o_WB_RegWrAddr  <= s_WB_RegWrAddr;  -- Write address
  o_WB_Dmem_Addr  <= s_WB_Dmem_Addr;  -- Output from the ALU
  o_WB_Dmem_out   <= s_WB_Dmem_out;   -- Output from DMEM
  o_WB_Dmem_Lb    <= s_WB_Dmem_Lb;    -- Output from byte decoder
  o_WB_Dmem_Lh    <= s_WB_Dmem_Lh;    -- Output from word decoder
  o_WB_Ovfl       <= s_WB_Ovfl;       -- Overflow signal

  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize

  -- glitchy behavior on startup.
  process (i_CLK, i_RST, i_WE)
  begin
    if (i_RST = '1') then
      s_WB_halt <= '0'; -- Halt control signal
      s_WB_MemToReg <= b"00"; -- MemToReg control signal
      s_WB_RegWrite <= '0'; -- Register write control signal
      s_WB_jal <= '0'; -- Jump and link write back control signal
      s_WB_PCP4 <= x"00000000"; -- PC+4 value
      s_WB_instr31t26 <= b"000000"; -- Itype OpCode signal
      s_WB_RegWrAddr <= b"00000"; -- Write address
      s_WB_Dmem_Addr <= x"00000000"; -- Output from the ALU
      s_WB_Dmem_out <= x"00000000"; -- Output from DMEM
      s_WB_Dmem_Lb <= x"00000000"; -- Output from byte decoder
      s_WB_Dmem_Lh <= x"00000000"; -- Output from word decoder
      s_WB_Ovfl <= '0'; -- Overflow signal
    elsif ((i_CLK = '1') and i_WE = '1') then
      s_WB_halt <= i_MEM_halt; -- Halt control signal
      s_WB_MemToReg <= i_MEM_MemToReg; -- MemToReg control signal
      s_WB_RegWrite <= i_MEM_RegWrite; -- Register write control signal
      s_WB_jal <= i_MEM_jal; -- Jump and link write back control signal
      s_WB_PCP4 <= i_MEM_PCP4; -- PC+4 value
      s_WB_instr31t26 <= i_MEM_instr31t26; -- Itype OpCode signal
      s_WB_RegWrAddr <= i_MEM_RegWrAddr; -- Write address
      s_WB_Dmem_Addr <= i_MEM_Dmem_Addr; -- Output from the ALU
      s_WB_Dmem_out <= i_MEM_Dmem_out; -- Output from DMEM
      s_WB_Dmem_Lb <= i_MEM_Dmem_Lb; -- Output from byte decoder
      s_WB_Dmem_Lh <= i_MEM_Dmem_Lh; -- Output from word decoder
      s_WB_Ovfl <= i_MEM_Ovfl; -- Overflow signal
    else
      s_WB_halt <= s_WB_halt; -- Halt control signal
      s_WB_MemToReg <= s_WB_MemToReg; -- MemToReg control signal
      s_WB_RegWrite <= s_WB_RegWrite; -- Register write control signal
      s_WB_jal <= s_WB_jal; -- Jump and link write back control signal
      s_WB_PCP4 <= s_WB_PCP4; -- PC+4 value
      s_WB_instr31t26 <= s_WB_instr31t26; -- Itype OpCode signal
      s_WB_RegWrAddr <= s_WB_RegWrAddr; -- Write address
      s_WB_Dmem_Addr <= s_WB_Dmem_Addr; -- Output from the ALU
      s_WB_Dmem_out <= s_WB_Dmem_out; -- Output from DMEM
      s_WB_Dmem_Lb <= s_WB_Dmem_Lb; -- Output from byte decoder
      s_WB_Dmem_Lh <= s_WB_Dmem_Lh; -- Output from word decoder
      s_WB_Ovfl <= s_WB_Ovfl; -- Overflow signal
    end if;

  end process;

end architecture;
