-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of a controller for a MIPS processor
--------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;

  --Entity define-------------------------------------------------------------

entity Controller is
  port (i_instruct31_26 : in  std_logic_vector(5 downto 0);
        i_instruct5_0   : in  std_logic_vector(5 downto 0);
        o_STD_SHIFT   : out std_logic;  -- Standard shift (1)we are doing a normal shift (0) we are doing a variable shift or does not matter.
        o_ALU_Ctl     : out std_logic_vector(5 downto 0);
        o_RegWrite    : out std_logic;
        o_MemtoReg    : out std_logic;
        o_MemWrite    : out std_logic;
        o_RegDst      : out std_logic_vector(1 downto 0);
        o_Branch      : out std_logic;
        o_Alu_Src     : out std_logic;
        o_ext_ctl     : out std_logic;
        o_Jump        : out std_logic;
        o_jr          : out std_logic;
        o_jal         : out std_logic);
end entity;
--Entity define-------------------------------------------------------------
--Structural define---------------------------------------------------------

architecture structure of Controller is

  --Component define----------------------------------------------------------
  component ControlDecoderLogic is
    port (
      i_instruct31_26 : in  std_logic_vector(5 downto 0);
      i_instruct5_0   : in  std_logic_vector(5 downto 0);
      o_Output        : out std_logic_vector(17 downto 0)
    );
  end component;

  --Signals
  signal DecoderOutput : std_logic_vector(17 downto 0);
  signal w_STD_SHIFT   : std_logic;
  signal w_Alu_Src     : std_logic;
  signal w_ALU_Ctl     : std_logic_vector(5 downto 0);
  signal w_RegWrite    : std_logic;
  signal w_MemtoReg    : std_logic;
  signal w_MemWrite    : std_logic;
  signal w_RegDst      : std_logic_vector(1 downto 0);
  signal w_Branch      : std_logic;
  signal w_ext_ctl     : std_logic;
  signal w_Jump        : std_logic;
  signal w_jr          : std_logic;
  signal w_jal         : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: All connection from input
  ---------------------------------------------------------------------------

  ControllerDecoder_0: ControlDecoderLogic
    port map (
      i_instruct31_26 => i_instruct31_26,
      i_instruct5_0   => i_instruct5_0,
      o_Output        => DecoderOutput
      );


  
  ---------------------------------------------------------------------------
  -- Level 1: All inputs atleast one gate deep
  ---------------------------------------------------------------------------
  --Output map to signals.
  o_STD_SHIFT   <= w_STD_SHIFT;
  o_ALU_Ctl     <= w_ALU_Ctl;
  o_RegWrite    <= w_RegWrite;
  o_MemtoReg    <= w_MemtoReg;
  o_MemWrite    <= w_MemWrite;
  o_RegDst      <= w_RegDst;
  o_Branch      <= w_Branch;
  o_Alu_Src     <= w_Alu_Src;
  o_ext_ctl     <= w_ext_ctl;
  o_Jump        <= w_Jump;
  o_jal         <= w_jal;
  o_jr          <= w_jr;

-- signals hooking up and stripping the correct bit.
  w_STD_SHIFT   <= DecoderOutput(17);
  w_Alu_Src     <= DecoderOutput(16);
  w_ALU_Ctl     <= DecoderOutput(15 downto 10);
  w_MemtoReg    <= DecoderOutput(9);
  w_MemWrite    <= DecoderOutput(8);
  w_RegWrite    <= DecoderOutput(7);
  w_RegDst      <= DecoderOutput(6 downto 5);
  w_Jump        <= DecoderOutput(4);
  w_Branch      <= DecoderOutput(3);
  w_ext_ctl     <= DecoderOutput(2);
  w_jal         <= DecoderOutput(1);
  w_jr          <= DecoderOutput(0);
end architecture;
