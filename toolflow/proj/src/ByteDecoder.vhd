-- --------------------------------------------------------------------------
-- -- @author Alek Norris
-- -- @Creation: 3/25/2024
-- -- Iowa State University
-- -- CPRE 381
-- -- Implementation of a Byte Decoder. Hooks up after the dmem to allow for byte addressable memory.
-- -- ByteDecoder.vhd
-- --------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ByteDecoder is
  port (
    i_word      : in  std_logic_vector(31 downto 0); -- Input word
    i_offset    : in  std_logic_vector(1 downto 0);  -- Two bits for 0 to 3 offsets
    o_Output    : out std_logic_vector(31 downto 0); -- Output port
    i_signed    : in  std_logic                      -- Sign flag: '1' for signed, '0' for unsigned
  );
end entity;

architecture behavior of ByteDecoder is

  -- Function to determine padding based on sign bit and i_signed
  function get_padding(sign_bit: std_logic; is_signed: std_logic) return std_logic_vector is
  begin
    if is_signed = '1' and sign_bit = '1' then
      return (x"FFFFFF"); -- If signed and negative, pad with '1's
    else
      return (x"000000"); -- Otherwise, pad with '0's
    end if;
  end function;

begin
  op: process (i_word, i_offset, i_signed)
  begin
    case i_offset is
      when "00" => --byte [0]
          o_Output <= get_padding(i_word(7), i_signed) & i_word(7 downto 0);
      when "01" => --byte [1]
          o_Output <= get_padding(i_word(15), i_signed) & i_word(15 downto 8);
      when "10" => --byte [2]
          o_Output <= get_padding(i_word(23), i_signed) & i_word(23 downto 16);
      when "11" => --byte [3]
          o_Output <= get_padding(i_word(31), i_signed) & i_word(31 downto 24);
      when others =>
          o_Output <= (others => '0'); -- Default case, set all to zeros.
    end case;
  end process;
end architecture;


