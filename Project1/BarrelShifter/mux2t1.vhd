-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of a 2:1 mux using structur
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


--Entity define-----------------------------------------
entity mux2t1 is

  Port (    i_D0:   in std_logic;
            i_D1:   in std_logic;
            i_S:    in std_logic;
            o_O:    out std_logic);

end mux2t1;
--Entity define------------------------------------------

--Structural define--------------------------------------
architecture Structural of mux2t1 is

component andg2 is --And Gate
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is  --Or gate
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component invg is   --not gate
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

    -- Internal wires
    signal D1andiS, D0andNotiS, notiS : std_logic;


    begin
    ---------------------------------------------------------------------------
    -- Level 0: connections from input
    ---------------------------------------------------------------------------
        invg0: invg --not i_S
            port map(
                    i_A     => i_S,  -- All instances use the ith bit
                    o_F     => notiS);  -- ith instance's data output hooked up to ith data output.

        and1: andg2 --d0 and not i_S
            port MAP(i_A    => i_D0,
                    i_B     => notiS,
                    o_F     => D0andNotiS);       

        and0: andg2 --D1 and i_S
            port MAP(i_A    => i_D1,
                    i_B     => i_S,
                    o_F     => D1andiS);

    ---------------------------------------------------------------------------
    -- Level 1: No connections directly from input
    ---------------------------------------------------------------------------
        Org0: org2 --D1 and i_S, or D0 and not i_S
            port MAP(i_A    => D1andiS,
                    i_B     => D0andNotiS,
                    o_F     => o_O);

    ---------------------------------------------------------------------------
    -- Level 2: all inputs atleast 2 gates deep
    ---------------------------------------------------------------------------
end Structural;
