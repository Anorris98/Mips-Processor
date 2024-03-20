-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/5/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of an N bit or gate, allowing as many bits to be used
-- As desired.

-- ornBit.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity or_N is
  generic(N : integer := 32);
  port(i_A	    : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       o_Out    : out std_logic_vector(N-1 downto 0));
end or_N;

architecture structure of or_N is

component or_1
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

begin
G1: for i in 0 to N-1 generate
  or_i: or_1 port map(i_A(i),i_B(i),o_Out(i));
end generate;
end structure;