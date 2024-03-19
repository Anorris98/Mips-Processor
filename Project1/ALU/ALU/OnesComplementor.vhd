-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of a ones Complimentor while using invg.vhd
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--Entity define-----------------------------------------
entity OnesComplementor is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  Port (  i_D0  : in  std_logic_vector(N-1 downto 0);
          o_O   : out std_logic_vector(N-1 downto 0));

end OnesComplementor;
--Entity define-----------------------------------------

--Structural define--------------------------------------
architecture Structural of OnesComplementor is

--Component define---------------------------------------
component invg is
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;
--Component define---------------------------------------

begin

  -- Instantiate N OnesComplementor instances.
  G_NBit_OnesComplementor: for i in 0 to N-1 generate
    OnesComp: invg port map(
              i_A      => i_D0(i),  -- All instances use the ith bit
              o_F      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_OnesComplementor;

end Structural;
--Structural define--------------------------------------