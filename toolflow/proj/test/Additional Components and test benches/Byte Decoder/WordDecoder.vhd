
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WordDecoder is
  port (
    i_word      : in  std_logic_vector(31 downto 0); -- Input word
    i_offset    : in  std_logic;                     -- only 1 bit, no offset, or 1 offset.
    o_Output    : out std_logic_vector(31 downto 0); -- Output port
    i_signed    : in  std_logic                      -- Sign flag: '1' for signed, '0' for unsigned
  );
end entity;

architecture behavior of WordDecoder is

  -- Function to determine padding based on sign bit and i_signed
  function get_padding(sign_bit: std_logic; is_signed: std_logic) return std_logic_vector is
  begin
    if is_signed = '1' and sign_bit = '1' then
      return (x"FFFF"); -- If signed and negative, pad with '1's
    else
      return (x"0000"); -- Otherwise, pad with '0's
    end if;
  end function;

begin
  op: process (i_word, i_offset, i_signed)
  begin
    case i_offset is
      when '0' => -- Half-word [0]
          o_Output <= get_padding(i_word(15), i_signed) & i_word(15 downto 0);
      when '1' => -- Half-word [1]
          o_Output <= get_padding(i_word(31), i_signed) & i_word(31 downto 16);
      when others =>
          o_Output <= (others => '0'); -- Default case, set all to zeros.
    end case;
  end process;
end architecture;