-- Drew Kearns
-- tb_Controller.vhd
-------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_Controller is
  generic (gCLK_HPER : time := 50 ns);
end entity;

architecture behavior of tb_Controller is

  constant N : integer := 32;
  -- Component Declaration for the Unit Under Test (UUT)
  constant cCLK_PER : time := gCLK_HPER * 2;
  component Controller
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

  signal s_CLK           : std_logic;

  --Inputs
  signal s_instr31_26 : std_logic_vector(5 downto 0);
  signal s_instr5_0 : std_logic_vector(5 downto 0);

  --Outputs
  signal s_halt, s_STD_SHIFT, s_RegWrite, s_MemWrite, s_Alu_Src, s_ext_ctl, s_Jump, s_jr, s_jal : std_logic;
  signal s_ALU_Ctl : std_logic_vector(7 downto 0);
  signal s_MemtoReg, s_RegDst : std_logic_vector(1 downto 0);


begin

  -- Instantiate the Unit Under Test (UUT)
  uut: Controller
    port map (
      i_instruct31_26  => s_instr31_26,
      i_instruct5_0    => s_instr5_0,
      o_halt           => s_halt,
      o_STD_SHIFT      => s_STD_SHIFT, -- Standard shift (1)we are doing a normal shift (0) we are doing a variable shift or does not matter.
      o_ALU_Ctl        => s_ALU_Ctl,
      o_RegWrite       => s_RegWrite,
      o_MemtoReg       => s_MemtoReg,
      o_MemWrite       => s_MemWrite,
      o_RegDst         => s_RegDst,
      o_Alu_Src        => s_Alu_Src,
      o_ext_ctl        => s_ext_ctl,
      o_Jump           => s_Jump,
      o_jr             => s_jr,
      o_jal            => s_jal
    );

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.

  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  ----------------------------------
  -- Test bench
  ----------------------------------

  P_TB: process
  begin

    --------------------------------------
    -- R-type tests
    --------------------------------------
    s_instr31_26 <= b"00000";
    
    wait for cCLK_PER;

    wait;
  end process;

end architecture;
