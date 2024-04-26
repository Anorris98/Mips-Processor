-- extender16t32.vhd
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity extender16t32 is
    port (
        i_Imm16 : in std_logic_vector(15 downto 0);
        i_ctl : in std_logic;
        o_Imm32 : out std_logic_vector(31 downto 0));
end extender16t32;

architecture dataflow of extender16t32 is
begin
    o_Imm32 <= x"0000" & i_Imm16 when (i_ctl = '0' or i_Imm16(15) = '0') else
               x"FFFF" & i_Imm16;
end dataflow;