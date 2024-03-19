-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/5/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of an N bit xor gate, allowing as many bits to be used
-- As desired.

-- xor_N.vhd
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity xor_N is
  generic(N : integer := 32);
  port(i_A	    : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       o_out    : out std_logic_vector(N-1 downto 0));
end xor_N;

architecture structure of xor_N is

component xor_1
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F        : out std_logic);
end component;

begin
G1: for i in 0 to N-1 generate
  xor_i: xor_1 port map(i_A(i),i_B(i),o_out(i));
end generate;
end structure;