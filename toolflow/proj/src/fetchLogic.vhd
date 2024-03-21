-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fetchLogic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the fetch logic
-- for our MIPS processor. Wire names and names of components are taken
-- from the Top Level Design drawing.
-------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;

entity fetchLogic is
  generic (N : integer := 32);
  port (
    i_jump_C          : in  std_logic;
    i_jr_ra_C         : in  std_logic;
    i_CLK             : in  std_logic;
    i_RST             : in  std_logic;
    i_w_branch_n_ALUo : in  std_logic;
    i_instr_25t0      : in  std_logic_vector(25 downto 0);
    i_ext_imm         : in  std_logic_vector(N - 1 downto 0);
    i_jr_ra_pc_next   : in  std_logic_vector(N - 1 downto 0);
    o_pc_p4           : out std_logic_vector(N - 1 downto 0);
    o_pc_next         : out std_logic_vector(N - 1 downto 0));
end entity;

architecture structural of fetchLogic is
  component RippleCarryAdder is
    generic (N : integer := 32);
    port (
      A        : in  std_logic_vector(N - 1 downto 0);
      B        : in  std_logic_vector(N - 1 downto 0);
      Carry    : out std_logic;
      Sum      : out std_logic_vector(N - 1 downto 0);
      Overflow : out std_logic);
  end component;

  component mux2t1_N is
    generic (N : integer := 32);
    port (
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(N - 1 downto 0);
      i_D1 : in  std_logic_vector(N - 1 downto 0);
      o_O  : out std_logic_vector(N - 1 downto 0));
  end component;

  component pc_dffg is
    generic (N : integer := 32);
    port (
      i_CLK : in  std_logic;                        -- Clock input
      i_RST : in  std_logic;                        -- Reset input
      i_WE  : in  std_logic;                        -- Write enable input
      i_D   : in  std_logic_vector(N - 1 downto 0); -- Data value input
      o_Q   : out std_logic_vector(N - 1 downto 0)); -- Data value output
  end component;

  signal w_add0_mux      : std_logic_vector(N - 1 downto 0); -- Same signal as w_add0_add1
  signal w_pc_add0       : std_logic_vector(N - 1 downto 0);
  signal w_shift_add1    : std_logic_vector(N - 1 downto 0);
  signal w_add1_mux2     : std_logic_vector(N - 1 downto 0);
  signal w_mux2_mux3     : std_logic_vector(N - 1 downto 0);
  signal w_mux3_mux5     : std_logic_vector(N - 1 downto 0);
  signal w_pc_next       : std_logic_vector(N - 1 downto 0);
  signal w_s120_o        : std_logic_vector(27 downto 0);
  signal w_pc4_s120_o    : std_logic_vector(N - 1 downto 0);
  signal s_add0_carry    : std_logic;
  signal s_add1_carry    : std_logic;
  signal s_add0_overflow : std_logic;   -- 1 if overflow
  signal s_add1_overflow : std_logic;   -- 1 if overflow

begin

  add0: RippleCarryAdder
    port map (
      A        => w_pc_add0,
      B        => x"00000004",
      Sum      => w_add0_mux,
      Carry    => s_add0_carry,
      Overflow => s_add0_overflow);

  o_pc_p4 <= w_add0_mux;

  -- Jump location
  w_s120_o <= i_instr_25t0 & b"00"; -- shift_left2_0

  -- (29 downto 0) chops of top 2 MSB, & b"00" appends 2 0s to the end of the vector
  w_shift_add1 <= i_ext_imm(29 downto 0) & b"00"; -- shift_left2_1

  add1: RippleCarryAdder
    port map (
      A        => w_add0_mux,
      B        => w_shift_add1,
      Sum      => w_add1_mux2,
      Carry    => s_add1_carry,
      Overflow => s_add1_overflow);

  mux2: mux2t1_N
    port map (
      i_S  => i_w_branch_n_ALUo,
      i_D0 => w_add0_mux,
      i_D1 => w_add1_mux2,
      o_O  => w_mux2_mux3);

  -- Upper 4 bits don't change, add to jump location
  w_pc4_s120_o <= w_add0_mux(31 downto 28) & w_s120_o;

  mux3: mux2t1_N
    port map (
      i_S  => i_jump_C,
      i_D0 => w_mux2_mux3,
      i_D1 => w_pc4_s120_o,
      o_O  => w_mux3_mux5);

  mux5: mux2t1_N
    port map (
      i_S  => i_jr_ra_C,
      i_D0 => w_mux3_mux5,
      i_D1 => i_jr_ra_pc_next,
      o_O  => w_pc_next);

  pc: pc_dffg
    port map (
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE  => '1',
      i_D   => w_pc_next,
      o_Q   => w_pc_add0);

  o_pc_next <= w_pc_add0;

end architecture;
