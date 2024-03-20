-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of an Adder via structure
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--Entity define-------------------------------------------------------------
entity Adder is
  --generic(N : integer := 32); -- Generic of type integer for input/output data width.
  Port (    i_D0  : in  std_logic;  --input1
            i_D1  : in  std_logic;  --input2
            i_Cin : in  std_logic;  --carry in
            o_S   : out std_logic;  --Standard output
            o_C   : out std_logic); --Carry output

end Adder;
--Entity define-------------------------------------------------------------

--Structural define---------------------------------------------------------
architecture structure of Adder is

--Component define----------------------------------------------------------
component andg2 is --And Gate

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component xorg2 is --Xor Gate

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component org2 is  --Or gate

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

--Signal D0 && D1 Xord
signal D0XorD1          :std_logic;
--Signal i_Cin && D0XorD1
signal CinAndD0XorD1    :std_logic;
--Signal i_Cin Xor D0XorD1
--signal D0xorD1XorCin    :std_logic;
--Signal D0 && D1
signal D0andD1          :std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: All connection from input
  ---------------------------------------------------------------------------
Xor0: xorg2
    port MAP(i_A             => i_D0,
             i_B             => i_D1,
             o_F             => D0XorD1);
             
and0: andg2
    port MAP(i_A             => i_D0,
             i_B             => i_D1,
             o_F             => D0andD1);
  ---------------------------------------------------------------------------
  -- Level 1: All inputs atleast one gate deep
  ---------------------------------------------------------------------------
and1: andg2
    port MAP(i_A             => D0XorD1,
             i_B             => i_Cin,
             o_F             => CinAndD0XorD1);

Xor1: xorg2
    port MAP(i_A             => D0XorD1,
             i_B             => i_Cin,
             o_F             => o_S);
  ---------------------------------------------------------------------------
  -- Level 2: all inputs atleast 2 gates deep
  ---------------------------------------------------------------------------
or0: org2
    port MAP(i_A             => CinAndD0XorD1,
             i_B             => D0andD1,
             o_F             => o_C);

  end structure;