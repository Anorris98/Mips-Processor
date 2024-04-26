-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/5/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of an N bit nor gate, allowing as many bits to be used
-- As desired.

-- nornBit.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity norg_N is
  generic(N : integer := 32);
  port(i_A	    : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       o_Out    : out std_logic_vector(N-1 downto 0));
end norg_N;

architecture structure of norg_N is

component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal w_Out : std_logic_vector(N-1 downto 0);

begin
G1: for i in 0 to N-1 generate
  or_i: org2 port map(i_A(i),i_B(i),w_Out(i));
  o_Out(i) <= NOT w_Out(i); 
end generate;
end structure;