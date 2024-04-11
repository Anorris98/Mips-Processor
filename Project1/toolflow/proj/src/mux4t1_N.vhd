
-------------------------------------------------------------------------
-- @author Drew Kearns
-- @Creation: 3/5/2024
-- @Updated: by Alek Norris 3/25/2024 - made into a generic
-- Iowa State University
-- CPRE 381
-- Implimentation of an N bit 4 to 1 mux.
-- As desired.
-- mux4t1_N.vhd
-------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mux4t1_N is
  generic(N : integer := 5); 
  port (i_w0, i_w1, i_w2, i_w3 : in  std_logic_vector(N - 1 downto 0);
        i_s0, i_s1             : in  std_logic;
        o_Y                    : out std_logic_vector(N - 1 downto 0));
end entity;

architecture Dataflow of mux4t1_N is
begin
  o_Y <= i_w0 when (i_s1 & i_s0) = std_logic_vector(to_unsigned(0, 2)) else
         i_w1 when (i_s1 & i_s0) = std_logic_vector(to_unsigned(1, 2)) else
         i_w2 when (i_s1 & i_s0) = std_logic_vector(to_unsigned(2, 2)) else
         i_w3 when (i_s1 & i_s0) = std_logic_vector(to_unsigned(3, 2)) else
                                                                      (others => '0');
end architecture;

