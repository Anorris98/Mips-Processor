
-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/5/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of an N bit 8 to 1 mux.
-- As desired.

-- mux8t1_N.vhd
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8t1_N is
    generic(N : integer := 32);
    port(i_w0, i_w1, i_w2, i_w3, 
         i_w4, i_w5, i_w6, i_w7 : in std_logic_vector(N-1 downto 0);
         i_s0, i_s1, i_s2       : in std_logic;
         o_Y                    : out std_logic_vector(N-1 downto 0));
end mux8t1_N;

architecture Dataflow of mux8t1_N is
begin
    o_Y <= i_w0 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(0, 3)) else
           i_w1 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(1, 3)) else
           i_w2 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(2, 3)) else
           i_w3 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(3, 3)) else
           i_w4 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(4, 3)) else
           i_w5 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(5, 3)) else
           i_w6 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(6, 3)) else
           i_w7 when (i_s2 & i_s1 & i_s0) = std_logic_vector(to_unsigned(7, 3)) else
           (others => '0');
end Dataflow;

