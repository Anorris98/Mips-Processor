-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_N is
  generic (N : integer := 32);
  port (
    i_CLK : in std_logic; -- Clock input
    i_RST : in std_logic; -- Reset input
    i_WE : in std_logic; -- Write enable input
    i_D : in std_logic_vector(N - 1 downto 0); -- Data value input
    o_Q : out std_logic_vector(N - 1 downto 0)); -- Data value output

end dffg_N;

architecture structural of dffg_N is
  component dffg is
    port (
      i_CLK : in std_logic; -- Clock input
      i_RST : in std_logic; -- Reset input
      i_WE : in std_logic; -- Write enable input
      i_D : in std_logic; -- Data value input
      o_Q : out std_logic); -- Data value output
  end component;

  signal s_Q : std_logic_vector(N - 1 downto 0); -- Output of the FF

begin

  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;

  Nbit_dffg : for i in 0 to N - 1 generate
    DFFGG : dffg port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => i_WE,
      i_D => i_D(i),
      o_Q => s_Q(i));
  end generate Nbit_dffg;

end structural;