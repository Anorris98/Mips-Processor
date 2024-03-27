-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/5/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of an N bit and gate, allowing as many bits to be used
-- As desired.

-- and_N.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity and_N is
  generic(N : integer := 32);
  port(i_A	    : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       o_Out    : out std_logic_vector(N-1 downto 0));
end and_N;

architecture structure of and_N is

component and_1
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

begin
G1: for i in 0 to N-1 generate
  and_i: and_1
 port map(i_A(i),i_B(i),o_Out(i));
end generate;
end structure;