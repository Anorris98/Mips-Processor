-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- and_1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input AND 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-- 3/5/24 by Alek:: Changed name to fit personal naming convention better.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity and_1 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end and_1;

architecture dataflow of and_1 is
begin

  o_F <= i_A and i_B;
  
end dataflow;
