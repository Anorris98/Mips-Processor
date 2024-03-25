-------------------------------------------------------------------------
-- @author Alek Norris
-- @Creation: 3/25/2024
-- Iowa State University
-- CPRE 381
-- Implimentation of a word Decoder. Hooks up after the dmem to allow for word addressable memory.
-- WordDecoder.vhd
-------------------------------------------------------------------------

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;  
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WordDecoder is
  port (
    i_word      : in  std_logic_vector(31 downto 0); -- Instruction bits 31-26
    i_offset    : in  std_logic;                     -- offset 0 = 15-0, offset 1 = 31-16
    o_Output    : out std_logic_vector(31 downto 0)
  );

end entity;

architecture behavior of WordDecoder is

begin
  op: process (i_word, i_offset) --if the offset or the word change, we can  update.
  
begin
    case i_offset is
        when '0' =>   --offset 0
            o_Output <= x"0000" & i_word(15 downto 0);
        when '1' =>   --offset 1
            o_Output <= x"0000" & i_word(31 downto 16);
        when others =>
            o_Output <= (others => '0'); -- Default case
    end case;
      end process;
end architecture;


