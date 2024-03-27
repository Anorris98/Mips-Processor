

-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1 MUX 
--
--
-- NOTES:
-- 1/25/24 by Drew::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port (
    i_S : in std_logic;
    i_D0 : in std_logic;
    i_D1 : in std_logic;
    o_O : out std_logic);

end mux2t1;

architecture structure of mux2t1 is

  component invg
    port (
      i_A : in std_logic;
      o_F : out std_logic);
  end component;

  component org2
    port (
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic);
  end component;

  component andg2
    port (
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic);
  end component;

  -- Signal to carry inverse of sel
  signal o_s_not : std_logic;
  --Signal to carry ~s&i_D0
  signal o_ns_iD0 : std_logic;
  --signal to carry s&i_D1
  signal o_s_iD1 : std_logic;

begin

  --------------------------------------------------
  -- Level 0: Invert sel
  --------------------------------------------------
  not_1 : invg
  port map(
    i_A => i_S,
    o_F => o_s_not);

  --------------------------------------------------
  -- Level 1: AND ~sel,i_D0 as well as sel,i_D1
  --------------------------------------------------

  and_1 : andg2
  port map(
    i_A => o_s_not,
    i_B => i_D0,
    o_F => o_ns_iD0);

  and_2 : andg2
  port map(
    i_A => i_S,
    i_B => i_D1,
    o_F => o_s_iD1);

  --------------------------------------------------
  -- Level 2: Or the final result
  --------------------------------------------------

  or_1 : org2
  port map(
    i_A => o_ns_iD0,
    i_B => o_s_iD1,
    o_F => o_O);

end structure;